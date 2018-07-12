//
//  ProfileInstagramViewController.m
//  instagramClone
//
//  Created by Gustavo Coutinho on 7/11/18.
//  Copyright © 2018 Gustavo Coutinho. All rights reserved.
//


#import "ParseUI.h"
#import "Post.h"
#import "ProfileInstagramViewController.h"
#import "ProfileCollectionViewCell.h"
#import "DetailsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ProfileInstagramViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *profileUser;
@property (weak, nonatomic) IBOutlet UILabel *profileDescription;
@property (weak, nonatomic) IBOutlet UILabel *profilePostsCount;
@property (weak, nonatomic) IBOutlet UILabel *profileFollowersCount;
@property (weak, nonatomic) IBOutlet UILabel *profileFollowingCount;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (weak, nonatomic) IBOutlet UIView *viewForButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

// collection view
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

// button actions
- (IBAction)didTapEditProfile:(id)sender;
- (IBAction)didTapSettings:(id)sender;

// array
@property (strong, nonatomic) NSMutableArray *allPosts;

@end

@implementation ProfileInstagramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;    
    self.allPosts = [[NSMutableArray alloc] init];
    
    [self getUserInformation];
    [self fetchPosts];
    [self cellConfig];
}

- (void) viewDidAppear:(BOOL)animated {
    [self fetchPosts];

}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfileCollectionViewCell" forIndexPath:indexPath];
    cell.post = self.allPosts[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allPosts.count;
}
    
- (void) getUserInformation {
    if (!self.user) {
        self.user = PFUser.currentUser;
    }
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
    self.profileUser.text = self.user.username;
    self.viewForButton.layer.cornerRadius = self.editProfileButton.frame.size.height/2;
    [self.viewForButton.layer setBorderWidth:1.0];
    [self.viewForButton.layer setBorderColor: [[UIColor grayColor] CGColor]];

//    self.profileDescription.text = self.user.description;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) cellConfig {
    // Layout; cast to the right type/layout
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat picsPerLine = 3;
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (picsPerLine - 1)) / picsPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void) fetchPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query whereKey:@"author" equalTo:self.user];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            [self.allPosts removeAllObjects];
            // do something with the array of object returned by the call
            for (PFObject *post in posts) {
                [self.allPosts addObject:post];
            }
            self.profilePostsCount.text = [NSString stringWithFormat:@"%d", self.allPosts.count];
            [self.collectionView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"detailsController"]) {
        UITableView *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        Post *post = self.allPosts[indexPath.row];

        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    }
}

- (IBAction)didTapEditProfile:(id)sender {
}

- (IBAction)didTapSettings:(id)sender {
}

@end
