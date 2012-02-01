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
#import "UIImage+Resize.h"
#import <QuartzCore/QuartzCore.h>
@interface TimelineViewController (PrivateMethods)
-(void) swipeLeftReceived;
-(void)setEventData;
-(NSString*) getTitleLabelForEvent:(Event *)event;
-(NSString*) getDateLabelForEvent:(Event *)event;
@end

@implementation TimelineViewController
@synthesize EventTitleLabel;
@synthesize EventDateLabel;
@synthesize BottomBarView;
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
     [self setEventData];
    if(currentEvent!=nil){
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"dateTaken" ascending:NO];
   
       _orderedPictures = [[currentEvent pictures]sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    [_orderedPictures retain];
        [sort release];
   
    }
    else
    {
        _orderedPictures = [[NSArray alloc]init];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setEventTitleLabel:nil];
    [self setEventDateLabel:nil];
    [self setBottomBarView:nil];
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
    CGRect originBounds = [[self view]frame];
    NSLog(@"%@",NSStringFromCGRect(originBounds));
    [[self BottomBarView]setFrame:CGRectMake(0, originBounds.size.height-53, 320, 53)];
    [[self view]addSubview:[self BottomBarView]];

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
    [[cell imageView]setImage:thumbnailImage];
    [[[cell imageView]layer]setBorderColor:[[UIColor blackColor]CGColor]];
    [[[cell imageView]layer]setBorderWidth:1];
   
    [cell layoutSubviews];
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
    [BottomBarView release];
    [super dealloc];
}
-(void) setEventData{

    UIFont *titleFont = [UIFont fontWithName:@"Bello-Script" size:38];
    
    
    [[self EventTitleLabel]setFont:titleFont];
    
    USTAppDelegate *appDelegate = (USTAppDelegate*)[[UIApplication sharedApplication]delegate];
    Event *currentEvent = [[appDelegate locationHandler]currentEvent];
    [[self EventTitleLabel]setText:[self getTitleLabelForEvent:currentEvent]];
    [[self EventDateLabel]setText:[self getDateLabelForEvent:currentEvent]];
}
-(NSString*) getDateLabelForEvent:(Event *)event{
    return [event friendlyDateString];
}
-(NSString*) getTitleLabelForEvent:(Event *)event{
    if(event!=nil&&([[event eventKey]compare:VoidEventKey]!=NSOrderedSame)){
        return [event eventTitle];
    }
    else{
        NSLog(@"Returning no event");
        return @"No Event Selected!";
    }

}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
   // [[self BottomBarView]removeFromSuperview];


    
    
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
  }
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

       [[self BottomBarView]setFrame:CGRectMake(0, scrollView.frame.size.height-53+scrollView.contentOffset.y,320, 53)];

 //   [[self view]addSubview:[self BottomBarView]];

}
- (IBAction)CameraButtonPressed:(id)sender {
    [self swipeLeftReceived];
}

- (IBAction)LocationButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"GoToSettings" sender:self];
}
@end