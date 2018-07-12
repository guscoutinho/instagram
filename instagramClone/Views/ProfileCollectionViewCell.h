//
//  ProfileCollectionViewCell.h
//  instagramClone
//
//  Created by Gustavo Coutinho on 7/11/18.
//  Copyright © 2018 Gustavo Coutinho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"
#import "Post.h"

@interface ProfileCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PFImageView *profileImages;
@property (strong, nonatomic) Post *post;

@end
