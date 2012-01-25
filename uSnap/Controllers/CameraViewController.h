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
@property(retain,atomic) AVCaptureDeviceInput *currentDeviceInput;
@property(retain,atomic) AVCaptureStillImageOutput *stillImageOutput;
@property(retain,atomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (retain, nonatomic) IBOutlet UIView *CameraTopbarView;
@property(retain,atomic) NSString *currentCameraPosition;
@property (assign,atomic) NSManagedObjectContext *managedObjectContext;
@property (assign,atomic) NSManagedObjectModel *managedObjectModel;
@property (retain, nonatomic) IBOutlet UIButton *SwapCameraButton;
@property (retain, nonatomic) IBOutlet UIView *CameraPreviewView;
- (IBAction)SwapCameraView:(id)sender;
- (IBAction)TakePicture:(id)sender;
- (IBAction)GoToTimeline:(id)sender;
@end
