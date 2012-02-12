//
//  EventSettingsViewController.m
//  uSnap.us
//
//  Created by Owen Evans on 20/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import "EventSettingsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MKMapView+ZoomLevel.h"
#import "USTAppDelegate.h"
#import "constants.h"
#import "EventPinView.h"
@interface EventSettingsViewController (Private){
    
}
-(void)updateMapToEvent;
-(void) setupView;
@end
@implementation EventSettingsViewController
@synthesize YourDetailsButton;
@synthesize Map;
@synthesize EnterCodeButton;

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
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [[self Map]setZoomEnabled:YES];
    [self updateMapToEvent];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
     [notificationCenter addObserver:self selector:@selector(updateMapToEvent) name:uSnapEventUpdatedNotification object:nil];
        [self setupView];
   
}
-(void)updateMapToEvent{
    USTAppDelegate *appDelegate = (USTAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    Event *currentEvent = [[appDelegate locationHandler]currentEvent];
    if(currentEvent==nil||([[currentEvent eventKey]compare:VoidEventKey]==NSOrderedSame)){
        [self setTitle:@"Join your event"];
        if(CLLocationCoordinate2DIsValid([[appDelegate locationHandler]lastLocation])){
            [[self Map]setCenterCoordinate:[[appDelegate locationHandler]lastLocation] zoomLevel:12 animated:YES];
        }
    }
    else
    {
        [self setTitle:currentEvent.eventTitle];
        [[self Map]setCenterCoordinate:CLLocationCoordinate2DMake([[currentEvent latitude]floatValue], [[currentEvent longitude]floatValue]) zoomLevel:14 animated:YES];
        [[self Map]removeAnnotations:[[self Map]annotations]];
        [[self Map]addAnnotations:[[appDelegate locationHandler]lastSetOfEvents]];

    }
    
}

- (void)viewDidUnload
{
    [self setEnterCodeButton:nil];
    [self setMap:nil];
    [self setYourDetailsButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)Done:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (void)dealloc {
    [EnterCodeButton release];
    [Map release];
    [YourDetailsButton release];
    [super dealloc];
}
- (IBAction)GoToEnterCode:(id)sender {
    [self performSegueWithIdentifier:@"GoToCode" sender:self];
}

- (IBAction)goToEnterDetails:(id)sender {
    [self performSegueWithIdentifier:@"GoToDetails" sender:self];
}
-(void)setupView{
    CALayer *topWhiteLayer = [[CALayer alloc]init];
    [topWhiteLayer setFrame:CGRectMake(0, 0, 320, 1)];
     UIColor *offWhite = [UIColor colorWithRed:246/255. green:250/255. blue:253/255. alpha:1];
    [topWhiteLayer setBackgroundColor:offWhite.CGColor];
    [[[self EnterCodeButton]layer]addSublayer:topWhiteLayer];
    [topWhiteLayer release];
    UIColor *borderBlue = [UIColor colorWithRed:227/255. green:239/255. blue:250/255. alpha:1];
    CALayer *topBlueLayer = [[CALayer alloc]init];
    
    [topBlueLayer setFrame:CGRectMake(0, 0, 320, 1)];
    [topBlueLayer setBackgroundColor:borderBlue.CGColor];
    CALayer *bottomBlueLayer = [[CALayer alloc]init];
    
    [bottomBlueLayer setFrame:CGRectMake(0, [[self YourDetailsButton]bounds].size.height, 320, 1)];
    [bottomBlueLayer setBackgroundColor:borderBlue.CGColor];
    [[[self YourDetailsButton]layer]addSublayer:topBlueLayer];
    [[[self YourDetailsButton]layer]addSublayer:bottomBlueLayer];
    [topBlueLayer release];
    [bottomBlueLayer release];
    CALayer *mapLayer = [[self Map]layer];
    CALayer *bottomBlackBar = [[CALayer alloc]init];
    [bottomBlackBar setFrame:CGRectMake(0, 247, 320, 1)];
    [bottomBlackBar setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor];
    [mapLayer addSublayer:bottomBlackBar];
    [bottomBlackBar release];

    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if(![annotation isKindOfClass:[Event class]])
        return nil;
    EventPinView *pinView = (EventPinView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"EventPin"];
    if(!pinView){
        pinView = [[[EventPinView alloc]initWithAnnotation:annotation reuseIdentifier:@"EventPin"]autorelease];
        [pinView setCanShowCallout:YES];
        [pinView setPinColor:MKPinAnnotationColorGreen];
       
       
    }
    Event *event = (Event*)annotation;
    USTAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //  [rightButton setFrame:CGRectMake(0, 0, 58, 59)];
    Event *currentEvent = [[appDelegate locationHandler]currentEvent];
    if([[[event objectID]URIRepresentation]isEqual:[[currentEvent objectID]URIRepresentation]]){
        [rightButton setImage:[UIImage imageNamed:@"check_selected.png"] forState:UIControlStateDisabled];
        
        [rightButton setEnabled:NO];

    }
    else{
    [rightButton setImage:[UIImage imageNamed:@"check_unselected.png"] forState:UIControlStateNormal];
          [rightButton setImage:[UIImage imageNamed:@"check_unselected.png"] forState:UIControlStateSelected];
    
    [rightButton addTarget:pinView action:@selector(selectEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    [pinView setRightCalloutAccessoryView:rightButton];
    [pinView setAnnotation:annotation];
    return pinView;
}
@end
