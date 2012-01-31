//
//  EventSpecifications.m
//  uSnapUs-Native
//
//  Created by Owen Evans on 5/12/11.
//  Copyright (c) 2011 Xero. All rights reserved.
//

#import "EventSpecifications.h"
#import "Event.h"
@implementation GivenANewEvent
NSString *testKey = @"key";
@synthesize event;
- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc]init];
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    [context setPersistentStoreCoordinator:store];
    event = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                       inManagedObjectContext:context];
    
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)test_should_have_an_event_key_property
{
    event.eventKey = testKey;
    STAssertEqualObjects(testKey, [event eventKey], @"expected event key to be stored");
}

@end
