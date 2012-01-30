//
//  EventPinView.m
//  uSnap.us
//
//  Created by Owen Evans on 30/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import "EventPinView.h"
#import "Event.h"
#import "LocationHandler.h"
#import "USTAppDelegate.h"

@implementation EventPinView

-(void)selectEvent{
    Event *selectedEvent = [self annotation];
    USTAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [[appDelegate locationHandler]setCurrentEvent:selectedEvent];

}
@end
