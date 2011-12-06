//
//  EventBoundController.h
//  uSnapUs-Native
//
//  Created by Owen Evans on 6/12/11.
//  Copyright (c) 2011 Xero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
@protocol EventBoundController <NSObject>
    @property(assign) Event *currentEvent;
@end
