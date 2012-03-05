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
#import "UIImage+fixOrientation.h"

@interface Picture(PrivateMethods)  {

}
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


-(void)setImage:(NSData *)jpgRepresentation{
    [jpgRepresentation retain];
    NSString *fullPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSNumber *size = [NSNumber numberWithInt:[jpgRepresentation length]];
    [self setImageSize:size];
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    NSString *rootPath = [fullPath stringByAppendingPathComponent:(NSString*) newUniqueIdString];
  
    CFRelease(newUniqueId);
    CFRelease(newUniqueIdString);
     UIImage *fullImage = [[UIImage alloc]initWithData:jpgRepresentation];

    UIImage *thumbnail = [fullImage thumbnailImage:300 transparentBorder:YES cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
    [UIImageJPEGRepresentation([fullImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(3000, 1800) interpolationQuality:kCGInterpolationHigh], 1) writeToFile:[rootPath stringByAppendingPathExtension: @"JPG"] atomically:YES];
    [UIImageJPEGRepresentation(thumbnail,1) writeToFile:[[rootPath stringByAppendingString:@"_thumb"]stringByAppendingPathExtension:@"JPG"] atomically:YES];
    [self setResourceLocation:rootPath];
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
