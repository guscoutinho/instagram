//
//  CustomCameraViewController.m
//  instagramClone
//
//  Created by Gustavo Coutinho on 7/13/18.
//  Copyright © 2018 Gustavo Coutinho. All rights reserved.
//

#import "CustomCameraViewController.h"

@interface CustomCameraViewController ()

@end

@implementation CustomCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getCustomCamera];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.videoPreviewLayer.frame = self.previewView.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getCustomCamera {
    self.session = [AVCaptureSession new];
    self.session.sessionPreset = AVCaptureSessionPresetMedium;
    AVCaptureDevice *backCamera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera
                                                                        error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    // Continue from above
    else if (self.session && [self.session canAddInput:input]) {
        [self.session addInput:input];
        // The remainder of the session setup will go here...
    }
    self.stillImageOutput = [AVCapturePhotoOutput new];
    
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
        
        //Configure the Live Preiview here
        self.videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        if (self.videoPreviewLayer) {
            self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            self.videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
            [self.previewView.layer addSublayer:self.videoPreviewLayer];
            [self.session startRunning];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(nullable NSError *)error {
    
    NSData *imageData = photo.fileDataRepresentation;
    UIImage *image = [UIImage imageWithData:imageData];
    // Add the image to captureImageView here...
    
    
    self.captureImageView.image = image;
}

- (IBAction)didTakePhoto:(id)sender {
    AVCapturePhotoSettings *settings = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey: AVVideoCodecTypeJPEG}];
    //Capture Photo
    [self.stillImageOutput capturePhotoWithSettings:settings delegate:self];
}
@end
