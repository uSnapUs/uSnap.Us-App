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
#import <MobileCoreServices/MobileCoreServices.h>
#import "Picture.h"
#import "constants.h"
#import "TestFlight.h"
// used for KVO observation of the @"capturingStillImage" property to perform shutter animation
static const NSString *AVCaptureStillImageIsCapturingStillImageContext = @"AVCaptureStillImageIsCapturingStillImageContext";

@interface CameraViewController (Private){
}
-(void) addPreviewLayer;
-(void)loadCurrentEvent;
-(void)initCameraView;
-(void)startSession;
-(void)swipedFromRight;
-(void)eventUpdated;
-(void)configureButtons;
-(void)savePictureData:(NSData *)jpegRepresentation;
-(void)autoFocusDevice: (AVCaptureDevice*) device AtPoint:(CGPoint)focusPoint;
-(CGPoint) convertToPointOfInterestFromViewCoordinates:(CGPoint)pointInView;
-(void) showFocusOverlayAtPoint:(CGPoint) point;
@end
@implementation CameraViewController
@synthesize CameraShutterButton;
@synthesize CameraSwapButton;
@synthesize BottomToolbar;
@synthesize LocationButton;
@synthesize orientation;
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
@synthesize FlashButton;


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

    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self configureButtons];
    UISwipeGestureRecognizer *gestureRecogniser = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedFromRight)];
    [gestureRecogniser setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view]addGestureRecognizer:gestureRecogniser];
    [gestureRecogniser release];
    [self performSelectorInBackground:@selector(initCameraView) withObject:self];
      NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [self eventUpdated];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [notificationCenter addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    orientation = AVCaptureVideoOrientationPortrait;
    [notificationCenter addObserver:self selector:@selector(eventUpdated) name:uSnapEventUpdatedNotification object:nil];
    UITapGestureRecognizer *tapRecogniser = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                   action:@selector(autoFocusOnTap:)];
    [tapRecogniser setDelegate:self];
    [tapRecogniser setNumberOfTapsRequired:1];
    [[self CameraPreviewView]addGestureRecognizer:tapRecogniser];
     
}

- (void)viewDidUnload
{
    [self setCameraPreviewView:nil];
    [self setSwapCameraButton:nil];
    [self setCameraTopbarView:nil];
    [self setFlashButton:nil];
    [self setCameraSwapButton:nil];
    [self setBottomToolbar:nil];
    [self setLocationButton:nil];
    [self setCameraShutterButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)viewWillAppear:(BOOL)animated  {
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
          [self loadCurrentEvent];
    [self addPreviewLayer];
  /*   
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HideSplash"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSegueWithIdentifier:@"ShowSplash" sender:self];
    */
}
-(void) swipedFromRight{
    [self GoToTimeline:NULL];
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
    [FlashButton release];
    [CameraSwapButton release];
    [BottomToolbar release];
    [LocationButton release];
    [CameraShutterButton release];
    [super dealloc];

}

#pragma mark - Private Methods

-(void) loadCurrentEvent{
    USTAppDelegate *appDelegate = (USTAppDelegate*)[[UIApplication sharedApplication]delegate];
    [[appDelegate locationHandler]initalizeLocation];
}

-(void) initCameraView{
    if([self avCaptureSession]!=nil){
        return;
    }
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
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [self setVideoPreviewLayer:previewLayer];
    
    [previewLayer release];
    
    [error release];
    [self performSelectorOnMainThread:@selector(addPreviewLayer) withObject:self waitUntilDone:NO];
}
-(void) addPreviewLayer
{
    CALayer *rootLayer = [[self CameraPreviewView]layer];
    [rootLayer setMasksToBounds:YES];
    [[self videoPreviewLayer]setFrame:[rootLayer frame]];
    if(![[self videoPreviewLayer]superlayer]){
    [[self videoPreviewLayer]removeFromSuperlayer];
    }
    [rootLayer addSublayer:videoPreviewLayer];
    
    [[self CameraPreviewView]bringSubviewToFront:[self CameraTopbarView]];
    
    [[self CameraPreviewView]bringSubviewToFront:[self LocationButton]];
    [avCaptureSession startRunning];
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
             if ([[self frontCamera] isFocusModeSupported:AVCaptureFocusModeAutoFocus])
             {
            NSError *lockError;
            
            if([[self frontCamera] lockForConfiguration:&lockError ])
            {
                [[self frontCamera] setFocusMode:AVCaptureFocusModeAutoFocus];
                [[self frontCamera] unlockForConfiguration];
            }            
             }
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                                   forView:[self CameraPreviewView]
                                     cache:YES];

        }
        else if (position == AVCaptureDevicePositionFront){
            NSError *lockError;
            if ([[self rearCamera] isFocusModeSupported:AVCaptureFocusModeAutoFocus])
            {
            if([[self rearCamera] lockForConfiguration:&lockError ])
            {
                [[self rearCamera] setFocusMode:AVCaptureFocusModeAutoFocus];
                [[self rearCamera] unlockForConfiguration];
            }
            }

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
- (void)deviceOrientationDidChange
{	
	UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
	if (deviceOrientation == UIDeviceOrientationPortrait)
		orientation = AVCaptureVideoOrientationPortrait;
	else if (deviceOrientation == UIDeviceOrientationPortraitUpsideDown)
		orientation = AVCaptureVideoOrientationPortraitUpsideDown;
	
	// AVCapture and UIDevice have opposite meanings for landscape left and right (AVCapture orientation is the same as UIInterfaceOrientation)
	else if (deviceOrientation == UIDeviceOrientationLandscapeLeft)
		orientation = AVCaptureVideoOrientationLandscapeRight;
	else if (deviceOrientation == UIDeviceOrientationLandscapeRight)
		orientation = AVCaptureVideoOrientationLandscapeLeft;
	
	// Ignore device orientations for which there is no corresponding still image orientation (e.g. UIDeviceOrientationFaceUp)
}
- (IBAction)TakePicture:(id)sender {
    AVCaptureConnection *connection = [stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if ([connection isVideoOrientationSupported])
        [connection setVideoOrientation:orientation];
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
        [self savePictureData:jpgData];
    }];
}

