//
//  FileUploadHandler.h
//  uSnap.us
//
//  Created by Owen Evans on 25/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Picture.h"
#import "PictureUpload.h"
@interface FileUploadHandler : NSObject
@property(retain,atomic) NSMutableArray *queue;

-(void) addPictureToUploadQueue:(Picture *)picture;

-(void)finishedPictureUpload:(NSNotification*)notification;
-(PictureUpload*)getUploadForPicture:(Picture*)picture;
@end
