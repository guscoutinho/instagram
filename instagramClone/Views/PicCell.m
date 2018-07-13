//
//  PicCell.m
//  instagramClone
//
//  Created by Gustavo Coutinho on 7/9/18.
//  Copyright © 2018 Gustavo Coutinho. All rights reserved.
//

#import "PicCell.h"

@implementation PicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapUserPicture)];
    [self.profiletView addGestureRecognizer:singleFingerTap];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(Post *)post {
    _post = post;
    
    User *user = [User currentUser];
    
    self.likesLabel.text = [NSString stringWithFormat:@"%@ Likes", post.likeCount];
    
    // bold username + description at same label
    NSString *strTextView = [NSString stringWithFormat:@"%@ %@", post.author.username, post.caption];
    NSString *bold =[NSString stringWithFormat:@"%@", post.author.username];
    NSRange rangeBold = [strTextView rangeOfString:bold];
    UIFont *fontText = [UIFont boldSystemFontOfSize:13];
    NSDictionary *dictBoldText = [NSDictionary dictionaryWithObjectsAndKeys:fontText, NSFontAttributeName, nil];
    NSMutableAttributedString *mutAttrTextViewString = [[NSMutableAttributedString alloc] initWithString:strTextView];
    [mutAttrTextViewString setAttributes:dictBoldText range:rangeBold];
    [self.picDescription setAttributedText:mutAttrTextViewString];
//    
//    if (self.post.author.profilePic == nil) {
//
//    }
//    else {
//
//    }
    
    self.username.text = post.author.username;
    self.picImage.file = post.image;
    [self.picImage loadInBackground];

    self.profileImage.file = post.author.profilePic;
    [self.profileImage loadInBackground];

    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
    
    self.timestamp.text = [self.post creatingTimestamp];
    self.likesLabel.text = [NSString stringWithFormat:@"%@ Likes", post.likeCount];
    self.favoriteButton.selected = [post likedByCurrent];
    
    if ([self.post likedByCurrent]) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
    }
    else {
        [self.favoriteButton setImage:[UIImage imageNamed:@"fav"] forState:UIControlStateNormal];
    }
}

- (void) refreshView {
    self.favoriteButton.selected = [self.post likedByCurrent];
    self.likesLabel.text = [NSString stringWithFormat:@"%@ Likes", self.post.likeCount];
}

- (void) didTapUserPicture {
    [self.delegate showProfileScreen:self.post.author];
}

- (void) toggleFavorite {
    PFQuery *postQuery = [Post query];
    [postQuery includeKey:@"author"];
    
    // fetch data asynchronously
    [postQuery getObjectInBackgroundWithId:self.post.objectId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object) {
            Post *post = (Post *)object;
            if ([post likedByCurrent]) {
                [post incrementKey:@"likeCount" byAmount:@(-1)];
                [post removeObject:(User *)PFUser.currentUser.objectId forKey:@"likedBy"];
                [self.favoriteButton setImage:[UIImage imageNamed:@"fav"] forState:UIControlStateNormal];
            }
            else {
                [post incrementKey:@"likeCount" byAmount:@(1)];
                [post addObject:(User *)PFUser.currentUser.objectId forKey:@"likedBy"];
                [self.favoriteButton setImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
            }
            [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    self.post = post;
                    [self refreshView];
                }
            }];
        }
    }];
}

- (IBAction)didTapFavorite:(id)sender {
    [self toggleFavorite];
}

@end
