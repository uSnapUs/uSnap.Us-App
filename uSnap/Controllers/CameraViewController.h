//
//  CameraViewController.h
//  uSnap
//
//  Created by Owen Evans on 18/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>

@interface CameraViewController : UIViewController
@property(retain,atomic) AVCaptureSession *avCaptureSession;
@property(retain,atomic) AVCaptureDevice *frontCamera;
@property(retain,atomic) AVCaptureDevice *rearCamera;
@property(retain,atomic) AVCaptureStillImageOutput *stillImageOutput;
@property(retain,atomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property(retain,atomic) NSString *currentCameraPosition;
@property (retain, nonatomic) IBOutlet UIButton *SwapCameraButton;
@property (retain, nonatomic) IBOutlet UIView *CameraPreviewView;
- (IBAction)SwapCameraView:(id)sender;
- (IBAction)TakePicture:(id)sender;
@end
