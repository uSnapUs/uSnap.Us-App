//
//  Picture.m
//  uSnap.us
//
//  Created by Owen Evans on 18/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import "Picture.h"
#import "UIImage+Resize.h"
#import "ASIFormDataRequest.h"

@interface Picture(PrivateMethods)  {

}
-(NSString*)getThumbnailPath;
-(NSString*)getFullPath;
@end

@implementation Picture

@dynamic dateTaken;
@dynamic imageSize;
@dynamic resourceLocation;
@dynamic serverId;
@dynamic uploaded;
@dynamic error;
@dynamic uploadedBytes;
@dynamic event;

-(void)beginUpload{
    [self setUploaded:[NSNumber numberWithBool:NO]];
    [self setUploadedBytes:[NSNumber numberWithInt:0]];
    // NSError *err;
    //[[self managedObjectContext]save:&err];
    NSURL *postUrl = [NSURL URLWithString:@"http://192.168.88.105:3000/photos"];
    ASIFormDataRequest *formRequest = [ASIFormDataRequest requestWithURL:postUrl];
    [formRequest setFile:[self getFullPath] withFileName:@"photo.jpg" andContentType:@"image/jpeg" forKey:@"photo[photo]"];
    [formRequest setShouldStreamPostDataFromDisk:YES];
    [formRequest setAllowCompressedResponse:YES];
    //[formRequest shouldCompressRequestBody:YES];
    [formRequest setUploadProgressDelegate:self];
    //[formRequest showAccurateProgress:YES];
    [formRequest setDelegate:self];
    [formRequest startAsynchronous];
    
    
    
}
-(void)setImage:(NSData *)jpgRepresentation{
    [jpgRepresentation retain];
    NSString *fullPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSNumber *size = [NSNumber numberWithInt:[jpgRepresentation length]];
    [self setImageSize:size];
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    NSString *rootPath = [fullPath stringByAppendingPathComponent:(NSString*) newUniqueIdString];
    [self setResourceLocation:rootPath];
    CFRelease(newUniqueId);
    CFRelease(newUniqueIdString);
     UIImage *fullImage = [[UIImage alloc]initWithData:jpgRepresentation];
    UIImage *thumbnail = [fullImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(250., 250.) interpolationQuality:kCGInterpolationHigh];
    [jpgRepresentation writeToFile:[self getFullPath] atomically:YES];
    [UIImageJPEGRepresentation(thumbnail, .5) writeToFile:[self getThumbnailPath] atomically:YES];
    [fullImage release];
    [jpgRepresentation release];
}
-(NSString*)getFullPath{
    return [[self resourceLocation] stringByAppendingPathExtension: @"JPG"];
}
-(NSString*)getThumbnailPath{
    return [[[self resourceLocation]stringByAppendingString:@"_thumb"]stringByAppendingPathExtension:@"JPG"];
}
@end
