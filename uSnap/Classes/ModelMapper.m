//
//  ModelMapper.m
//  uSnap.us
//
//  Created by Owen Evans on 31/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import "ModelMapper.h"

@implementation ModelMapper
+(Event*)mapDictionary:(NSMutableDictionary *)dictionary ToEvent:(Event *)event{
    [event setEventTitle:[dictionary objectForKey:@"name"]];
    [event setEventKey:[dictionary objectForKey:@"code"]];
    [event setLatitude:[dictionary valueForKey:@"latitude"]];
    [event setLongitude:[dictionary valueForKey:@"longitude"]];
    
    [event setServerId:[dictionary valueForKey:@"id"]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [event setEventStart:[dateFormatter dateFromString:[dictionary objectForKey:@"starts"]]];
    [event setEventEnd:[dateFormatter dateFromString:[dictionary objectForKey:@"ends"]]];
    [dateFormatter release];
    return event;
}
@end
