//
//  SlideFromLeftSegue.m
//  uSnap.us
//
//  Created by Owen Evans on 20/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import "SlideFromLeftSegue.h"
#import <QuartzCore/QuartzCore.h>
@implementation SlideFromLeftSegue

-(void) perform{
    // get the view that's currently showing
	UIView *currentView = [[self sourceViewController]view];
	// get the the underlying UIWindow, or the view containing the current view view
	UIView *theWindow = [currentView superview];
	
	
	// set up an animation for the transition between the views
	CATransition *animation = [CATransition animation];
	[animation setDuration:0.5];
	[animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionFromLeft];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	
	[[theWindow layer] addAnimation:animation forKey:kCATransition];
    
    [[self sourceViewController]presentModalViewController:[self destinationViewController]animated:NO];
    
//    [[self sourceViewController]presentViewController:[self destinationViewController] animated:NO completion:NULL];
    
}

@end
