//
//  AddCodeViewController.m
//  uSnap.us
//
//  Created by Owen Evans on 30/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import "AddCodeViewController.h"
#import "USTAppDelegate.h"
#import "LocationHandler.h"
#import "TestFlight.h"
#import <QuartzCore/QuartzCore.h>
@implementation AddCodeViewController
@synthesize codeField;
@synthesize ErrorView;
@synthesize ErrorLabel;

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
//    UIBarButtonItem *backButton = [[self navigationItem]backBarButtonItem];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"Cancel";    
    [temporaryBarButtonItem setStyle:UIBarButtonItemStylePlain];
    [temporaryBarButtonItem setTintColor:[UIColor blackColor]];
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [temporaryBarButtonItem release];
    CGColorRef borderColor = [[UIColor colorWithRed:227/255. green:239/255. blue:250/255. alpha:1]CGColor];
    CALayer *topBorder = [[CALayer alloc]init];
    [topBorder setBackgroundColor:borderColor];
    [topBorder setFrame:CGRectMake(0, 0, 320, 1)];
    
    [[[self codeField]layer]addSublayer:topBorder];
    CALayer *bottomBorder = [[CALayer alloc]init];
    [bottomBorder setBackgroundColor:borderColor];
    [bottomBorder setFrame:CGRectMake(0, [[[self codeField]layer]bounds].size.height-1, 320, 1)];
    
    [[[self codeField]layer]addSublayer:bottomBorder];  
    [topBorder release];
    [bottomBorder release];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
      [[self codeField]becomeFirstResponder];
}
- (void)viewDidUnload
{
    [[self codeField]resignFirstResponder];
    [self setCodeField:nil];
    [self setErrorView:nil];
    [self setErrorLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if([self setEventFromCurrentCode]){
        
        [textField resignFirstResponder];
        
        [TestFlight passCheckpoint:@"loaded event from code"];

        [[self navigationController]popViewControllerAnimated:YES];
    }
    else
    {
       // [textField becomeFirstResponder];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.text.length>0&&[self setEventFromCurrentCode]){
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}

- (IBAction)Done:(id)sender {
    
    if([self setEventFromCurrentCode]){
        [[self codeField] resignFirstResponder];
                [TestFlight passCheckpoint:@"loaded event from code"];
        [[self navigationController]popViewControllerAnimated:YES];
    }
}
- (IBAction)Cancel:(id)sender {
    [[self navigationController]popViewControllerAnimated:YES];
}

-(BOOL)setEventFromCurrentCode{
    USTAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSString *code= [[self codeField]text];
    if(code.length>0){
        if([[delegate locationHandler]setCurrentEventFromCode:code]){
           
            return YES;
        }
    }  
    [self fadeInErrorMessage];
    return NO;
}
-(void) fadeInErrorMessage{

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(fadeOutErrorMessage)];

    
    [[self ErrorView]setFrame:CGRectMake(0, 0, 320, 73)];

    [UIView commitAnimations];
}
-(void)fadeOutErrorMessage{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    [[self ErrorView]setFrame:CGRectMake(0, -73, 320, 73)];
    
    [UIView commitAnimations];
}
- (void)dealloc {
    [codeField release];
    [ErrorView release];
    [ErrorLabel release];
    [super dealloc];
}
@end
