//
//  PictureUpload.m
//  uSnap.us
//
//  Created by Owen Evans on 25/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import "PictureUpload.h"
#import "ASIFormDataRequest.h"
@implementation PictureUpload
@synthesize picture;

-(void) requestFinished:(ASIHTTPRequest *)request{
     NSLog(@"Picture upload for %@ passed",[[[self picture]objectID]description]);
}
-(void) requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"Picture upload for %@ failed",[[[self picture]objectID]description]);
}
-(void) request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes{
  NSLog(@"%llu bytes upload for %@",bytes,[[[self picture]objectID]description]);
}
-(void)start{
    [[self picture] setUploaded:[NSNumber numberWithBool:NO]];
    [[self picture] setUploadedBytes:[NSNumber numberWithInt:0]];
    // NSError *err;
    //[[self managedObjectContext]save:&err];
    NSURL *postUrl = [NSURL URLWithString:@"http://192.168.0.106:3000/photos"];
    ASIFormDataRequest *formRequest = [ASIFormDataRequest requestWithURL:postUrl];
    [formRequest setFile:[[self picture] getFullPath] withFileName:@"photo.jpg" andContentType:@"image/jpeg" forKey:@"photo[photo]"];
    [formRequest setShouldStreamPostDataFromDisk:YES];
    [formRequest setAllowCompressedResponse:YES];
    //[formRequest shouldCompressRequestBody:YES];
    [formRequest setUploadProgressDelegate:self];
    //[formRequest showAccurateProgress:YES];
    [formRequest setDelegate:self];
    [formRequest startAsynchronous];
}
@end
