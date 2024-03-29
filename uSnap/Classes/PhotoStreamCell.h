//
//  PhotoStreamCell.h
//  uSnap.us
//
//  Created by Owen Evans on 26/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Picture.h"
#import "PictureUpload.h"
@interface PhotoStreamCell : UITableViewCell
@property(retain, nonatomic) IBOutlet UIImageView *photoView;
@property(retain,nonatomic) IBOutlet UIButton *editButton;
@property(retain,nonatomic) IBOutlet UIButton *cancelButton;
@property(retain,atomic) Picture *picture;
@property(retain,nonatomic) IBOutlet UIProgressView *progressView;
@property(retain,nonatomic) IBOutlet UIView *errorOverlayView;
@property(retain,nonatomic) IBOutlet UIView *progressOverlayView;
@property(retain,nonatomic) CALayer *leftBorder;
@property(retain,nonatomic) UIButton *deleteButton;
-(void)updateView;
-(void)showErrorOverlay;
-(void)showProgressView;
//-(void)removeErrorAndProgressViews;
-(void)finishedPictureUpload:(NSNotification*)notification;
-(void)retryUpload;
-(void)configureWithPicture:(Picture *)newPicture;
-(IBAction)touchCancelButton:(id)sender;
-(IBAction)touchDeleteButton:(id)sender;
@end
