//
//  TimelineViewController.h
//  uSnap.us
//
//  Created by Owen Evans on 20/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineViewController : UITableViewController<UIScrollViewDelegate>
@property (retain, nonatomic) IBOutlet UILabel *EventTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *EventDateLabel;
@property (retain, nonatomic) IBOutlet UIView *BottomBarView;
- (IBAction)CameraButtonPressed:(id)sender;
- (IBAction)LocationButtonPressed:(id)sender;
-(void)refreshData;
@end
