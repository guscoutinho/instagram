//
//  DetailsViewController.h
//  instagramClone
//
//  Created by Gustavo Coutinho on 7/10/18.
//  Copyright © 2018 Gustavo Coutinho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "Parse.h"
#import "ParseUI.h"

@interface DetailsViewController : UIViewController

@property (strong, nonatomic) Post *post;


@end
