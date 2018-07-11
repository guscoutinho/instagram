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

@interface PicCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *picDescription;
@property (weak, nonatomic) IBOutlet PFImageView *picImage;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *username;

@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@property (strong, nonatomic) Post *post;


@end
