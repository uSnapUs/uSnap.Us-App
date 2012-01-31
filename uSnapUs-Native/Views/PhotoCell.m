//
//  PhotoCell.m
//  uSnapUs-Native
//
//  Created by Owen Evans on 7/12/11.
//  Copyright (c) 2011 Xero. All rights reserved.
//

#import "PhotoCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface PhotoCell (PrivateMethods)
-(void) updatePicture;
@end
@implementation PhotoCell
Picture *_picture;


-(id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier{
        self = [super initWithFrame:frame
                    reuseIdentifier:reuseIdentifier];
    if(self==nil){
        return nil;
    }
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:imageView];
    [self setSelectionStyle:AQGridViewCellSelectionStyleNone];
    return self;
}

-(Picture *) picture{
    return _picture;
}
-(void) setPicture:(Picture *)picture{
    _picture = picture;
    [self updatePicture];
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    CGSize imageSize = imageView.image.size;
    CGRect frame = imageView.frame;
    CGRect bounds = self.contentView.bounds;
    
    if ( (imageSize.width <= bounds.size.width) &&
        (imageSize.height <= bounds.size.height) )
    {
        return;
    }
    
    // scale it down to fit
    CGFloat hRatio = bounds.size.width / imageSize.width;
    CGFloat vRatio = bounds.size.height / imageSize.height;
    CGFloat ratio = MAX(hRatio, vRatio);
    
    frame.size.width = floorf(imageSize.width * ratio);
    frame.size.height = floorf(imageSize.height * ratio);
    frame.origin.x = floorf((bounds.size.width - frame.size.width) * 0.5);
    frame.origin.y = floorf((bounds.size.height - frame.size.height) * 0.5);
    imageView.frame = frame; 
}

-(void) updatePicture{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];    
    [library assetForURL:[NSURL URLWithString:[[self picture] resourceLocation]] resultBlock:^(ALAsset *asset) {
        imageView.image= [UIImage imageWithCGImage:[asset thumbnail]];
        [self setNeedsLayout];
    } failureBlock:^(NSError *error) {
        
    }];
    
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    NSLog(@"Selected");
}
@end
