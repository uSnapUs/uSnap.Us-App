//
//  PictureUpload.m
//  uSnap.us
//
//  Created by Owen Evans on 25/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import "PictureUpload.h"
#import "ASIFormDataRequest.h"
#import "USTAppDelegate.h"
#import "constants.h"
#import "TestFlight.h"
@implementation PictureUpload
@synthesize picture;
@synthesize progressDelegate;
@synthesize percentUploaded;
-(void) requestFinished:(ASIHTTPRequest *)request{
//    USTAppDelegate* appDelegate = [[UIApplication sharedApplication]delegate];
    
    [TestFlight passCheckpoint:@"uploaded a picture"];
    [picture setUploaded:[NSNumber numberWithBool:YES]];
    NSError *error;
    [[picture managedObjectContext]save:&error];
    if(error){
        NSLog(@"Save produced error %@",[error description]);
    }
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:uSnapPictureUploadFinishedSuccess object:self];
}
-(void) requestFailed:(ASIHTTPRequest *)request{
    USTAppDelegate* appDelegate = [[UIApplication sharedApplication]delegate];
    [picture setError:[NSNumber numberWithBool:YES]];
    NSError *error;
    [[appDelegate managedObjectContext]save:&error];
    if(error){
        NSLog(@"Save error produced error %@",[error description]);
    }
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:uSnapPictureUploadFinishedSuccess object:self];
    //NSLog(@"Picture upload for %@ failed",[[[self picture]objectID]description]);
}
-(void)start{
    [[self picture] setUploaded:[NSNumber numberWithBool:NO]];
    [[self picture] setUploadedBytes:[NSNumber numberWithInt:0]];
    // NSError *err;
    USTAppDelegate *appDelegate =  [[UIApplication sharedApplication]delegate];
    Event *currentEvent = [[appDelegate locationHandler]currentEvent];
    NSString *photoUrl = [NSString stringWithFormat:@"http://usnap.us/events/%@/photos.json",[currentEvent serverId]];
    //[[self managedObjectContext]save:&err];
    NSURL *postUrl = [NSURL URLWithString:photoUrl];
    ASIFormDataRequest *formRequest = [ASIFormDataRequest requestWithURL:postUrl];
    [formRequest setFile:[[self picture] getFullPath] withFileName:@"photo.jpg" andContentType:@"image/jpeg" forKey:@"photo[photo]"];
    [formRequest addPostValue:[[appDelegate registrationManager]serverDeviceId]forKey:@"photo[device_id]"];
    [formRequest setShouldStreamPostDataFromDisk:YES];
    [formRequest setAllowCompressedResponse:YES];
    [formRequest setUploadProgressDelegate:self];
    //[formRequest shouldCompressRequestBody:YES];
    [formRequest setUploadProgressDelegate:self];
    //[formRequest showAccurateProgress:YES];
    [formRequest setDelegate:self];
    [self setPercentUploaded:0];
    [formRequest startAsynchronous];
}
-(void)setProgress:(float)newProgress{
    
    NSLog(@"New progress %f",newProgress);
    [self setPercentUploaded:newProgress];
}

@end
