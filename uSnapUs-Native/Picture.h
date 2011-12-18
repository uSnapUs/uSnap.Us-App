//
//  Picture.h
//  uSnapUs-Native
//
//  Created by Owen Evans on 7/12/11.
//  Copyright (c) 2011 Xero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Event.h"

@class Event;

@interface Picture : Event

@property (nonatomic, retain) NSString * resourceLocation;
@property (nonatomic, retain) NSString * serverId;
@property (nonatomic, retain) NSNumber * uploaded;
@property (nonatomic, retain) NSDate * dateTaken;
@property (nonatomic, retain) Event *event;

@end
