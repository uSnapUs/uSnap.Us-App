//
//  USTDetailViewController.h
//  uSnap
//
//  Created by Owen Evans on 18/01/12.
//  Copyright (c) 2012 Xero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USTDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
