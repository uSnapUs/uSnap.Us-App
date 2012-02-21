//
//  PhotoProgressView.m
//  uSnap.us
//
//  Created by Owen Evans on 21/02/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import "PhotoProgressView.h"

@implementation PhotoProgressView
UIColor *lineColor;
UIColor *progressRemainingColor;
UIColor *progressColor;

-(void)drawRect:(CGRect)rect
{
    
    if([self progressViewStyle] == UIProgressViewStyleDefault)
	{
        lineColor = [UIColor whiteColor];
        progressRemainingColor = [[UIColor blackColor]colorWithAlphaComponent:.5];
        progressColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetLineWidth(context, 2);
        
        CGContextSetStrokeColorWithColor(context,[lineColor CGColor]);
        CGContextSetFillColorWithColor(context, [[progressRemainingColor colorWithAlphaComponent:.7] CGColor]);
        
        
        float radius = (rect.size.height / 2) - 2;
        CGContextMoveToPoint(context, 2, rect.size.height/2);
        
        CGContextAddArcToPoint(context, 2, 2, radius + 2, 2, radius);
        CGContextAddLineToPoint(context, rect.size.width - radius - 2, 2);
        CGContextAddArcToPoint(context, rect.size.width - 2, 2, rect.size.width - 2, rect.size.height / 2, radius);
        CGContextFillPath(context);
        
        CGContextSetFillColorWithColor(context, [progressRemainingColor CGColor]);
        
        CGContextMoveToPoint(context, rect.size.width - 2, rect.size.height/2);
        CGContextAddArcToPoint(context, rect.size.width - 2, rect.size.height - 2, rect.size.width - radius - 2, rect.size.height - 2, radius);
        CGContextAddLineToPoint(context, radius + 2, rect.size.height - 2);
        CGContextAddArcToPoint(context, 2, rect.size.height - 2, 2, rect.size.height/2, radius);
        CGContextFillPath(context);
        
        
        CGContextMoveToPoint(context, 2, rect.size.height/2);
        
        CGContextAddArcToPoint(context, 2, 2, radius + 2, 2, radius);
        CGContextAddLineToPoint(context, rect.size.width - radius - 2, 2);
        CGContextAddArcToPoint(context, rect.size.width - 2, 2, rect.size.width - 2, rect.size.height / 2, radius);
        CGContextAddArcToPoint(context, rect.size.width - 2, rect.size.height - 2, rect.size.width - radius - 2, rect.size.height - 2, radius);
        
        CGContextAddLineToPoint(context, radius + 2, rect.size.height - 2);
        CGContextAddArcToPoint(context, 2, rect.size.height - 2, 2, rect.size.height/2, radius);
        CGContextStrokePath(context);
        
        CGContextSetFillColorWithColor(context, [progressColor CGColor]);
        
        radius = radius - 2;
        CGContextMoveToPoint(context, 4, rect.size.height/2);
        float amount = [self progress] * (rect.size.width);
        
        if (amount >= radius + 4 && amount <= (rect.size.width - radius - 4)) {
            CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius);
            CGContextAddLineToPoint(context, amount, 4);
            //CGContextAddLineToPoint(context, amount, radius + 4);
            CGContextAddArcToPoint(context, amount + radius + 4, 4,  amount + radius + 4, rect.size.height/2, radius);
            
            CGContextFillPath(context);
            
            CGContextSetFillColorWithColor(context, [progressColor CGColor]);
            CGContextMoveToPoint(context, 4, rect.size.height/2);
            CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius);
            CGContextAddLineToPoint(context, amount, rect.size.height - 4);
            CGContextAddArcToPoint(context, amount + radius + 4, rect.size.height - 4,  amount + radius + 4, rect.size.height/2, radius);
            //CGContextAddLineToPoint(context, amount, radius + 4);
            CGContextFillPath(context);
        } else if (amount > radius + 4) {
            CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius);
            CGContextAddLineToPoint(context, rect.size.width - radius - 4, 4);
            CGContextAddArcToPoint(context, rect.size.width - 4, 4, rect.size.width - 4, rect.size.height/2, radius);
            CGContextFillPath(context);
            
            CGContextSetFillColorWithColor(context, [progressColor CGColor]);
            CGContextMoveToPoint(context, 4, rect.size.height/2);
            CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius);
            CGContextAddLineToPoint(context, rect.size.width - radius - 4, rect.size.height - 4);
            CGContextAddArcToPoint(context, rect.size.width - 4, rect.size.height - 4, rect.size.width - 4, rect.size.height/2, radius);
            CGContextFillPath(context);
        } else if (amount < radius + 4 && amount > 0) {
            CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius);
            CGContextAddLineToPoint(context, radius + 4, rect.size.height/2);
            CGContextFillPath(context);
            
            CGContextSetFillColorWithColor(context, [progressColor CGColor]);
            CGContextMoveToPoint(context, 4, rect.size.height/2);
            CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius);
            CGContextAddLineToPoint(context, radius + 4, rect.size.height/2);
            CGContextFillPath(context);
        }

    }
    else{
        [super drawRect:rect];
    }
}
@end
