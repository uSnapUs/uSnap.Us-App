//
//  Event.h
//  uSnap.us
//
//  Created by Owen Evans on 30/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@class Picture;

@interface Event : NSManagedObject<MKAnnotation>

@property (nonatomic, retain) NSDate * eventEnd;
@property (nonatomic, retain) NSString * eventKey;
@property (nonatomic, retain) NSDate * eventStart;
@property (nonatomic, retain) NSString * eventTitle;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * serverId;
@property (nonatomic, retain) NSSet *pictures;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addPicturesObject:(Picture *)value;
- (void)removePicturesObject:(Picture *)value;
- (void)addPictures:(NSSet *)values;
- (void)removePictures:(NSSet *)values;
- (NSString*) friendlyDateString;
@end
