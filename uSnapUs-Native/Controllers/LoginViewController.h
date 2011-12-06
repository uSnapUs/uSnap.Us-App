//
//  LoginViewController.h
//  uSnapUs-Native
//
//  Created by Owen Evans on 5/12/11.
//  Copyright (c) 2011 Xero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
- (IBAction)GoButtonClicked:(id)sender;

@end
