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
@interface PictureUpload : NSObject<ASIProgressDelegate,ASIHTTPRequestDelegate>
-(void) start;
@property(retain) Picture *picture;

@end
