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
        [self setTitle:@"Choose an Event"];
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
    [super dealloc];
}
- (IBAction)GoToEnterCode:(id)sender {
    [self performSegueWithIdentifier:@"GoToCode" sender:self];
}
-(void)setupView{
    CALayer *buttonLayer = [[self EnterCodeButton]layer];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, 43.0f, buttonLayer.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    [buttonLayer addSublayer:bottomBorder];
    UILabel *elipsisLabel = [[UILabel alloc]initWithFrame:[buttonLayer bounds]];
    [elipsisLabel setTextAlignment:UITextAlignmentRight];
    [elipsisLabel setText:@">"];
    [[self EnterCodeButton] insertSubview:elipsisLabel atIndex:0];
    [elipsisLabel release];   
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if(![annotation isKindOfClass:[Event class]])
        return nil;
    EventPinView *pinView = (EventPinView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"EventPin"];
    if(!pinView){
        pinView = [[[EventPinView alloc]initWithAnnotation:annotation reuseIdentifier:@"EventPin"]autorelease];
        [pinView setCanShowCallout:YES];
        [pinView setPinColor:MKPinAnnotationColorGreen];
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [rightButton addTarget:pinView action:@selector(selectEvent) forControlEvents:UIControlEventTouchUpInside];
        [pinView setRightCalloutAccessoryView:rightButton];
       
    }

    [pinView setAnnotation:annotation];
    return pinView;
}
@end
