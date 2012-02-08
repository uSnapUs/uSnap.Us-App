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
@implementation FileUploadHandler
@synthesize queue;
-(id)init{
    self = [super init];
    if(self){
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
       [notificationCenter addObserver:self selector:@selector(finishedPictureUpload:) name:uSnapPictureUploadFinishedSuccess object:nil];
    }
    return self;
}
-(void) finishedPictureUpload:(NSNotification*)notification{
    PictureUpload* pictureUpload = (PictureUpload*) [notification object];
   [queue removeObject:pictureUpload];
}
-(void) dealloc{
    if(queue!=nil){
        [queue release];
    }
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
    [super dealloc];
}
-(void)addPictureToUploadQueue:(Picture *)picture{
    [picture retain];
    if([self queue]==nil){
        NSMutableArray *_queue = [[NSMutableArray alloc]init];
        [self setQueue:_queue];
        [_queue release];
    }
    PictureUpload *upload = [[PictureUpload alloc]init];
    [upload setPicture:picture];
    [queue addObject:upload];
    [upload start];
    [upload release];
    [picture release];
}
-(PictureUpload*)getUploadForPicture:(Picture*)picture{
    PictureUpload *retVal = nil;
   NSArray *filteredArray = [queue filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        PictureUpload *currentObject = evaluatedObject;
        if([[[[currentObject picture]objectID]URIRepresentation]isEqual:[[picture objectID]URIRepresentation]]){
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

@end
