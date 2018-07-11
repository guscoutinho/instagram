//
//  DetailsViewController.m
//  instagramClone
//
//  Created by Gustavo Coutinho on 7/10/18.
//  Copyright © 2018 Gustavo Coutinho. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *detailsUserImage;
@property (weak, nonatomic) IBOutlet UILabel *detailsUserName;
@property (weak, nonatomic) IBOutlet PFImageView *detailsPostPhoto;
@property (weak, nonatomic) IBOutlet UIButton *detailsFavoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *detailsLikesLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsUserNameBottom;
@property (weak, nonatomic) IBOutlet UILabel *detailsMessage;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.detailsUserName.text = self.post.author.username;
    self.detailsLikesLabel.text = [NSString stringWithFormat:@"%@ Likes", self.post.likeCount];
    self.detailsUserNameBottom.text = self.post.author.username;
    self.detailsMessage.text = self.post.caption;
    
    self.detailsPostPhoto.file = self.post.image;
//    self.detailsPostPhoto.layer.cornerRadius = self.detailsPostPhoto.frame.size.height/2;

    [self.detailsPostPhoto loadInBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
