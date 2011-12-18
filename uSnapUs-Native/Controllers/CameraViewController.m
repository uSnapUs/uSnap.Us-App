//
//  CameraViewController.m
//  uSnapUs-Native
//
//  Created by Owen Evans on 6/12/11.
//  Copyright (c) 2011 Xero. All rights reserved.
//

#import "CameraViewController.h"
#import "AppDelegate.h"
#import "Picture.h"
#import "Event.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
// used for KVO observation of the @"capturingStillImage" property to perform flash bulb animation
static const NSString *AVCaptureStillImageIsCapturingStillImageContext = @"AVCaptureStillImageIsCapturingStillImageContext";

@interface CameraViewController (PrivateMethods)
-(void) initCameraView;
@end
@implementation CameraViewController
@synthesize PreviewView;
@synthesize currentEvent;
@synthesize managedObjectContext;
@synthesize managedObjectModel;

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
    managedObjectModel = appDelegate.managedObjectModel;
    managedObjectContext = appDelegate.managedObjectContext;
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
    [stillImageOutput addObserver:self forKeyPath:@"capturingStillImage" options:NSKeyValueObservingOptionNew context:(__bridge void *)AVCaptureStillImageIsCapturingStillImageContext];
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
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if(context==(__bridge void *)AVCaptureStillImageIsCapturingStillImageContext){
        BOOL isCapturingStillImage = [[change objectForKey:NSKeyValueChangeNewKey]boolValue];
        if(isCapturingStillImage)
        {
            CATransition *animation = [CATransition animation];
			animation.duration = 0.5f;
			animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
			animation.Type = @"cameraIris";
            [[[self PreviewView] layer] addAnimation:animation forKey:nil];
		
        }
   
    }
}
- (IBAction)CaptureImage:(id)sender {
    AVCaptureConnection *connection = [stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:
     ^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
         if(error){
             return;
         }
         NSData *jpgData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
         CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, 
                                                                     imageDataSampleBuffer, 
                                                                     kCMAttachmentMode_ShouldPropagate);
         ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
         [library writeImageDataToSavedPhotosAlbum:jpgData metadata:(__bridge id)attachments completionBlock:
         ^(NSURL *assetURL, NSError *error){
             if(error){
                 return; 
             }
             
             Picture *picture = (Picture*) [NSEntityDescription insertNewObjectForEntityForName:@"Picture" inManagedObjectContext:self.managedObjectContext]; 
             [picture setEvent:currentEvent];
             [picture setDateTaken:[NSDate date]];

             [picture setResourceLocation:[assetURL absoluteString]];
             NSError *saveError = nil;
             [managedObjectContext save:&saveError];
             
         }];

     }];
}
@end
