//
//  User.h
//  instagramClone
//
//  Created by Gustavo Coutinho on 7/12/18.
//  Copyright © 2018 Gustavo Coutinho. All rights reserved.
//

#import "PFUser.h"
#import "Parse.h"

@interface User : PFUser

@property (strong, nonatomic) PFFile *profilePic;

@end
