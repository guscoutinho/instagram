//
//  PicCell.m
//  instagramClone
//
//  Created by Gustavo Coutinho on 7/9/18.
//  Copyright © 2018 Gustavo Coutinho. All rights reserved.
//

#import "PicCell.h"
#import "DateTools.h"

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
    
    // bold username + description at same label
    NSString *strTextView = [NSString stringWithFormat:@"%@ %@", post.author.username, post.caption];
    NSString *bold =[NSString stringWithFormat:@"%@", post.author.username];
    
    NSRange rangeBold = [strTextView rangeOfString:bold];
    
    UIFont *fontText = [UIFont boldSystemFontOfSize:13];
    NSDictionary *dictBoldText = [NSDictionary dictionaryWithObjectsAndKeys:fontText, NSFontAttributeName, nil];
    
    NSMutableAttributedString *mutAttrTextViewString = [[NSMutableAttributedString alloc] initWithString:strTextView];
    [mutAttrTextViewString setAttributes:dictBoldText range:rangeBold];
    
    [self.picDescription setAttributedText:mutAttrTextViewString];
    
    self.picImage.file = post.image;
    [self.picImage loadInBackground];
    
    self.timestamp.text = [self.post creatingTimestamp];
    


}




@end
