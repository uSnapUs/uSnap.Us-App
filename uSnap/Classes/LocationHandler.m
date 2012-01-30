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
@synthesize lastLocation;
@synthesize locationManager;
@synthesize lastSetOfEvents;
BOOL _isUpdating;
Event *_currentEvent;
-(void)setCurrentEvent:(Event *)currentEvent{
    @synchronized(self){
    if(_currentEvent!=nil){
        [_currentEvent release];
    }
    [currentEvent retain];
    _currentEvent = currentEvent;
    }
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:uSnapEventUpdatedNotification object:self];
}
-(Event*)currentEvent{
    Event *retVal = nil;
    @synchronized(self){
        retVal =  [[_currentEvent retain]autorelease];
    }
    return retVal;
}
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
    [self setLastLocation:coordinate];
    _isUpdating = NO;
    

}
-(bool)isCurrentlyUpdatingLocation{
    return _isUpdating;
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"request failed:%@",[[request error]description]);
          
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:uSnapEventUpdatedNotification object:self];
    [[self locationManager]startUpdatingLocation];
}
-(void)requestFinished:(ASIHTTPRequest *)request{
    
    NSLog(@"request finished with response %@",[request responseString]);    
    NSMutableArray *eventArray = (NSMutableArray*)[[request responseString]JSONValue];
    NSLog(@"%@",eventArray);
    if([eventArray count]>0){
        NSMutableArray *setOfEvents = [[NSMutableArray alloc]initWithCapacity:[eventArray count]];
        for (NSMutableDictionary *serverEvent in eventArray) {
            [setOfEvents addObject:[self populateEvent:serverEvent]];
        }
        [self setLastSetOfEvents:setOfEvents];
        [self setCurrentEvent:[setOfEvents objectAtIndex:0]];
        [setOfEvents release];
    }
    else{
        [self setToVoidEvent];
    }

    
}
-(Event*) populateEvent:(NSMutableDictionary *)eventFromServer{
    USTAppDelegate* appDelegate = (USTAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSEntityDescription *eventEntity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:[appDelegate managedObjectContext]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    fetchRequest.entity = eventEntity;
    fetchRequest.fetchLimit = 1;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"eventKey=%@",[eventFromServer valueForKey:@"id"]];
    NSError *error = nil;
    NSArray *results = [[appDelegate managedObjectContext] executeFetchRequest:fetchRequest
                                                                         error:&error];
    [fetchRequest release];
    Event *event = nil;
    if(error || [results count]<1){
        event = (Event*) [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:[appDelegate managedObjectContext]]; 
        NSNumber *serverId = [eventFromServer valueForKey:@"id"];
        
        [event setEventKey:[serverId stringValue]];
          }
    else{
        event = (Event*)[results objectAtIndex:0];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    [event setEventStart:[dateFormatter dateFromString:[eventFromServer valueForKey:@"starts"]]];
    [event setEventEnd:[dateFormatter dateFromString:[eventFromServer valueForKey:@"ends"]]];
    [event setEventTitle:[eventFromServer valueForKey:@"name"]];
    [event setLatitude:[eventFromServer valueForKey:@"latitude"]];
    [event setLongitude:[eventFromServer valueForKey:@"longitude"]];
    NSError *saveError = nil;
    [[appDelegate managedObjectContext] save:&saveError];
    [dateFormatter release];
    return event;
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
-(bool)setCurrentEventFromCode:(NSString*)code{
    
    NSString *eventUrl =[[NSString alloc]initWithFormat:@"http://usnapus-staging.herokuapp.com/events.json?code=%@",code];
    
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:eventUrl]];
    [eventUrl release];
    [request startSynchronous];
    NSLog(@"request finished with response %@",[request responseString]); 
    if([request responseStatusCode]!=200||[[request responseString]length]<3){
        [request release];
        return NO;
    }
    NSMutableDictionary *event = (NSMutableDictionary*)[[request responseString]JSONValue];
    if(event){
        Event *newEvent = [self populateEvent:event];
        if(![self lastSetOfEvents]){
            [self setLastSetOfEvents:[[[NSMutableArray alloc]init]autorelease]];
        }
        if(![[self lastSetOfEvents]containsObject:newEvent]){
            [[self lastSetOfEvents] addObject:newEvent];
        }
        [self setCurrentEvent:newEvent];
        [request release];
        return YES;
    }
    [request release];
    return NO;
    
    
}
@end
