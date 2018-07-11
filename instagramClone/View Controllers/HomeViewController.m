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

@interface HomeViewController () <UITableViewDataSource, UITabBarDelegate>

@property (strong, nonatomic) NSMutableArray *timelinePosts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;


- (IBAction)didTapLogout:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.timelinePosts = [[NSMutableArray alloc] init];
    
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

            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    PicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PicCell" forIndexPath:indexPath];
    
    cell.post = self.timelinePosts[indexPath.row];
    
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timelinePosts.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselect the row which was tapped
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

 #pragma mark - Navigation
 
    //  In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
    //  Get the new view controller using [segue destinationViewController].
    //  Pass the selected object to the new view controller.
     
     if ([segue.identifier  isEqual: @"detailsController"]) {
         
         UITableView *tappedCell = sender;
         
         NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
         Post *post = self.timelinePosts[indexPath.row];
         
         DetailsViewController *detailsViewController = [segue destinationViewController];
         
         detailsViewController.post = post;
         
     }
 }

@end
