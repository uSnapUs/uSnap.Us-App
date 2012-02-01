//
//  Event.m
//  uSnap.us
//
//  Created by Owen Evans on 30/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import "Event.h"
#import "Picture.h"
#import "constants.h"
#import "NSDate-Utilities.h"
@implementation Event

@dynamic eventEnd;
@dynamic eventKey;
@dynamic eventStart;
@dynamic eventTitle;
@dynamic latitude;
@dynamic longitude;
@dynamic pictures;
@dynamic serverId;

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
-(NSString*)friendlyDateString{
    if(self!=nil&&([[self eventKey]compare:VoidEventKey]!=NSOrderedSame)){
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc]init]autorelease];
        [dateFormatter setDateFormat:@"MMMM"];
        NSLog(@"%@",[self eventStart]);
        NSLog(@"%@",[self eventEnd]);
        NSLog(@"%@",[[self eventEnd]dateByAddingTimeInterval:-1]);
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [gregorianCalendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSDateComponents *beginComponents = [gregorianCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[self eventStart]];
        NSDateComponents *endComponents = [gregorianCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit|NSDayCalendarUnit  fromDate:[[self eventEnd]dateByAddingTimeInterval:-1]];
        [gregorianCalendar release];
        NSString *dayPart;
        NSLog(@"%@",beginComponents);
        NSLog(@"%@",endComponents);
        if([beginComponents month]!=[endComponents month]){
            [dateFormatter setDateFormat:@"d MMM"];
            return [NSString stringWithFormat:@"%@-%@",[dateFormatter stringFromDate:[self eventStart]],[dateFormatter stringFromDate:[self eventEnd]]];
        }
        else{ 
           
            if([beginComponents day]!=[endComponents day]){
                dayPart = [NSString stringWithFormat:@"%i-%i",[beginComponents day],[endComponents day]];
            }
            else{
                dayPart = [NSString stringWithFormat:@"%i",[beginComponents day]];
            }
        
            return [NSString stringWithFormat:@"%@ %@",dayPart,[dateFormatter stringFromDate:[self eventStart]]];
        }
    }
    else
    {
        return @"";
    }

}

@end
