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
@synthesize progressOverlayView;
@synthesize errorOverlayView;
@synthesize picture;
@synthesize leftBorder;
@synthesize cancelButton;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor blackColor]];
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(finishedPictureUpload:) name:uSnapPictureUploadFinishedSuccess object:nil];
        CGRect frame = [[self progressView]frame];
        frame.size.height = 20;
        [[self progressView]setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 20)];
        
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
    CGRect frame = [[self progressView]frame];
    frame.size.height = 20;
    [[self progressView]setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 35)];
    [[self progressOverlayView]setHidden:YES];
    [[self errorOverlayView]setHidden:YES];
    UIImage *thumbnailImage;
    
    if([[self picture]resourceLocation]){
        thumbnailImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[self picture] getThumbnailPath]]];
        
        Event *pictureEvent = (Event*)[[self picture]event];
        if([[pictureEvent eventKey]compare:VoidEventKey]!=NSOrderedSame){
            if([[[self picture] error]boolValue]){
                [self showErrorOverlay]; 
            }
            else if(![[[self picture]uploaded]boolValue]){
                [self showProgressView];
            }
        }

    }
    else{
        thumbnailImage = [UIImage imageNamed:@"stream-processing.png"];
    }
    
    [[self photoView]setImage:thumbnailImage] ;
   
     
    
    
    [self layoutSubviews];
}
-(void) dealloc{
    
    [self setPhotoView:nil];

    [self setEditButton:nil];
    if([self picture]){
    [[self picture]removeObserver:self forKeyPath:@"resourceLocation"];
    }
    USTAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [[appDelegate fileUploadHandler]deregisterUploadProgress:[self progressView]];
    [self setPicture:nil];
    [self setErrorOverlayView:nil];
    [self setProgressView:nil];
    [self setProgressOverlayView:nil];
    [self setCancelButton:nil];    
    
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
     [[self cancelButton]setEnabled:YES];
    
    USTAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if([[appDelegate fileUploadHandler]getUploadForPicture:[self picture]]){
    [[appDelegate fileUploadHandler]deregisterUploadProgress:[self progressView]];
    
    [[self progressView]setProgress:0];
    [[appDelegate fileUploadHandler]registerUploadProgress:[self progressView] ForPictureId:[[[self picture]objectID]URIRepresentation]];

    [[self progressOverlayView]setHidden:NO];
    }
    else
    {
        
        //TODO: show some option to restart upload
    }

}
-(void)removeErrorAndProgressViews{
    //removed already
}
-(void)finishedPictureUpload:(NSNotification *)notification{

    NSURL *thisPictureId = [notification object];
  
    if([thisPictureId isEqual:[[[self picture]objectID]URIRepresentation]]){
        [[self progressOverlayView]setHidden:YES];
       }
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if(context==uSTPictureResourceLocationChangedContext){
        [self updateView];
    }
}
-(IBAction)touchCancelButton:(id)sender
{
   [[self cancelButton]setEnabled:NO];
    USTAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if([[appDelegate fileUploadHandler]cancelUploadForPicture:[self picture]]){
        NSManagedObjectContext *context=[[[self picture]managedObjectContext]retain];
        NSFileManager*fm = [NSFileManager defaultManager];
        NSError *error;
        
        if(![fm removeItemAtPath:[[self picture] getFullPath] error:&error]){
                        NSLog(@"%@",[error description]);
        }
        error = nil;
        
        if(![fm removeItemAtPath:[[self picture] getThumbnailPath] error:&error]){
                        NSLog(@"%@",[error description]);
        }
        [context deleteObject:[self picture]];
        error = nil;
        [context save:&error];
        if(error){
            NSLog(@"%@",[error description]);
        }
        [context release];
        [self setPicture:nil];
    };

}

@end
