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
#import "ASINetworkQueue.h"
@interface FileUploadHandler : NSObject
@property(retain,atomic) ASINetworkQueue *queue;
@property(retain,atomic) NSMutableDictionary *progressViews;
-(void) addPictureToUploadQueue:(Picture *)picture;
-(void)registerUploadProgress:(UIProgressView*) progressView ForPictureId:(NSURL*)pictureId;
-(void)deregisterUploadProgress:(UIProgressView*) progressView;
-(ASIHTTPRequest*)getUploadForPicture:(Picture*)picture;
-(bool)cancelUploadForPicture:(Picture*)picture;
-(bool)deletePhotoFromServer:(Picture*)picture;
@end
