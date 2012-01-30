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
@property(strong,atomic) NSMutableArray *lastSetOfEvents;
@property(atomic) CLLocationCoordinate2D lastLocation;

-(Event*) populateEvent:(NSMutableDictionary *)eventFromServer;
-(bool)isCurrentlyUpdatingLocation;
-(void)initalizeLocation;
-(bool)setCurrentEventFromCode:(NSString*)code;
@end
