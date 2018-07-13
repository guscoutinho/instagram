//
//  ProfileCollectionViewCell.m
//  instagramClone
//
//  Created by Gustavo Coutinho on 7/11/18.
//  Copyright © 2018 Gustavo Coutinho. All rights reserved.
//

#import "ProfileCollectionViewCell.h"
#import "User.h"

@implementation ProfileCollectionViewCell

- (void)setPost:(Post *)post {
    _post = post;
    
    User *user = [User currentUser];
    
    self.profileImages.file = post.image;
    [self.profileImages loadInBackground];
}
@end


