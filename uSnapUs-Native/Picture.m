//
//  Picture.m
//  uSnapUs-Native
//
//  Created by Owen Evans on 7/12/11.
//  Copyright (c) 2011 Xero. All rights reserved.
//

#import "Picture.h"
#import "Event.h"
#import "ASIFormDataRequest.h"
@interface Picture (PrivateMethods)
-(NSData *) getPictureData;
@end
@implementation Picture

@dynamic resourceLocation;
@dynamic serverId;
@dynamic uploaded;
@dynamic dateTaken;
@dynamic event;


-(void)beginUpload{
    NSURL *postUrl = [NSURL URLWithString:@"http://192.168.88.104:3000/photo"];
    ASIFormDataRequest *formRequest = [ASIFormDataRequest requestWithURL:postUrl];
    [formRequest setData:[self getPictureData] forKey:@"photo"];
    [formRequest setShouldStreamPostDataFromDisk:YES];
    [formRequest setAllowCompressedResponse:YES];
    //[formRequest shouldCompressRequestBody:YES];
    [formRequest setUploadProgressDelegate:self];
    //[formRequest showAccurateProgress:YES];
    [formRequest setDelegate:self];
    [formRequest startAsynchronous];
 
    
}
-(NSData *)getPictureData{
    NSData *data = [[NSData alloc]init];
    return data;
}
-(void) request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes{
    NSLog(@"%@ sent %@ bytes",[request url],bytes);
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
     NSLog(@"%@ finished",[request url]);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
     NSLog(@"%@ failed with error %@",[request url],[[request error] localizedDescription]);
}
@end
