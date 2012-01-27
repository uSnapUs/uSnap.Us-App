//
//  Event.h
//  uSnap.us
//
//  Created by Owen Evans on 26/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Picture;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * eventKey;
@property (nonatomic, retain) NSString * eventTitle;
@property (nonatomic, retain) NSDate * eventStart;
@property (nonatomic, retain) NSDate * eventEnd;
@property (nonatomic, retain) NSSet *pictures;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addPicturesObject:(Picture *)value;
- (void)removePicturesObject:(Picture *)value;
- (void)addPictures:(NSSet *)values;
- (void)removePictures:(NSSet *)values;

@end
