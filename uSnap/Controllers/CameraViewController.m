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
@interface CameraViewController (Private){
}
-(void)loadCurrentEvent;
-(void)initCameraView;

@end
@implementation CameraViewController

#pragma mark properties
@synthesize avCaptureSession;
@synthesize frontCamera;
@synthesize rearCamera;
@synthesize stillImageOutput;
@synthesize CameraPreviewView;
@synthesize videoPreviewLayer;
@synthesize SwapCameraButton;
@synthesize currentCameraPosition;


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
    [self initCameraView];
}

- (void)viewDidUnload
{
    [self setCameraPreviewView:nil];
    [self setSwapCameraButton:nil];
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
    [[self avCaptureSession]release];
    [[self frontCamera]release];
    [[self rearCamera]release];
    [[self stillImageOutput]release];
    [[self videoPreviewLayer]release];
    [SwapCameraButton release];
    [super dealloc];

}

#pragma mark - Private Methods

-(void) loadCurrentEvent{
    USTAppDelegate *appDelegate = (USTAppDelegate*)[[UIApplication sharedApplication]delegate];
    [[appDelegate locationHandler]initalizeLocation];
}

-(void) initCameraView{
    NSError *error = nil;
    [self setAvCaptureSession:[[AVCaptureSession alloc]init]];
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
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:[self rearCamera] error:&error];
    if(error){
        return;
    }
    if([[self avCaptureSession]canAddInput:deviceInput]){
        [[self avCaptureSession]addInput:deviceInput];
    }
    [self setStillImageOutput:[[AVCaptureStillImageOutput alloc]init]];
    if([[self avCaptureSession]canAddOutput:[self stillImageOutput]]){
        [avCaptureSession addOutput:[self stillImageOutput]];
    }
    [self setVideoPreviewLayer:[[AVCaptureVideoPreviewLayer alloc]initWithSession:[self avCaptureSession]]];
    CALayer *rootLayer = [[self CameraPreviewView]layer];
    [rootLayer setMasksToBounds:YES];
    [[self videoPreviewLayer]setFrame:[rootLayer bounds]];
    [rootLayer addSublayer:videoPreviewLayer];
    [avCaptureSession startRunning];
}

- (IBAction)SwapCameraView:(id)sender {
    if ([self cameraCount] > 1) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[videoInput device] position];
        
        if (position == AVCaptureDevicePositionBack)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontFacingCamera] error:&error];
        else if (position == AVCaptureDevicePositionFront)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backFacingCamera] error:&error];
        else
            goto bail;
        
        if (newVideoInput != nil) {
            [[self session] beginConfiguration];
            [[self session] removeInput:[self videoInput]];
            if ([[self session] canAddInput:newVideoInput]) {
                [[self session] addInput:newVideoInput];
                [self setVideoInput:newVideoInput];
            } else {
                [[self session] addInput:[self videoInput]];
            }
            [[self session] commitConfiguration];
            success = YES;
            [newVideoInput release];
        } else if (error) {
            if ([[self delegate] respondsToSelector:@selector(captureManager:didFailWithError:)]) {
                [[self delegate] captureManager:self didFailWithError:error];
            }
        }
    }

}

- (IBAction)TakePicture:(id)sender {
}
@end
