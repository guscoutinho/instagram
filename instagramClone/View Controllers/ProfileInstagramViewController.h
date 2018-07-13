//
//  ProfileInstagramViewController.h
//  instagramClone
//
//  Created by Gustavo Coutinho on 7/11/18.
//  Copyright © 2018 Gustavo Coutinho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"
#import "Post.h"

@interface ProfileInstagramViewController : UIViewController

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) Post *post;



@end
