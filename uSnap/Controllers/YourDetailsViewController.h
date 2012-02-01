//
//  YourDetailsViewController.h
//  uSnap.us
//
//  Created by Owen Evans on 30/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YourDetailsViewController : UIViewController<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UIView *TextFieldBackgroundView;
@property (retain, nonatomic) IBOutlet UITextField *nameField;
@property (retain, nonatomic) IBOutlet UITextField *emailField;
- (IBAction)submit:(id)sender;
-(void)setupView;
-(BOOL)saveNameAndEmail;
@end
