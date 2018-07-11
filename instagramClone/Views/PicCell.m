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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(Post *)post {
    _post = post;
    
    self.likesLabel.text = [NSString stringWithFormat:@"%@ Likes", post.likeCount];
    self.username.text = post.author.username;
    
    
//    self.picDescription.text = [NSString stringWithFormat:@"%@ %@", post.author.username, post.caption];

    self.picDescription.text = post.caption;
    
    self.picImage.file = post.image;
    [self.picImage loadInBackground];
}


@end
