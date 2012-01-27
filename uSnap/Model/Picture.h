//
//  Picture.h
//  uSnap.us
//
//  Created by Owen Evans on 18/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Picture : NSManagedObject

@property (nonatomic, retain) NSDate * dateTaken;
@property (nonatomic, retain) NSNumber * imageSize;
@property (nonatomic, retain) NSString * resourceLocation;
@property (nonatomic, retain) NSString * serverId;
@property (nonatomic, retain) NSNumber * uploaded;
@property (nonatomic, retain) NSNumber * error;
@property (nonatomic, retain) NSNumber * uploadedBytes;
@property (nonatomic, retain) NSManagedObject *event;
-(void) setImage:(NSData*)jpgRepresentation;

-(NSString*)getThumbnailPath;
-(NSString*)getFullPath;
@end
