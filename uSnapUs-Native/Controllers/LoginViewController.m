//
//  LoginViewController.m
//  uSnapUs-Native
//
//  Created by Owen Evans on 5/12/11.
//  Copyright (c) 2011 Xero. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Event.h"
#import "EventBoundController.h"

@implementation LoginViewController
@synthesize fetchedResultsController;
@synthesize managedObjectContext;
Event *currentEvent;
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
    if (managedObjectContext == nil) 
    { 
        AppDelegate *d = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        managedObjectContext = [d managedObjectContext];
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)GoButtonClicked:(id)sender {
    NSString *eventKey = @"testEvent";
    NSEntityDescription *eventEntity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.entity = eventEntity;
    request.fetchLimit = 1;
    request.predicate = [NSPredicate predicateWithFormat:@"eventKey=%@",eventKey];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request
                                             error:&error];
    Event *event = nil;
    if(error || [results count]<1){
        event = (Event*) [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext]; 
        event.eventKey = eventKey;
        NSError *saveError = nil;
        [managedObjectContext save:&saveError];

    }
    else{
        event = (Event*)[results objectAtIndex:0];
    }
    currentEvent = event;
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.currentEvent = currentEvent;
    [self performSegueWithIdentifier:@"InitialSegue" sender:self];
    

}
@end
