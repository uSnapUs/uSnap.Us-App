//
//  CameraViewController.h
//  uSnapUs-Native
//
//  Created by Owen Evans on 6/12/11.
//  Copyright (c) 2011 Xero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventBoundController.h"
@interface CameraViewController : UIViewController<EventBoundController>
@property (weak, nonatomic) IBOutlet UIView *PreviewView;
- (IBAction)CaptureImage:(id)sender;
@property (assign) NSManagedObjectContext *managedObjectContext;
@property (assign) NSManagedObjectModel *managedObjectModel;
@end
