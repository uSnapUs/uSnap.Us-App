//
//  EventSettingsViewController.h
//  uSnap.us
//
//  Created by Owen Evans on 20/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface EventSettingsViewController : UIViewController<MKMapViewDelegate>
- (IBAction)Done:(id)sender;
@property (retain, nonatomic) IBOutlet MKMapView *Map;
@property (retain, nonatomic) IBOutlet UIButton *EnterCodeButton;
- (IBAction)GoToEnterCode:(id)sender;
- (IBAction)goToEnterDetails:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *YourDetailsButton;
@end
