//
//  PictureUpload.h
//  uSnap.us
//
//  Created by Owen Evans on 25/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "ASIProgressDelegate.h"
#import "Picture.h"
#import "ASINetworkQueue.h"
@interface PictureUpload : NSObject<ASIProgressDelegate,ASIHTTPRequestDelegate>
{
    }
+(ASIHTTPRequest*) getUploadRequestForPicture:(Picture*)picture;
+(void)setComplete:(id*)formRequest;
+(void)setFailed:(id*)formRequest;
@end
