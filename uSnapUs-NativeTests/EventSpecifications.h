//
//  EventSpecifications.h
//  uSnapUs-Native
//
//  Created by Owen Evans on 5/12/11.
//  Copyright (c) 2011 Xero. All rights reserved.
//

//  Logic unit tests contain unit test code that is designed to be linked into an independent test executable.
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

#import <SenTestingKit/SenTestingKit.h>
#import "Event.h"
@interface GivenANewEvent : SenTestCase
@property(retain) Event *event;
@end
