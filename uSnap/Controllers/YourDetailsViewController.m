//
//  YourDetailsViewController.m
//  uSnap.us
//
//  Created by Owen Evans on 30/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import "YourDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "USTAppDelegate.h"
#import "TestFlight.h"
@implementation YourDetailsViewController
@synthesize TextFieldBackgroundView;
@synthesize nameField;
@synthesize emailField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
}
-(void)viewDidAppear:(BOOL)animated {
    USTAppDelegate *appDelegate = (USTAppDelegate*)[[UIApplication sharedApplication]delegate];
    [[self nameField]setText:[[appDelegate registrationManager]name]];
    [[self emailField]setText:[[appDelegate registrationManager]email]];
    [[self nameField]becomeFirstResponder];
}
- (IBAction)submit:(id)sender {
    if([self saveNameAndEmail]){
        [[self nameField]resignFirstResponder];
        [[self emailField]resignFirstResponder];
        [TestFlight passCheckpoint:@"set device details"];
        [[self navigationController]popViewControllerAnimated:YES];
    }
    
}
-(BOOL)saveNameAndEmail{
    if([[[self nameField] text]length]>0&&[[[self emailField] text]length]>0){
    USTAppDelegate *appDelegate = (USTAppDelegate*)[[UIApplication sharedApplication]delegate];
    return [[appDelegate registrationManager]setName:[[self nameField] text] Email:[[self emailField] text]];
    }
    return NO;
}

-(void)setupView{
    CALayer *textFieldBackgroundViewLayer = [[self TextFieldBackgroundView]layer];
    [textFieldBackgroundViewLayer setBorderColor:[[UIColor colorWithRed:227/255. green:239/255. blue:250/255. alpha:1]CGColor]];
    [textFieldBackgroundViewLayer setBorderWidth:0.6];
    [textFieldBackgroundViewLayer setCornerRadius:5];
    UIView *middleLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, [self TextFieldBackgroundView].frame.size.width, 0.6)];
    [middleLineView setBackgroundColor:[UIColor colorWithRed:227/255. green:239/255. blue:250/255. alpha:1]];
    [[self TextFieldBackgroundView] addSubview:middleLineView];
    [middleLineView release];
}
- (void)viewDidUnload
{
    [self setTextFieldBackgroundView:nil]; 
    [self setNameField:nil];
    [self setEmailField:nil];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [TextFieldBackgroundView release];
    [nameField release];
    [emailField release];
    [super dealloc];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
        if(textField.text.length>0){
            [textField resignFirstResponder];
            return YES;
        }
        return NO;
    
}
- (IBAction)Cancel:(id)sender {
        [[self navigationController]popViewControllerAnimated:YES];
}
@end
