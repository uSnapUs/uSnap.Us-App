//
//  PictureSpecificaitons.m
//  uSnapUs-Native
//
//  Created by Owen Evans on 3/12/11.
//  Copyright (c) 2011 Xero. All rights reserved.
//

#import "PictureSpecificaitons.h"

@implementation GivenANewPicture
 
NSString *testLocation = @"location";
@synthesize picture;
- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc]init];
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    [context setPersistentStoreCoordinator:store];
    picture = (Picture *)[NSEntityDescription insertNewObjectForEntityForName:@"Picture"
                                                       inManagedObjectContext:context];
    
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)test_should_have_a_path_property
{
    [picture setResourceLocation:testLocation];
    STAssertEqualObjects(testLocation, [picture resourceLocation], @"expected resource location to be stored");
}

@end
