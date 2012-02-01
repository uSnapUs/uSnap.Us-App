#import "Kiwi.h"
#import "Event.h"
#import "ModelMapper.h"
#import "OCMock.h"
#import "NSDate-Utilities.h"
#import <CoreData/CoreData.h>
SPEC_BEGIN(ModelMapperSpec)

describe(@"ModelMapper", ^{
    describe(@"mapDictionary:ToEvent:", ^{
        __block NSString *title = @"TestEvent Title";
        __block NSString *starts = @"2001-01-01T19:00:00Z";
        __block NSString *ends = @"2001-01-03T00:00:00Z";
        __block NSString *code =@"NSDLKS12323";
        __block NSNumber *latitude = [NSNumber numberWithFloat:1232.3232];
        __block NSNumber *longitude = [NSNumber numberWithFloat:23.02039];;
        __block NSManagedObjectContext *moc;
        __block Event* event;
        NSMutableDictionary *dataFromServer = [[NSMutableDictionary alloc]initWithObjects:[NSArray arrayWithObjects: title,code,starts,ends,latitude,longitude,nil ] forKeys:[NSArray arrayWithObjects:@"name",@"code",@"starts",@"ends",@"latitude",@"longitude",nil]];
       beforeAll(^{
           NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles:nil];
           NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
           [psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL];
           moc = [[NSManagedObjectContext alloc] init];
           [moc setPersistentStoreCoordinator:psc];
           event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:moc];
           event = [ModelMapper mapDictionary:dataFromServer ToEvent:event];
           [mom release];
           [psc release];
       });
        afterAll(^{
            [title release];
            [starts release];
            [ends release];
            [code release];
            [moc release];
            [event release];
            [dataFromServer release];
        
        });
        it(@"Populates the title",^{
            [[[event eventTitle]should]equal:title];
        });
        it(@"Populates the event code",^{
            [[[event eventKey]should]equal:code];
        });
        it(@"Populates the event start date",^{
            NSDate *startDate = [[[[NSDate dateWithTimeIntervalSinceReferenceDate:0]autorelease]dateByAddingHours:19]autorelease];
            [[[event eventStart]should]equal:startDate];
        });
        it(@"Populates the event end date",^{
            NSDate *endDate = [[[[NSDate dateWithTimeIntervalSinceReferenceDate:0]autorelease]dateByAddingDays:2]autorelease];
            [[[event eventEnd]should]equal:endDate];
        });
        it(@"Populates latitude",^{
            [[[event latitude]should]equal:latitude];
        });
        it(@"Populates longitude",^{
             [[[event longitude]should]equal:longitude];
        });
           
    });
});

SPEC_END