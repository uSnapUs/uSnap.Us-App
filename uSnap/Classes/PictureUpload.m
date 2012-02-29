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
        [TestFlight passCheckpoint:@"uploaded a picture"];
        [[[formRequest userInfo]objectForKey:@"picture"] setUploaded:[NSNumber numberWithBool:YES]];
         NSError *error;
        [[[[formRequest userInfo]objectForKey:@"picture"] managedObjectContext]save:&error];
   

        if(error!=nil){
            NSLog(@"Save produced error %@",[error description]);
        }
        else{
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm removeItemAtPath:[picture getFullPath] error:&error];
        }
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:uSnapPictureUploadFinishedSuccess object:[[formRequest userInfo]objectForKey:@"PictureId"]];
            }];
    [formRequest setFailedBlock:^{
        


        [[[formRequest userInfo]objectForKey:@"picture"] setError:[NSNumber numberWithBool:YES]];
        NSLog(@"%@",[[formRequest error]description]);
        NSError *error;
        [[[[formRequest userInfo]objectForKey:@"picture"] managedObjectContext]save:&error];
        if(error){
            NSLog(@"Save error produced error %@",[error description]);
        }
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:uSnapPictureUploadFinishedSuccess object:[[formRequest userInfo]objectForKey:@"PictureId"] ];
        [[[formRequest userInfo]objectForKey:@"picture"] release];

    }];

    return formRequest;
}

@end
