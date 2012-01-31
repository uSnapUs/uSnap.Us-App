//
//  PhotoCell.h
//  uSnapUs-Native
//
//  Created by Owen Evans on 7/12/11.
//  Copyright (c) 2011 Xero. All rights reserved.
//

#import "AQGridViewCell.h"
#import "Picture.h"
@interface PhotoCell : AQGridViewCell
{
    UIImageView *imageView;
}

@property (nonatomic, retain) Picture *picture;

@end
