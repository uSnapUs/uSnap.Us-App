#import "Kiwi.h"
#import "Event.h"
#import "ModelMapper.h"
#import "OCMock.h"
#import "NSDate-Utilities.h"
#import <CoreData/CoreData.h>
SPEC_BEGIN(EventSpecs)
describe(@"Event", ^{
    describe(@"GetFriendlyDate", ^{

        describe(@"With start date and end date on same day", ^{
            __block NSDate *referenceDate;
            __block Event *event;
            __block NSManagedObjectContext *moc;
            beforeAll(^{
                referenceDate = [NSDate dateWithTimeIntervalSinceReferenceDate:0]; 

                NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles:nil];
                NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
                [psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL];
                moc = [[NSManagedObjectContext alloc] init];
                [moc setPersistentStoreCoordinator:psc];
                
                event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:moc];
                [mom release];
                [psc release];

                [event setEventStart:[referenceDate dateByAddingHours:8]];
                [event setEventEnd:[referenceDate dateByAddingHours:12]];
                [event setEventKey:@"key"];
            });
            it(@"should return single day/month pair",^{
                [[[event friendlyDateString]should ]equal:@"1 January"];
            });
        });
        describe(@"With start date and end date on different days",^{
            __block NSDate *referenceDate;
            __block Event *event;
            __block NSManagedObjectContext *moc;
            beforeAll(^{
                referenceDate = [NSDate dateWithTimeIntervalSinceReferenceDate:0]; 

                NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles:nil];
                NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
                [psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL];
                moc = [[NSManagedObjectContext alloc] init];
                [moc setPersistentStoreCoordinator:psc];
                
                event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:moc];
                [mom release];
                [psc release];
                [event setEventStart:[referenceDate dateByAddingHours:8]];
                [event setEventEnd:[[referenceDate dateByAddingHours:12]dateByAddingDays:2]];
                                [event setEventKey:@"key"];
                           });

            it(@"should return two days and a single month",^{
                   [[[event friendlyDateString]should ]equal:@"1-3 January"];            });
        });
        describe(@"With start date and end date on different months",^{
            __block NSDate *referenceDate;
            __block Event *event;
            __block NSManagedObjectContext *moc;
            beforeAll(^{
                referenceDate = [NSDate dateWithTimeIntervalSinceReferenceDate:0]; 

                NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles:nil];
                NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
                [psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL];
                moc = [[NSManagedObjectContext alloc] init];
                [moc setPersistentStoreCoordinator:psc];
                
                event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:moc];
                [mom release];
                [psc release];

                [event setEventStart:referenceDate];
                [event setEventEnd:[[referenceDate dateByAddingDays:31]dateByAddingHours:2]];
                                [event setEventKey:@"key"];
            });

            it(@"should return two days and two months",^{
                   [[[event friendlyDateString]should ]equal:@"1 Jan-1 Feb"];
            });
        
        });
        describe(@"With end date at midnight",^{
            __block NSDate *referenceDate;
            __block Event *event;
            __block NSManagedObjectContext *moc;
            beforeAll(^{
                referenceDate = [NSDate dateWithTimeIntervalSinceReferenceDate:0]; 

                NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles:nil];
                NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
                [psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL];
                moc = [[NSManagedObjectContext alloc] init];
                [moc setPersistentStoreCoordinator:psc];
                
                event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:moc];
                [mom release];
                [psc release];

                [event setEventStart:[referenceDate dateByAddingHours:8]];
                [event setEventEnd:[referenceDate dateByAddingHours:24]];
                [event setEventKey:@"key"];
            });

            it(@"should return one day/month pair",^{
                [[[event friendlyDateString]should ]equal:@"1 January"];
            });
        
        });
        
    
    });
});
SPEC_END