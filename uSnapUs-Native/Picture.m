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
#import "SBJson.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface Picture (PrivateMethods)
-(void) getPictureData:(void (^)(NSData *pictureData))block;
@end
@implementation Picture

@dynamic resourceLocation;
@dynamic serverId;
@dynamic uploaded;
@dynamic dateTaken;
@dynamic event;
NSData* data=nil;

-(void)beginUpload{
    [self getPictureData:^(NSData *pictureData) {
        NSURL *postUrl = [NSURL URLWithString:@"http://192.168.88.104:3000/photo"];
        ASIFormDataRequest *formRequest = [ASIFormDataRequest requestWithURL:postUrl];
        [formRequest setData:pictureData forKey:@"photo"];
        //[formRequest setShouldStreamPostDataFromDisk:YES];
        [formRequest setAllowCompressedResponse:YES];
        //[formRequest shouldCompressRequestBody:YES];
        [formRequest setUploadProgressDelegate:self];
        //[formRequest showAccurateProgress:YES];
        [formRequest setDelegate:self];
        [formRequest startAsynchronous];

    }];
       
    
}
-(void)getPictureData:(void (^)(NSData *pictureData))block {
       ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];  
        [library assetForURL:[NSURL URLWithString:[self resourceLocation]] resultBlock:^(ALAsset *asset) {
            NSLog(@"asset url %@",[[[asset defaultRepresentation]url]absoluteString]);
        
            NSData *imageData = UIImageJPEGRepresentation(
                                                         [UIImage imageWithCGImage:[[asset defaultRepresentation]fullResolutionImage]],.5);    
            block(imageData);
        } failureBlock:^(NSError *error) {
            
        }];

}
-(void) request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes{
    NSLog(@"sent %llu bytes",bytes);
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
         NSLog(@"%@ finished",response);
    NSMutableDictionary *responseObj = [response JSONValue];
    
    NSLog(@"id: %@", [responseObj valueForKey:@"id"]);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
     NSLog(@"%@ failed with error %@",[[request url]absoluteString],[[request error] localizedDescription]);
}
@end
