//
//  Post.h
//  instagramClone
//
//  Created by Gustavo Coutinho on 7/10/18.
//  Copyright © 2018 Gustavo Coutinho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "User.h"

@interface Post : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) User *author;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) PFFile *image;
@property (nonatomic, strong) NSMutableArray *likedBy;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSNumber *commentCount;

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion;

- (NSString *) creatingTimestamp;
- (BOOL) likedByCurrent;

+ (PFFile *)getPFFileFromImage: (UIImage * _Nullable)image;

    
@end
