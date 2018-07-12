//
//  Infinite.h
//  instagramClone
//
//  Created by Gustavo Coutinho on 7/11/18.
//  Copyright © 2018 Gustavo Coutinho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Infinite : UIActivityIndicatorView

@property (class, nonatomic, readonly) CGFloat defaultHeight;

- (void)startAnimating;
- (void)stopAnimating;

@end
