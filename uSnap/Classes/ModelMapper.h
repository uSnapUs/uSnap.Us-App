//
//  ModelMapper.h
//  uSnap.us
//
//  Created by Owen Evans on 31/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
@interface ModelMapper : NSObject
+(Event*) mapDictionary:(NSMutableDictionary*)dictionary ToEvent:(Event*) event;
@end
