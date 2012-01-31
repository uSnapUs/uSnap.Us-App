//
//  ImageDetailsController.m
//  uSnapUs-Native
//
//  Created by Owen Evans on 7/12/11.
//  Copyright (c) 2011 Xero. All rights reserved.
//

#import "ImageDetailsController.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface ImageDetailsController (PrivateMethods){
}
-(void) updateImageView;
@end
@implementation ImageDetailsController
@synthesize ImageView;
Picture *_picture;
-(Picture *) picture{
    return _picture;
}
-(void) setPicture:(Picture *)picture{
    _picture = picture;
    [self updateImageView];
}

-(void) updateImageView{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    [library assetForURL:[NSURL URLWithString:[self.picture resourceLocation]]
             resultBlock:^(ALAsset *asset) {
                 UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation]fullScreenImage]];
                 [[self ImageView] setImage:image];
             } failureBlock:^(NSError *error) {
                 
             }];
}


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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
