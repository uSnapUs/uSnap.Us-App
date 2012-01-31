//
//  uSnapUs-Native.h
//  uSnapUs-Native
//
//  Created by Owen Evans on 5/12/11.
//  Copyright (c) 2011 Xero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Picture;

@interface uSnapUs_Native : NSManagedObject

@property (nonatomic, retain) NSString * eventKey;
@property (nonatomic, retain) NSSet *pictures;
@end

@interface  (CoreDataGeneratedAccessors)

- (void)addPicturesObject:(Picture *)value;
- (void)removePicturesObject:(Picture *)value;
- (void)addPictures:(NSSet *)values;
- (void)removePictures:(NSSet *)values;

@end