- (IBAction)GoToTimeline:(id)sender {
    //[self prepareForSegue:@"GoToTimeline" sender:self];
    [self performSegueWithIdentifier:@"GoToTimeline" sender:self];
    
    
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
-(void)eventUpdated{
     USTAppDelegate* appDelegate = (USTAppDelegate *)[[UIApplication sharedApplication]delegate];
    LocationHandler *locHandler = [appDelegate locationHandler];
    
    if([locHandler currentEvent]==nil){
       // NSLog(@"Currently updating location");
        [[self LocationButton]setTitle:@"searching" forState:UIControlStateNormal];
    }
    else if([[[locHandler currentEvent]eventKey]compare:VoidEventKey]==NSOrderedSame){
       // NSLog(@"No Event");
           [[self LocationButton]setTitle:@"no event" forState:UIControlStateNormal];
    }
    else{
       // NSLog(@"%@",[locHandler currentEvent]);
       // NSLog(@"Event");
           [[self LocationButton]setTitle:[[locHandler currentEvent]eventTitle] forState:UIControlStateNormal];
    }
}
-(void) configureButtons{
    CALayer *layer = [[self FlashButton]layer];
    [layer setCornerRadius:16.0f];
    [layer setBorderColor:[UIColor colorWithRed:.0 green:.0 blue:.0 alpha:0.3].CGColor];
    [layer setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:.3].CGColor];
    [layer setBorderWidth:1.0f];
    layer = [[self CameraSwapButton]layer];
    [layer setCornerRadius:16.0f];
    [layer setBorderColor:[UIColor colorWithRed:.0 green:.0 blue:.0 alpha:.3].CGColor];
    [layer setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:.3].CGColor];
    [layer setBorderWidth:1.0f];
    layer = [[self LocationButton]layer];
    [layer setCornerRadius:16.0f];
    [layer setBorderColor:[UIColor colorWithRed:.0 green:.0 blue:.0 alpha:.3].CGColor];
    [layer setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:.3].CGColor];
    [layer setBorderWidth:1.0f];
    

    
    layer = [[self BottomToolbar]layer];
    
    CAGradientLayer *toolbarGradientLayer = [[CAGradientLayer alloc]init];
    [toolbarGradientLayer setBounds:[layer bounds]];
    [toolbarGradientLayer setPosition:CGPointMake([layer bounds].size.width/2,
                                                  [layer bounds].size.height/2)];
    [toolbarGradientLayer setColors:[NSArray arrayWithObjects:
                                     (id)[UIColor colorWithRed:56/255. green:64/255. blue:68/255. alpha:1].CGColor,
                                     (id)[UIColor colorWithRed:25/255. green:29/255. blue:31/255. alpha:1].CGColor,nil]];
    
    [layer insertSublayer:toolbarGradientLayer atIndex:0];
    CALayer *topBorderLayer = [[CALayer alloc]init];
    [topBorderLayer setFrame:CGRectMake(0, 0, 320, 2)];
    [topBorderLayer setBackgroundColor:[UIColor colorWithRed:67/255. green:74/255. blue:78/255. alpha:1].CGColor];
    [topBorderLayer setBorderWidth:0];
    [layer addSublayer:topBorderLayer];
    [topBorderLayer release];
    [toolbarGradientLayer release];
    
}
- (IBAction)GoToSettings:(id)sender {
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self performSegueWithIdentifier:@"GoToSettings" sender:self];
}

