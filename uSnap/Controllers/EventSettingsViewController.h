//
//  EventSettingsViewController.h
//  uSnap.us
//
//  Created by Owen Evans on 20/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventSettingsViewController : UIViewController
- (IBAction)Done:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *doneButton;
@property (retain, nonatomic) IBOutlet UIView *TopBar;

@end
