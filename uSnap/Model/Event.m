//
//  Event.m
//  uSnap.us
//
//  Created by Owen Evans on 30/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import "Event.h"
#import "Picture.h"


@implementation Event

@dynamic eventEnd;
@dynamic eventKey;
@dynamic eventStart;
@dynamic eventTitle;
@dynamic latitude;
@dynamic longitude;
@dynamic pictures;
-(CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake([[self latitude]floatValue], [[self longitude]floatValue]);
}
-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate{
    
}
-(NSString*)title{
    return [self eventTitle];
}
-(NSString*)subtitle{
    return @"";
}
@end
