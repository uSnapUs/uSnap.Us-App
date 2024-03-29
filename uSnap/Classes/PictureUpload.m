//
//  PictureUpload.m
//  uSnap.us
//
//  Created by Owen Evans on 25/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import "PictureUpload.h"
#import "ASIFormDataRequest.h"
#import "USTAppDelegate.h"
#import "constants.h"
#import "TestFlight.h"
#import "SBJson.h"
@implementation PictureUpload
+(ASIHTTPRequest*) getUploadRequestForPicture:(Picture*)picture{
    [picture setUploaded:[NSNumber numberWithBool:NO]];
    [picture setUploadedBytes:[NSNumber numberWithInt:0]];
    // NSError *err;
    USTAppDelegate *appDelegate =  [[UIApplication sharedApplication]delegate];
    Event *currentEvent = [[appDelegate locationHandler]currentEvent];
    NSString *photoUrl = [NSString stringWithFormat:@"http://usnap.us/events/%@/photos.json",[currentEvent serverId]];
    //[[self managedObjectContext]save:&err];
    NSURL *postUrl = [NSURL URLWithString:photoUrl];
    __block ASIFormDataRequest *formRequest = [ASIFormDataRequest requestWithURL:postUrl];
    [formRequest setFile:[picture getFullPath] withFileName:@"photo.jpg" andContentType:@"image/jpeg" forKey:@"photo[photo]"];
    [formRequest addRequestHeader:@"Authorization" value:[NSString stringWithFormat:@"Device token=%@",[[appDelegate registrationManager]deviceId]]];
    [formRequest addPostValue:[[appDelegate registrationManager]serverDeviceId]forKey:@"photo[device_id]"];
    [formRequest setUserInfo:[NSDictionary 
                              
                              dictionaryWithObjects:[NSArray arrayWithObjects:
                                                     picture
                                                     ,[[picture objectID]URIRepresentation]
                                                     ,nil
                                                     ]
                              forKeys:[NSArray arrayWithObjects:
                                       @"picture"
                                       ,@"PictureId"
                                       , nil]]];
    [formRequest setTimeOutSeconds:120];
    [formRequest setShouldStreamPostDataFromDisk:YES];
    [formRequest setAllowCompressedResponse:YES];
    [formRequest setCompletionBlock:^{
         [self performSelectorOnMainThread:@selector(setComplete:) withObject:formRequest waitUntilDone:NO];
      
            }];
    [formRequest setFailedBlock:^{
        
        [self performSelectorOnMainThread:@selector(setFailed:) withObject:formRequest waitUntilDone:NO];

    }];

    return formRequest;
}
     +(void)setFailed:(id*)r{
         ASIHTTPRequest *formRequest = (ASIHTTPRequest*)r;
         [[[formRequest userInfo]objectForKey:@"picture"] setError:[NSNumber numberWithBool:YES]];
         NSLog(@"%@",[[formRequest error]description]);
         NSError *error=nil;
         [[[[formRequest userInfo]objectForKey:@"picture"] managedObjectContext]save:&error];
         if(error){
             NSLog(@"Save error produced error %@",[error description]);
         }
         NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
         [notificationCenter postNotificationName:uSnapPictureUploadFinishedSuccess object:[[formRequest userInfo]objectForKey:@"PictureId"] ];
     }
+(void)setComplete:(id*)r{
        ASIHTTPRequest *formRequest = (ASIHTTPRequest*)r;
    if([formRequest responseStatusCode]==201){
        [TestFlight passCheckpoint:@"uploaded a picture"];
        [[[formRequest userInfo]objectForKey:@"picture"] setUploaded:[NSNumber numberWithBool:YES]];
        NSMutableDictionary *pictureServerData = [[formRequest responseString]JSONValue];
        if([pictureServerData objectForKey:@"id"]){
            NSNumber *sId = [pictureServerData objectForKey:@"id"];
            [[[formRequest userInfo]objectForKey:@"picture"] setServerId:[sId stringValue]];

        }
    }
    else{
            [[[formRequest userInfo]objectForKey:@"picture"] setUploaded:[NSNumber numberWithBool:NO]];
    }
    NSError *error=nil;

    [[[[formRequest userInfo]objectForKey:@"picture"] managedObjectContext]save:&error];
    

    if(error!=nil){
        NSLog(@"Save produced error %@",[error description]);
    }
    else{
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:[[[formRequest userInfo]objectForKey:@"picture"] getFullPath] error:&error];
    }
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:uSnapPictureUploadFinishedSuccess object:[[formRequest userInfo]objectForKey:@"PictureId"]];
}
@end
