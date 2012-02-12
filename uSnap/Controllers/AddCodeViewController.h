//
//  AddCodeViewController.h
//  uSnap.us
//
//  Created by Owen Evans on 30/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCodeViewController : UIViewController<UITextFieldDelegate>
- (IBAction)Done:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *codeField;
@property (retain, nonatomic) IBOutlet UIView *ErrorView;
@property (retain, nonatomic) IBOutlet UILabel *ErrorLabel;
- (IBAction)Cancel:(id)sender;
-(BOOL)setEventFromCurrentCode;
-(void)fadeInErrorMessage;
-(void)fadeOutErrorMessage;
@end
