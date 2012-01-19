//
//  LocationHandler.m
//  uSnap.us
//
//  Created by Owen Evans on 18/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import "LocationHandler.h"
#import <CoreLocation/CoreLocation.h>
@implementation LocationHandler
@synthesize currentEvent;
@synthesize locationManager;
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation   {
    
}
-(void) initalizeLocation{
    if([CLLocationManager locationServicesEnabled]){
        if (nil == [self locationManager]){
            CLLocationManager *manager = [[CLLocationManager alloc] init];
            [self setLocationManager:manager];
        [manager release];
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        
        // Set a movement threshold for new events.
        locationManager.distanceFilter = 500;
        
        [locationManager startUpdatingLocation];
        }
    }
}
-(void) dealloc{
    [locationManager release];
    [super dealloc];
}
@end
