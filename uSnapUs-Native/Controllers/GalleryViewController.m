//
//  GalleryViewController.m
//  uSnapUs-Native
//
//  Created by Owen Evans on 6/12/11.
//  Copyright (c) 2011 Xero. All rights reserved.
//
#import "ImageDetailsController.h"
#import "GalleryViewController.h"
#import "EventBoundController.h"
#import "AppDelegate.h"
#import "PhotoCell.h"
#import <CoreData/CoreData.h>
@implementation GalleryViewController
@synthesize currentEvent;
@synthesize managedObjectContext;
@synthesize managedObjectModel;

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

NSArray *_orderedPictures;
- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    currentEvent = appDelegate.currentEvent;
    
    managedObjectModel = appDelegate.managedObjectModel;
    managedObjectContext = appDelegate.managedObjectContext;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataModelChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:managedObjectContext];
    [[self gridView]setDataSource:self];
    [[self gridView]setResizesCellWidthToFit:YES];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"dateTaken" ascending:YES];
    _orderedPictures = [self.currentEvent.pictures sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    self.title=@"Gallery";
    

    [[self gridView]reloadData];
}
-(void) viewWillAppear:(BOOL)animated   {
    
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)handleDataModelChange:(NSNotification *)note{
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"dateTaken" ascending:YES];
    _orderedPictures = [self.currentEvent.pictures sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    [[self gridView]reloadData];
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

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{

	return ( [_orderedPictures count] );
}


- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString *CellIdentifier = @"PhotoCell";
    PhotoCell *gridCell = (PhotoCell *)[gridView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(gridCell == nil){
        gridCell = [[PhotoCell alloc]initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0) reuseIdentifier:CellIdentifier];
    }
    gridCell.picture = (Picture *)[_orderedPictures objectAtIndex:index];
	return ( gridCell );
}
-(CGSize)portraitGridCellSizeForGridView:(AQGridView *)gridView{
    return CGSizeMake(100.0, 100.0);
}
-(void) gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index{
    [gridView deselectItemAtIndex:index animated:YES];
    currentPicture=(Picture *)[_orderedPictures objectAtIndex:index];
    [self performSegueWithIdentifier:@"ImageDetails" sender:self];
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ImageDetailsController *detailsController =  (ImageDetailsController *)[segue destinationViewController];
    detailsController.picture = currentPicture;
}
@end
