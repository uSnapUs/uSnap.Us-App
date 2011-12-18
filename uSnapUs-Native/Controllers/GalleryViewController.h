//
//  GalleryViewController.h
//  uSnapUs-Native
//
//  Created by Owen Evans on 6/12/11.
//  Copyright (c) 2011 Xero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventBoundController.h"
#import "AQGridViewController.h"
#import "Picture.h"
@interface GalleryViewController : AQGridViewController<EventBoundController>

{
    Picture *currentPicture;
}
@property (assign) NSManagedObjectContext *managedObjectContext;
@property (assign) NSManagedObjectModel *managedObjectModel;
- (void)handleDataModelChange:(NSNotification *)note;
@end
