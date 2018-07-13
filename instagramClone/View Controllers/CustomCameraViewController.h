//
//  CustomCameraViewController.h
//  instagramClone
//
//  Created by Gustavo Coutinho on 7/13/18.
//  Copyright © 2018 Gustavo Coutinho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CustomCameraViewController : UIViewController <AVCapturePhotoCaptureDelegate>

@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCapturePhotoOutput *stillImageOutput;
@property (nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UIImageView *captureImageView;
- (IBAction)didTakePhoto:(id)sender;

@end
