//
//  FileUploadHandler.m
//  uSnap.us
//
//  Created by Owen Evans on 25/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import "FileUploadHandler.h"
#import "PictureUpload.h"
#import "constants.h"
#import "ASIHTTPRequest.h"
@implementation FileUploadHandler
@synthesize queue;
@synthesize progressViews;
-(id)init{
    self = [super init];
    if(self){
        [self setProgressViews:[[[NSMutableDictionary alloc]init ]autorelease]];
    }
    return self;
}

-(void) dealloc{
    if(queue!=nil){
        [queue release];
        
    }
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
    [super dealloc];
}
-(void)registerUploadProgress:(UIProgressView *)progressView ForPictureId:(NSURL *)pictureId{
    [[self progressViews] setObject:progressView forKey:pictureId];
}
-(void)deregisterUploadProgress:(UIProgressView *)progressView
{
    NSArray *keys = [[self progressViews]allKeysForObject:progressView];
    [[self progressViews]removeObjectsForKeys:keys];
    
}
-(void)addPictureToUploadQueue:(Picture *)picture{
    [picture retain];
    if([self queue]==nil){
        ASINetworkQueue *_queue = [[ASINetworkQueue alloc]init];
        [_queue setShowAccurateProgress:YES];
        [_queue setShouldCancelAllRequestsOnFailure:NO];
        [self setQueue:_queue];
        [_queue release];
    }
    
    ASIHTTPRequest* request = [PictureUpload getUploadRequestForPicture:picture];
    [request setShowAccurateProgress:YES];
    [request setDelegate:self];
    [request setUploadProgressDelegate:self];
    [[self queue]addOperation:(NSOperation*)request];
    if([[self queue]isSuspended]){
        [[self queue]go];
    }
    //[upload release];
    [picture release];
}
-(void)request:(ASIHTTPRequest*)uploadRequest didSendBytes:(float)bytes{
    float progress = ((float)[uploadRequest totalBytesSent]/(float)[uploadRequest postLength]);
    UIProgressView *progressView = [[self progressViews] objectForKey:[[uploadRequest userInfo]objectForKey:@"PictureId"]];
    if(progressView){        
        [progressView setProgress:progress];
    }
}
-(ASIHTTPRequest*)getUploadForPicture:(Picture*)picture{
    ASIHTTPRequest *retVal = nil;
    NSArray *filteredArray = [[[self queue] operations] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        ASIHTTPRequest *currentObject = evaluatedObject;
        if([[[currentObject userInfo]objectForKey:@"PictureId"]isEqual:[[picture objectID]URIRepresentation]]){
            return YES;
        }
        return NO;
    }]];
    if([filteredArray count]>0){
        retVal = [filteredArray objectAtIndex:0];
        
    }
   // [filteredArray release];
    return retVal;                               
}
-(bool)cancelUploadForPicture:(Picture *)picture{
    ASIHTTPRequest *request = [self getUploadForPicture:picture];
    if(request){
        [request clearDelegatesAndCancel];
        return YES;
    }
    return NO;
}
@end
