//
//  CameraViewController.m
//  instagramClone
//
//  Created by Gustavo Coutinho on 7/9/18.
//  Copyright © 2018 Gustavo Coutinho. All rights reserved.
//

#import "CameraViewController.h"
#import "MBProgressHUD.h"

@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UITextView *postCaption;
@property (weak, nonatomic) IBOutlet UILabel *postCaptionLabel;

- (IBAction)didTapCameraRoll:(id)sender;
- (IBAction)didTapImage:(id)sender;
- (IBAction)didTapCancel:(id)sender;
- (IBAction)didTapShare:(id)sender;
- (IBAction)didTapCustomCamera:(id)sender;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.postCaption.delegate = self;
    self.postCaptionLabel.alpha = 0;
    [self getPhotoLibrary];
    
//    self.postImage.image = [UIImage imageNamed:@"image_placeholder"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void) viewDidAppear:(BOOL)animated {
    if ([self imageEquality:self.postImage.image isEqualTo:[UIImage imageNamed:@"image_placeholder"]]) {
        [self getPhotoLibrary];
    }

}

- (BOOL)imageEquality:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}

-(void)dismissKeyboard
{
    [self.postCaption resignFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.postCaptionLabel.alpha = 0;
}

- (void) getCamera {
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
}

- (void) getPhotoLibrary {
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];

    self.postCaptionLabel.alpha = 1;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    CGSize size = CGSizeMake(400, 400);
    self.postImage.image = [self resizeImage:editedImage withSize:size];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didTapCameraRoll:(id)sender {
    [self getPhotoLibrary];
    
}

- (IBAction)didTapImage:(id)sender {
    [self getCamera];
}

- (IBAction)didTapCancel:(id)sender {
    [self performSegueWithIdentifier:@"cancelSegue" sender:nil];
    [self.parentViewController.tabBarController setSelectedIndex:0];
    self.postImage.image = [UIImage imageNamed:@"image_placeholder"];
    
}

- (IBAction)didTapShare:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (![self.postImage.image isEqual:[UIImage imageNamed:@"image_placeholder"]]) {
        [Post postUserImage:self.postImage.image withCaption:self.postCaption.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSLog(@"imaged posted");
                self.postImage.image = [UIImage imageNamed:@"image_placeholder"];
                self.postCaption.text = @"";
//                [self dismissViewControllerAnimated:YES completion:nil];
                [self.parentViewController.tabBarController setSelectedIndex:0];                
            } else {
                NSLog(@"imaged not posted");
            }
        }];
    }
}

- (IBAction)didTapCustomCamera:(id)sender {
    [self performSegueWithIdentifier:@"customSegue" sender:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
