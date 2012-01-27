//
//  TimelineViewController.m
//  uSnap.us
//
//  Created by Owen Evans on 20/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import "TimelineViewController.h"
#import "USTAppDelegate.h"
#import "Event.h"
#import "LocationHandler.h"
#import "PhotoStreamCell.h"
#import "constants.h"
@interface TimelineViewController (PrivateMethods)
-(void) swipeLeftReceived;
-(void)setEventData;
-(NSString*) getTitleLabelForEvent:(Event *)event;
-(NSString*) getDateLabelForEvent:(Event *)event;
@end

@implementation TimelineViewController
@synthesize EventTitleLabel;
@synthesize EventDateLabel;
NSArray *_orderedPictures;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    UISwipeGestureRecognizer *swipeRecogniser = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeftReceived)];
    [swipeRecogniser setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view]addGestureRecognizer:swipeRecogniser];
    [swipeRecogniser release];
    USTAppDelegate *appDelegate = (USTAppDelegate*)[[UIApplication sharedApplication]delegate];
     Event *currentEvent = [[appDelegate locationHandler]currentEvent];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"dateTaken" ascending:NO];
   
       _orderedPictures = [[currentEvent pictures]sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    [_orderedPictures retain];
    [self setEventData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setEventTitleLabel:nil];
    [self setEventDateLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void) swipeLeftReceived
{
    [self performSegueWithIdentifier:@"GoToCamera" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    NSLog(@"%@",_orderedPictures);
    return _orderedPictures.count;
    //return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PhotoStreamCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[PhotoStreamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
        
    // Configure the cell...
    Picture *picture = [_orderedPictures objectAtIndex:[indexPath row]];
    UIImage *thumbnailImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:[picture getThumbnailPath]]];
    CGImageRef imageRef = CGImageCreateWithImageInRect([thumbnailImage CGImage],CGRectMake(0, 0, 300, 300));
    [[cell imageView]setImage:[UIImage imageWithCGImage:imageRef]];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}
-(void) dealloc{
    [_orderedPictures release];
    [EventTitleLabel release];
    [EventDateLabel release];
    [super dealloc];
}
-(void) setEventData{

    UIFont *titleFont = [UIFont fontWithName:@"Bello-Script" size:38];
    
    
    [[self EventTitleLabel]setFont:titleFont];
    
    USTAppDelegate *appDelegate = (USTAppDelegate*)[[UIApplication sharedApplication]delegate];
    Event *currentEvent = [[appDelegate locationHandler]currentEvent];
    [[self EventDateLabel]setText:[self getTitleLabelForEvent:currentEvent]];
    [[self EventDateLabel]setText:[self getDateLabelForEvent:currentEvent]];
}
-(NSString*) getDateLabelForEvent:(Event *)event{
    NSDateFormatter *dateFormatter = [[NSDateFormatter init]alloc];
    [dateFormatter setDateFormat:@""];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:[event eventStart]
                                                          toDate:[event eventEnd]
                                                         options:0];
    NSDateComponents *beginComponents = [gregorianCalendar components:NSDayCalendarUnit fromDate:[event eventStart]];
    NSDateComponents *endComponents = [gregorianCalendar components:NSDayCalendarUnit fromDate:[event eventEnd]];
    [gregorianCalendar release];
    NSString *dayPart;
    if(components.day>1){
        dayPart = [NSString stringWithFormat:@"%i - %i",[beginComponents day],[endComponents day]];
    }
    else{
        dayPart = [NSString stringWithFormat:@"%i",[beginComponents day]];
    }
    return @"";
}
-(NSString*) getTitleLabelForEvent:(Event *)event{
    if(event!=nil&&[event eventKey]!=VoidEventKey){
        return [event eventTitle];
    }
    else{
        return @"No Event Selected!";
    }

}
@end