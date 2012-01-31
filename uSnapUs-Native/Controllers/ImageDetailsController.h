//
//  ImageDetailsController.h
//  uSnapUs-Native
//
//  Created by Owen Evans on 7/12/11.
//  Copyright (c) 2011 Xero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Picture.h"
@interface ImageDetailsController : UIViewController

@property(retain) Picture *picture;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;



@end