- (IBAction)GoToImagePicker:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    [picker setMediaTypes:[[[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil]autorelease]];
    [picker setAllowsEditing:NO];
    [picker setDelegate:self];
    [self presentModalViewController:picker
                            animated:YES];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    [picker dismissModalViewControllerAnimated:NO];
    [self savePictureData:UIImageJPEGRepresentation(image, 1)];
    
    
}
-(void)savePictureData:(NSData *)jpegRepresentation
{
    

    
    [TestFlight passCheckpoint:@"Took a photo"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        USTAppDelegate *appDelegate = (USTAppDelegate*)[[UIApplication sharedApplication]delegate];
        Event *currentEvent = [[appDelegate locationHandler] currentEvent];        
        NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
        Picture *picture = (Picture*) [NSEntityDescription insertNewObjectForEntityForName:@"Picture" inManagedObjectContext:managedObjectContext]; 
        [picture setEvent:currentEvent];
        [picture setDateTaken:[NSDate date]];
        [picture setImage:jpegRepresentation];

        
            NSError *saveError = nil;
            [managedObjectContext save:&saveError];
        if(saveError){
            NSLog(@"Save Error %@",[saveError description]);
        }
        [saveError release];
        if([[currentEvent eventKey]compare:VoidEventKey]!=NSOrderedSame){
            [[appDelegate fileUploadHandler]addPictureToUploadQueue:picture];
        
            
            
            }
    });
    [self GoToTimeline:self];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // test if our control subview is on-screen
    if ([self CameraSwapButton].superview != nil) {
        if ([touch.view isDescendantOfView:[self CameraSwapButton]]) {
            // we touched our control surface
            return NO; // ignore the touch
        }
    }
    if ([self LocationButton].superview != nil) {
        if ([touch.view isDescendantOfView:[self LocationButton]]) {
            // we touched our control surface
            return NO; // ignore the touch
        }
    }

    return YES; // handle the touch
}
-(void) autoFocusOnTap:(UIGestureRecognizer *)sender{
   


    AVCaptureDevice *currentDevice = nil;
    if ([self cameraCount] > 1) {
        
        AVCaptureDevicePosition position = [[[self currentDeviceInput] device] position];
 
        if (position == AVCaptureDevicePositionBack){
            currentDevice = [self rearCamera];
        }
        else if (position == AVCaptureDevicePositionFront){
            currentDevice = [self frontCamera];            
        }
   
    }
    else{
        currentDevice = [self rearCamera];
    }

    if ([currentDevice isFocusPointOfInterestSupported]) {
        CGPoint tapPoint = [sender locationInView:[self CameraPreviewView]];
        [self showFocusOverlayAtPoint:tapPoint];
        CGPoint convertedFocusPoint = [self convertToPointOfInterestFromViewCoordinates:tapPoint];
        [self autoFocusDevice:currentDevice AtPoint:convertedFocusPoint];
    }
}
-(void) showFocusOverlayAtPoint:(CGPoint) point{

    UIView *focusOverlayView = [[UIView alloc]initWithFrame:CGRectMake(point.x-30, point.y-30, 60, 60)];
        [[focusOverlayView layer] setBorderWidth:1];
    [[focusOverlayView layer] setBorderColor:[UIColor whiteColor].CGColor];
    [focusOverlayView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
    [[self CameraPreviewView]addSubview:focusOverlayView];
    [UIView animateWithDuration:0.3 animations:^{
        [focusOverlayView setFrame:CGRectMake(point.x-10, point.y-10, 40, 40)];   
        [focusOverlayView setAlpha:0];
        [focusOverlayView setAlpha:1];
    } completion:^(BOOL finished) {
        [focusOverlayView removeFromSuperview];
        [focusOverlayView release];
    }];
}
-(CGPoint) convertToPointOfInterestFromViewCoordinates:(CGPoint) pointInView{
    CGSize size= [[self CameraPreviewView] frame].size;
    CGPoint convertedPoint = CGPointMake(1.f-(size.width/pointInView.x), 
                                         1.f-(size.height/pointInView.y));
    return convertedPoint;
}
-(void)autoFocusDevice: (AVCaptureDevice*) device AtPoint:(CGPoint)focusPoint{
    NSError *lockError;
    if([device lockForConfiguration:&lockError ])
    {
        [device setFocusMode:AVCaptureFocusModeAutoFocus];
        [device setFocusPointOfInterest:focusPoint];
        [device unlockForConfiguration];
        
    }
}
@end
