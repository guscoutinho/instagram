//
//  HomeViewController.m
//  instagramClone
//
//  Created by Gustavo Coutinho on 7/9/18.
//  Copyright © 2018 Gustavo Coutinho. All rights reserved.
//

#import "HomeViewController.h"
#import "Parse.h"
#import "AppDelegate.h"
#import "Post.h"
#import "PicCell.h"
#import "DetailsViewController.h"
#import "Infinite.h"
#import "ProfileInstagramViewController.h"

@interface HomeViewController () <UITableViewDataSource, UITabBarDelegate, UIScrollViewDelegate, PicCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *timelinePosts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (strong, nonatomic) Infinite *loadingMoreView;

// button actions
- (IBAction)didTapLogout:(id)sender;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView reloadData];
    
    // infinite scroll
    [self performInfiniteScroll];
    
    // initialization of array
    self.timelinePosts = [[NSMutableArray alloc] init];
    
    // refresh control setup
    self.refreshControl = [[UIRefreshControl alloc] init];
    // Programagtic view of dragging and dropping in code
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    // Nests views into subviews
    [self.tableView insertSubview:self.refreshControl atIndex:0];

    [self fetchPosts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PicCell" forIndexPath:indexPath];
    cell.post = self.timelinePosts[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timelinePosts.count;
}

- (void) fetchPosts {
    // construct PFQuery
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            [self.timelinePosts removeAllObjects];
            // do something with the array of object returned by the call
            for (PFObject *post in posts) {
                [self.timelinePosts addObject:post];
            }
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (void)logoutUser {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
}

- (IBAction)didTapLogout:(id)sender {
    [self logoutUser];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *homeViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    appDelegate.window.rootViewController = homeViewController;
    
}

- (void) performInfiniteScroll {
    // Set up Infinite Scroll loading indicator
    CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, Infinite.defaultHeight);
    self.loadingMoreView = [[Infinite alloc] initWithFrame:frame];
    self.loadingMoreView.hidden = true;
    [self.tableView addSubview:self.loadingMoreView];

    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += Infinite.defaultHeight;
    self.tableView.contentInset = insets;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            
            // Code to load more results
            [self fetchMorePosts:@50];
        }
    }
}

- (void)fetchMorePosts:(NSNumber *) post_count {
    // construct PFQuery
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            [self.timelinePosts removeAllObjects];
            // do something with the array of object returned by the call
            for (PFObject *post in posts) {
                [self.timelinePosts addObject:post];
            }
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self.loadingMoreView stopAnimating];
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (void)showProfileScreen:(PFUser *)user {
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
    
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqualToString: @"detailsController"]) {
        PicCell *tappedCell = sender;
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = tappedCell.post;
    }
    if ([segue.identifier isEqualToString:@"profileSegue"]) {
        ProfileInstagramViewController *profileInstagramViewController;
        PFUser *user = sender;
        profileInstagramViewController.user = user;
    }
}

@end
