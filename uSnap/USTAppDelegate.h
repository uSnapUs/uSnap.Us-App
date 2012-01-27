//
//  USTAppDelegate.h
//  uSnap
//
//  Created by Owen Evans on 18/01/12.
//  Copyright (c) 2012 Xero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationHandler.h"
#import "FileUploadHandler.h"

@interface USTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LocationHandler *locationHandler;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (retain) FileUploadHandler *fileUploadHandler;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
