//
//  ServerRegistrationManager.m
//  uSnap.us
//
//  Created by Owen Evans on 30/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import "ServerRegistrationManager.h"
#import "constants.h"
#import "NSString+UrlEncoding.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
@implementation ServerRegistrationManager
@synthesize credentialStore;
@synthesize tempDeviceId;
-(id)init{
    self = [super init];
    if(self){
        [self setCredentialStore:[NSUserDefaults standardUserDefaults]];
        [self loadCredentials];
    }
    return self;
}
-(void)loadCredentials{
   
    if([self serverDeviceId]==nil){
        [self registerDevice];
    }
    
}
-(void)registerDevice{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef idAsString = CFUUIDCreateString(kCFAllocatorDefault ,uuid);
    CFRelease(uuid);
    [self setTempDeviceId:(NSString*)idAsString];
    CFRelease(idAsString);
    NSMutableDictionary *device = [[NSMutableDictionary alloc]initWithCapacity:2];
    [device setObject:[self tempDeviceId] forKey:@"guid"];
    [device setObject:[[UIDevice currentDevice] name] forKey:@"name"];
    NSURL *registerUrl = [NSURL URLWithString:@"http://usnap.us/devices.json"];
    ASIFormDataRequest *registerRequest = [[ASIFormDataRequest alloc]initWithURL:registerUrl];
    [registerRequest addPostValue:[device objectForKey:@"guid"] forKey:@"device[guid]"];
    [registerRequest addPostValue:[device objectForKey:@"name"] forKey:@"device[name]"];
    [device release];
    [registerRequest setDelegate:self];
    [registerRequest startAsynchronous];
}
-(void)requestFinished:(ASIHTTPRequest *)request{
    if([request responseStatusCode]==201){
        NSMutableDictionary *response = [[request responseString]JSONValue];
        NSNumber *serverDeviceId = [response valueForKey:@"id"];
        [[self credentialStore]setValue:[self tempDeviceId] forKey:usKcDeviceId];
        [[self credentialStore]setValue:serverDeviceId forKey:usKcServerDeviceId];
                [[self credentialStore]synchronize];
    }
    else
    {
     //   NSLog(@"%@",[request responseString]);
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request{
   // NSLog(@"%@",[[request error]description]);
}
-(NSNumber*) serverDeviceId{
             return [[self credentialStore]objectForKey:usKcServerDeviceId];
}
-(NSString*)deviceId{
   return (NSString*)[[self credentialStore]stringForKey:usKcDeviceId];
}
-(NSString*)email{
  return (NSString*)[[self credentialStore]stringForKey:usKcUserEmail];
}
-(NSString*)name{
    return (NSString*)[[self credentialStore]stringForKey:usKcUserName];
}
-(BOOL)setName:(NSString *)name Email:(NSString *)email{
    NSMutableDictionary *device = [[NSMutableDictionary alloc]initWithCapacity:2];
    [device setObject:[self deviceId] forKey:@"guid"];
    [device setObject:name forKey:@"name"];
        [device setObject:email forKey:@"email"];
    NSString *updateUrlString = [NSString stringWithFormat:@"http://usnap.us/devices/%@.json",[self serverDeviceId]];
    NSURL *registerUrl = [NSURL URLWithString:updateUrlString];
    ASIFormDataRequest *registerRequest = [[ASIFormDataRequest alloc]initWithURL:registerUrl];
    [registerRequest addPostValue:[device objectForKey:@"guid"] forKey:@"device[guid]"];
    [registerRequest addPostValue:[device objectForKey:@"name"] forKey:@"device[name]"];
        [registerRequest addPostValue:[device objectForKey:@"email"] forKey:@"device[email]"];
    [device release];
    [registerRequest setRequestMethod:@"PUT"];
    [registerRequest startSynchronous];
    if([registerRequest responseStatusCode]==201)
    {
        [[self credentialStore]setValue:email forKey:usKcUserEmail];
        [[self credentialStore]setValue:name forKey:usKcUserName];
        [registerRequest release];
        return YES;
    }
    else
    {
        [registerRequest release];
        return NO;
    }
}
@end
