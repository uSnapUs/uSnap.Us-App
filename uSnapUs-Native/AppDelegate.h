//
//  AppDelegate.h
//  uSnapUs-Native
//
//  Created by Owen Evans on 3/12/11.
//  Copyright (c) 2011 Xero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign) Event *currentEvent;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
