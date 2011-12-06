//
//  CameraViewController.m
//  uSnapUs-Native
//
//  Created by Owen Evans on 6/12/11.
//  Copyright (c) 2011 Xero. All rights reserved.
//

#import "CameraViewController.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
@interface CameraViewController (PrivateMethods)
-(void) initCameraView;
@end
@implementation CameraViewController
@synthesize PreviewView;
@synthesize currentEvent;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    currentEvent = appDelegate.currentEvent;
    [self initCameraView];
}


- (void)viewDidUnload
{
    [self setPreviewView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

AVCaptureSession *avCaptureSession;
AVCaptureDevice *photoDevice;
AVCaptureStillImageOutput *stillImageOutput;
AVCaptureVideoPreviewLayer *videoPreviewLayer;

-(void) initCameraView{
    NSError *error = nil;
    avCaptureSession = [[AVCaptureSession alloc]init];
    [avCaptureSession setSessionPreset:AVCaptureSessionPresetPhoto];
    photoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:photoDevice
                                                                              error:&error];
    if(error){
        return;
    }
    NSError *lockError = nil;
    if([photoDevice lockForConfiguration:&lockError]){
        [photoDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        [photoDevice unlockForConfiguration];
    }
    if([avCaptureSession canAddInput:deviceInput]){
        [avCaptureSession addInput:deviceInput];
    }
    stillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    if([avCaptureSession canAddOutput:stillImageOutput]){
        [avCaptureSession addOutput:stillImageOutput];
    }
    videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:avCaptureSession];
    CALayer *rootLayer = [[self PreviewView]layer];
    [rootLayer setMasksToBounds:YES];
    [videoPreviewLayer setFrame:[rootLayer bounds]];
    [rootLayer addSublayer:videoPreviewLayer];
    [avCaptureSession startRunning];
}

@end
