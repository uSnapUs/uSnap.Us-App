//
//  LocationHandler.h
//  uSnap.us
//
//  Created by Owen Evans on 18/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Event.h"
#import "ASIHTTPRequestDelegate.h"
@interface LocationHandler : NSObject<CLLocationManagerDelegate,ASIHTTPRequestDelegate>
@property(strong,atomic) Event *currentEvent;
@property(strong,atomic) CLLocationManager *locationManager;

-(bool)isCurrentlyUpdatingLocation;
-(void)initalizeLocation;
@end
