//
//  CameraViewController.m
//  uSnap
//
//  Created by Owen Evans on 18/01/12.
//  Copyright (c) 2012 uSnap.us Limited. All rights reserved.
//
#import "USTAppDelegate.h"
#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreMedia/CoreMedia.h>
#import "Picture.h"
// used for KVO observation of the @"capturingStillImage" property to perform shutter animation
static const NSString *AVCaptureStillImageIsCapturingStillImageContext = @"AVCaptureStillImageIsCapturingStillImageContext";

@interface CameraViewController (Private){
}
-(void)loadCurrentEvent;
-(void)initCameraView;
-(void)startSession;
@end
@implementation CameraViewController

#pragma mark properties
@synthesize avCaptureSession;
@synthesize frontCamera;
@synthesize rearCamera;
@synthesize stillImageOutput;
@synthesize CameraPreviewView;
@synthesize videoPreviewLayer;
@synthesize CameraTopbarView;
@synthesize SwapCameraButton;
@synthesize currentCameraPosition;
@synthesize currentDeviceInput;
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

-(void)viewDidLoad{
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"HideSplash"];
    USTAppDelegate* appDelegate = (USTAppDelegate *)[[UIApplication sharedApplication]delegate];
    [self setManagedObjectModel:[appDelegate managedObjectModel]];
     [self setManagedObjectContext:[appDelegate managedObjectContext]];
    [self initCameraView];
     
}

- (void)viewDidUnload
{
    [self setCameraPreviewView:nil];
    [self setSwapCameraButton:nil];
    [self setCameraTopbarView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL hideSplash = [defaults boolForKey:@"HideSplash"];
    if(hideSplash)
    {
        [self loadCurrentEvent];
    }
    else
    {   
        [defaults setBool:YES forKey:@"HideSplash"];
        [self performSegueWithIdentifier:@"ShowSplash" sender:self];
    }
}

#pragma mark - Memory Lifecycle
-(void) dealloc{
    [CameraPreviewView release];
    [avCaptureSession release];
    if(frontCamera!=nil){
    [frontCamera release];
    }
    if(rearCamera!=nil){
    [rearCamera release];
    }
    [stillImageOutput release];
    [videoPreviewLayer release];
    [SwapCameraButton release];
    [CameraTopbarView release];
    [super dealloc];

}

#pragma mark - Private Methods

-(void) loadCurrentEvent{
    USTAppDelegate *appDelegate = (USTAppDelegate*)[[UIApplication sharedApplication]delegate];
    [[appDelegate locationHandler]initalizeLocation];
}

-(void) initCameraView{
    NSError *error = nil;
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    [self setAvCaptureSession:session];
    [session release];
    [[self avCaptureSession] setSessionPreset:AVCaptureSessionPresetPhoto];
    NSArray *photoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    if([photoDevices count]<2){
        [[self SwapCameraButton]setHidden:YES];
    }
    for(AVCaptureDevice *device in photoDevices){
        if([device position]==AVCaptureDevicePositionBack){
            [self setRearCamera:device];
        }
        else
        {
            [self setFrontCamera:device];
        }
    }
    [self setCurrentDeviceInput:[AVCaptureDeviceInput deviceInputWithDevice:[self rearCamera] error:&error]];
    if(error){
        return;
    }
    if([[self avCaptureSession]canAddInput:[self currentDeviceInput]]){
        [[self avCaptureSession]addInput:[self currentDeviceInput]];
    }
    AVCaptureStillImageOutput *imageOutput = [[AVCaptureStillImageOutput alloc]init];
    [self setStillImageOutput:imageOutput];
    [[self stillImageOutput] addObserver:self forKeyPath:@"capturingStillImage" options:NSKeyValueObservingOptionNew context:(void *)AVCaptureStillImageIsCapturingStillImageContext];

    if([[self avCaptureSession]canAddOutput:[self stillImageOutput]]){
        [avCaptureSession addOutput:[self stillImageOutput]];
    }
    [imageOutput release];
    
    AVCaptureVideoPreviewLayer *previewLayer =  [[AVCaptureVideoPreviewLayer alloc]initWithSession:[self avCaptureSession]];
    [self setVideoPreviewLayer:previewLayer];
    [previewLayer release];
    CALayer *rootLayer = [[self CameraPreviewView]layer];
    [rootLayer setMasksToBounds:YES];
    [[self videoPreviewLayer]setFrame:[rootLayer bounds]];
    [rootLayer addSublayer:videoPreviewLayer];
    [[self CameraPreviewView]bringSubviewToFront:[self CameraTopbarView]];
    [avCaptureSession startRunning];
    [error release];
}
- (NSUInteger) cameraCount
{
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}
-(void) startSession{
    [[self avCaptureSession]startRunning];
}
- (IBAction)SwapCameraView:(id)sender {
    if ([self cameraCount] > 1) {
                  
        NSError *error;
        AVCaptureDeviceInput *newVideoInput = nil;
        AVCaptureDevicePosition position = [[[self currentDeviceInput] device] position];
        [[self avCaptureSession]stopRunning];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(startSession)];
        if (position == AVCaptureDevicePositionBack){
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                                   forView:[self CameraPreviewView]
                                     cache:YES];

        }
        else if (position == AVCaptureDevicePositionFront){
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self rearCamera] error:&error];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                                   forView:[self CameraPreviewView]
                                     cache:YES];

        }
        
        [UIView commitAnimations];
        if (newVideoInput != nil) {
            [[self avCaptureSession] beginConfiguration];
            [[self avCaptureSession] removeInput:[self currentDeviceInput]];
            if ([[self avCaptureSession] canAddInput:newVideoInput]) {
                [[self avCaptureSession] addInput:newVideoInput];
                [self setCurrentDeviceInput:newVideoInput];
            } else {
                [[self avCaptureSession] addInput:[self currentDeviceInput]];
            }
            [[self avCaptureSession] commitConfiguration];
            [newVideoInput release];
        } 
       


    }
}

- (IBAction)TakePicture:(id)sender {
    AVCaptureConnection *connection = [stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    [[self stillImageOutput]captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if(error){
            return;
        }
        NSData *jpgData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, 
                                                                    imageDataSampleBuffer, 
                                                                    kCMAttachmentMode_ShouldPropagate);
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
        
        [library writeImageDataToSavedPhotosAlbum:jpgData metadata:(id)attachments completionBlock:
         ^(NSURL *assetURL, NSError *error){
             if(error){
                 return; 
             }
             
         }];
        CFRelease(attachments);
        [library release];
        Picture *picture = (Picture*) [NSEntityDescription insertNewObjectForEntityForName:@"Picture" inManagedObjectContext:[self managedObjectContext]]; 
//        [picture setEvent:currentEvent];
        [picture setDateTaken:[NSDate date]];
        [picture setImage:jpgData];
        NSError *saveError = nil;
        [managedObjectContext save:&saveError];
        [saveError release];
        [picture beginUpload];
    }];
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
            [[[self CameraPreviewView] layer] addAnimation:animation forKey:nil];
            
        }
        
    }
}

@end
