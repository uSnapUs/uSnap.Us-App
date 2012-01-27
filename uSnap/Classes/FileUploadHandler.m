//
//  FileUploadHandler.m
//  uSnap.us
//
//  Created by Owen Evans on 25/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import "FileUploadHandler.h"
#import "PictureUpload.h"
@implementation FileUploadHandler
@synthesize queue;
-(void) dealloc{
    if(queue!=nil){
        [queue release];
    }
    [super dealloc];
}
-(void)addPictureToUploadQueue:(Picture *)picture{
    [picture retain];
    if([self queue]==nil){
        NSMutableArray *_queue = [[NSMutableArray alloc]init];
        [self setQueue:_queue];
        [_queue release];
    }
    NSLog(@"%@",picture);
    PictureUpload *upload = [[PictureUpload alloc]init];
    [upload setPicture:picture];
    [queue addObject:upload];
    [upload start];
    [upload release];
    [picture release];
    
    
}
@end
