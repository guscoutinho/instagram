//
//  PicCell.h
//  instagramClone
//
//  Created by Gustavo Coutinho on 7/9/18.
//  Copyright © 2018 Gustavo Coutinho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "ParseUI.h"
#import "DateTools.h"

@protocol PicCellDelegate

- (void) showProfileScreen: (PFUser *) user;

@end

@interface PicCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *picDescription;
@property (weak, nonatomic) IBOutlet PFImageView *picImage;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *userPicture;
@property (weak, nonatomic) IBOutlet UIView *profiletView;

@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UILabel *timestamp;

@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) id<PicCellDelegate> delegate;

- (IBAction)didTapFavorite:(id)sender;

@end
