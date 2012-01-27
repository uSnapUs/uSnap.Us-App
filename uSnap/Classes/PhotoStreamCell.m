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
    [[self photoView]release];
    [super dealloc];
}

@end
