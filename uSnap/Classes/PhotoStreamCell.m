//
//  PhotoStreamCell.m
//  uSnap.us
//
//  Created by Owen Evans on 26/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import "PhotoStreamCell.h"

@implementation PhotoStreamCell
@synthesize photoView;
@synthesize editButton;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor blackColor]];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) dealloc{
    
    [self setPhotoView:nil];
    [self setEditButton:nil];
    
    [super dealloc];
}
-(void)layoutSubviews{
      [super layoutSubviews];  
    //[self setFrame:CGRectMake(0, 0, 320, 360)];
    [[self imageView]setFrame:CGRectMake(10, 0, 300, 300)];
    [[self imageView]setUserInteractionEnabled:YES];
    
    if([self editButton]==nil){
        UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        UIButton *b =  [UIButton buttonWithType:UIButtonTypeCustom];
        [self setEditButton:b];
        [[self editButton] setFrame:CGRectMake(267, 267,23, 23)];
        [[self editButton] setBackgroundImage:[UIImage imageNamed:@"stream-pen.png"]forState:UIControlStateNormal];
        [[[self editButton] imageView]setHidden:NO];
       // [editButton setBackgroundColor:[UIColor whiteColor]];
        [buttonView addSubview:[self editButton]];
        [[self imageView]addSubview:buttonView];
        [buttonView release];
        
    }  

}
@end
