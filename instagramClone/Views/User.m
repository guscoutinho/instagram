//
//  User.m
//  instagramClone
//
//  Created by Gustavo Coutinho on 7/12/18.
//  Copyright © 2018 Gustavo Coutinho. All rights reserved.
//

#import "User.h"

@implementation User

@dynamic profilePic;

@end




//+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
//    
//    Post *newPost = [Post new];
//    newPost.image = [self getPFFileFromImage:image];
//    newPost.author = [PFUser currentUser];
//    newPost.caption = caption;
//    newPost.likeCount = @(0);
//    newPost.likedBy = [[NSMutableArray alloc] init];
//    newPost.commentCount = @(0);
//    
//    [newPost saveInBackgroundWithBlock: completion];
//}
