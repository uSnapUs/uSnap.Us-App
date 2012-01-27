//
//  LocationHandler.m
//  uSnap.us
//
//  Created by Owen Evans on 18/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import "LocationHandler.h"
#import <CoreLocation/CoreLocation.h>
#import "ASIHTTPRequest.h"
#import "USTAppDelegate.h"
#import "constants.h"
#import <SBJson/SBJson.h>
@interface LocationHandler(PrivateMethods){
    
}
-(void)setToVoidEvent;
@end
@implementation LocationHandler
@synthesize currentEvent;
@synthesize locationManager;
BOOL _isUpdating;
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation   {
    if(newLocation==nil||newLocation==NULL){
        return;
    }
    CLLocationCoordinate2D coordinate =  newLocation.coordinate;

    
    NSString *eventUrl =[[NSString alloc]initWithFormat:@"http://usnapus-staging.herokuapp.com/events.json?latitude=%f&longitude=%f",coordinate.latitude,coordinate.longitude];
    
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:eventUrl]];
    [eventUrl release];
    [request setDelegate:self];
    [request startAsynchronous];
    [request release];
    [manager stopUpdatingLocation];
    _isUpdating = NO;
    

}
-(bool)isCurrentlyUpdatingLocation{
    return _isUpdating;
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:uSnapEventUpdatedNotification object:self];
    [[self locationManager]startUpdatingLocation];
}
-(void)requestFinished:(ASIHTTPRequest *)request{
    
    NSLog(@"request finished with response %@",[request responseString]);    
    NSMutableArray *eventArray = (NSMutableArray*)[[request responseString]JSONValue];
    NSLog(@"%@",eventArray);
    if([eventArray count]>0){
        NSMutableDictionary *serverEvent = [eventArray objectAtIndex:0];
        USTAppDelegate* appDelegate = (USTAppDelegate *)[[UIApplication sharedApplication]delegate];
        NSEntityDescription *eventEntity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:[appDelegate managedObjectContext]];
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        request.entity = eventEntity;
        request.fetchLimit = 1;
        request.predicate = [NSPredicate predicateWithFormat:@"eventKey=%@",[serverEvent valueForKey:@"id"]];
        NSError *error = nil;
        NSArray *results = [[appDelegate managedObjectContext] executeFetchRequest:request
                                                                             error:&error];
        Event *event = nil;
        if(error || [results count]<1){
            event = (Event*) [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:[appDelegate managedObjectContext]]; 
            NSNumber *serverId = [serverEvent valueForKey:@"id"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
            [event setEventStart:[dateFormatter dateFromString:[serverEvent 
            [event setEventKey:[serverId stringValue]];
            [event setEventTitle:[serverEvent valueForKey:@"name"]];
            NSError *saveError = nil;
            [[appDelegate managedObjectContext] save:&saveError];
        }
        else{
            event = (Event*)[results objectAtIndex:0];
        }
        [self setCurrentEvent:event];
    }
    else{
        [self setToVoidEvent];
    }
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:uSnapEventUpdatedNotification object:self];
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
                _isUpdating = YES;
        }
    }
}
-(id)init{
    self = [super init];
    if(self!=nil){
        _isUpdating=YES;
    }
    return self;
}
-(void) dealloc{
    [locationManager release];
    [super dealloc];
}
-(void)setToVoidEvent{
    USTAppDelegate* appDelegate = (USTAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSEntityDescription *eventEntity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:[appDelegate managedObjectContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.entity = eventEntity;
    request.fetchLimit = 1;
    request.predicate = [NSPredicate predicateWithFormat:@"eventKey=%@",VoidEventKey];
    NSError *error = nil;
    NSArray *results = [[appDelegate managedObjectContext] executeFetchRequest:request
                                                           error:&error];
    Event *event = nil;
    if(error || [results count]<1){
        event = (Event*) [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:[appDelegate managedObjectContext]]; 
        [event setEventKey:VoidEventKey];
        [event setEventTitle:@"No events found!"];
        NSError *saveError = nil;
        [[appDelegate managedObjectContext] save:&saveError];
    }
    else{
        event = (Event*)[results objectAtIndex:0];
    }
    [self setCurrentEvent:event];
    [request release];
   
}
@end
