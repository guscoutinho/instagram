//
//  AddProfilePictureViewController.m
//  instagramClone
//
//  Created by Gustavo Coutinho on 7/12/18.
//  Copyright © 2018 Gustavo Coutinho. All rights reserved.
//

#import "AddProfilePictureViewController.h"

@interface AddProfilePictureViewController ()  <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *profileDescription;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property UIImage * selectedImage;


- (IBAction)didTapProfileButton:(id)sender;

@end

@implementation AddProfilePictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.allowsEditing = YES;
    // Check if image access is authorized
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // Use delegate methods to get result of photo library -- Look up UIImagePicker delegate methods
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:true completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"will appear");
    self.profileImage.image = self.selectedImage;
}

-(void)dismissKeyboard
{
    [self.profileDescription resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    CGSize size = CGSizeMake(100, 100);
    UIImage *resizeImage = [self resizeImage:editedImage withSize:size];
    PFFile *dbImage = [Post getPFFileFromImage:resizeImage];
    
    
    [self dismissViewControllerAnimated:YES completion: ^{
        self.profileImage.image = resizeImage;
    }];
    
    self.user = (User *)[User currentUser];
    
    self.user.profilePic = dbImage;
    
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"profile pic in db");
            
        }
        else {
            NSLog(@"profile pic NOT SAVED in db");
        }
    }];
    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)didTapProfileButton:(id)sender {
    [self.parentViewController.tabBarController setSelectedIndex:0];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
