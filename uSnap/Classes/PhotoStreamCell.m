//
//  PhotoStreamCell.m
//  uSnap.us
//
//  Created by Owen Evans on 26/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import "PhotoStreamCell.h"
#import "constants.h"
#import "USTAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
@implementation PhotoStreamCell
@synthesize photoView;
@synthesize editButton;
@synthesize progressView;
@synthesize pictureUpload;
@synthesize progressOverlayView;
@synthesize errorOverlayView;
@synthesize picture;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor blackColor]];
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(finishedPictureUpload:) name:uSnapPictureUploadFinishedSuccess object:nil];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)configureWithPicture:(Picture*)newPicture{
    if([self picture]){
        [[self picture]removeObserver:self forKeyPath:@"resourceLocation"];
    }
    [newPicture addObserver:self forKeyPath:@"resourceLocation" options:NSKeyValueObservingOptionNew context:uSTPictureResourceLocationChangedContext];
    [self setPicture:newPicture];
    [self updateView];
}
-(void)updateView{
    [[self progressOverlayView]setHidden:YES];
    [[self errorOverlayView]setHidden:YES];
    UIImage *thumbnailImage;
    
    if([[self picture]resourceLocation]){
        thumbnailImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[self picture] getThumbnailPath]]];
    }
    else{
        thumbnailImage = [UIImage imageNamed:@"image_placeholder.png"];
    }
    [[self photoView]setImage:thumbnailImage];
    [[[self photoView]layer]setBorderColor:[[UIColor blackColor]CGColor]];
    [[[self photoView]layer]setBorderWidth:1];
    Event *pictureEvent = (Event*)[[self picture]event];
    if([[pictureEvent eventKey]compare:VoidEventKey]!=NSOrderedSame){
    if([[[self picture] error]boolValue]){
        [self showErrorOverlay]; 
    }
    else if(![[[self picture]uploaded]boolValue]){
        [self showProgressView];
    }
    }
   
    
    
    [self layoutSubviews];
}

-(void) dealloc{
    
    [self setPhotoView:nil];

    [self setEditButton:nil];
    if([self picture]){
    [[self picture]removeObserver:self forKeyPath:@"resourceLocation"];
    }
    if([self pictureUpload]){
        [[self pictureUpload]removeObserver:self forKeyPath:@"percentUploaded"];
    }

    [self setPictureUpload:nil];
    [self setPicture:nil];
    [self setErrorOverlayView:nil];
    [self setProgressView:nil];
    [self setProgressOverlayView:nil];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
    [super dealloc];
}

-(void)showErrorOverlay{
    [[self errorOverlayView]setHidden:NO];
}
-(void)retryUpload{
    NSLog(@"retry selected");
}
-(void)showProgressView{
    USTAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if([self pictureUpload]){
        [[self pictureUpload]removeObserver:self forKeyPath:@"percentUploaded"];
    }
    
    [self setPictureUpload:[[appDelegate fileUploadHandler]getUploadForPicture:[self picture]]];
    if([self pictureUpload]){
        NSLog(@"Adding KVO");
        [[self pictureUpload]addObserver:self forKeyPath:@"percentUploaded" options:NSKeyValueObservingOptionNew context:uSnapPictureUploadProgressUpdate];
    }
    [[self progressView]setProgress:[[self pictureUpload]percentUploaded]animated:YES];
    [[self progressOverlayView]setHidden:NO];

}
-(void)removeErrorAndProgressViews{
    //removed already
}
-(void)finishedPictureUpload:(NSNotification *)notification{

    PictureUpload *thisPictureUpload = [notification object];
    NSLog(@"1:%@",[[[thisPictureUpload picture]objectID]URIRepresentation]);
    NSLog(@"2:%@",[[[self picture]objectID]URIRepresentation]);
    if([[[[thisPictureUpload picture]objectID]URIRepresentation]isEqual:[[[self picture]objectID]URIRepresentation]]){
        NSLog(@"removing progress view");   
        [[self progressOverlayView]setHidden:YES];
       }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if(context==uSTPictureResourceLocationChangedContext){
        [self updateView];
    }
    if(context==uSnapPictureUploadProgressUpdate){
        NSLog(@"Updating Progress");
        [[self progressView]setProgress:[[self pictureUpload]percentUploaded]animated:YES];
    }
}
@end
