//
//  ServerRegistrationManager.h
//  uSnap.us
//
//  Created by Owen Evans on 30/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
@interface ServerRegistrationManager : NSObject<ASIHTTPRequestDelegate>
@property(retain,atomic) NSUserDefaults *credentialStore;
@property(retain,atomic) NSString *tempDeviceId;
@property(readonly) NSString *deviceId;
@property(readonly) NSString *name;
@property(readonly) NSString *email;
@property(readonly) NSNumber *serverDeviceId;
-(void)loadCredentials;
-(void)registerDevice;
-(BOOL)setName:(NSString*)name Email:(NSString*)email;

@end
