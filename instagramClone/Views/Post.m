//
//  Post.m
//  instagramClone
//
//  Created by Gustavo Coutinho on 7/10/18.
//  Copyright © 2018 Gustavo Coutinho. All rights reserved.
//

#import "Post.h"
#import "DateTools.h"


@implementation Post

@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic caption;
@dynamic image;
@dynamic likeCount;
@dynamic likedBy;
@dynamic commentCount;
@dynamic createdAt;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    newPost.likeCount = @(0);
    newPost.likedBy = [[NSMutableArray alloc] init];
    newPost.commentCount = @(0);
    
    [newPost saveInBackgroundWithBlock: completion];
}

+ (PFFile *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFile fileWithName:@"image.png" data:imageData];
}


- (NSString *) creatingTimestamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    
    NSString *createdAtString = @"";
    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:self.createdAt];
    if (secondsBetween <= 3600 * 12) {
        createdAtString = self.createdAt.timeAgoSinceNow;
    }
    else {
        // Configure output format
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        // Convert Date to String
        createdAtString = [formatter stringFromDate:self.createdAt];
    }
    return createdAtString;
}

- (BOOL) likedByCurrent {
    return [self.likedBy containsObject:PFUser.currentUser.objectId];
}

@end
