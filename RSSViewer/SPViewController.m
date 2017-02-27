//
//  SPViewController.m
//  RSSViewer
//
//  Created by Сергей Пугач on 25.02.17.
//
//

#import "SPViewController.h"

//Libs
#import<SVPullToRefresh/SVPullToRefresh.h>

//Models
#import "RSSItem.h"
#import "DetailViewController.h"
#import "FeedTableViewCell.h"

@interface SPViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSString *storyboardIdentifier;
    NSString *cellIdentifier;
    
    NSInteger currentPage;
    NSUserDefaults *sharedDefaults;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPViewController
@synthesize dataSource, feedStyle;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.SergeyPugach.RSSViewer"];
    
    currentPage = 0;
    dataSource = [NSMutableArray array];
    
    storyboardIdentifier = NSStringFromClass([DetailViewController class]);
    cellIdentifier = NSStringFromClass([FeedTableViewCell class]);
    
    [self getFeeds];
    [self loadFeeds];
    
    [self setUpPullToRefresh];
    [self setUpInfinityScroll];
    
    [_tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = true;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = false;
}

#pragma mark: - Methods
- (void)loadFeeds {
    
    __weak SPViewController *weakSelf = self;
    
    [[DataManager sharedInstance] loadFeedsWithStyle:feedStyle andCompletion:^(NSArray<RSSItem *> *items) {
        if (items.count) {
            
            [weakSelf.dataSource addObjectsFromArray:items];
            [weakSelf.tableView reloadData];
            
            [weakSelf sharingDateToExtension];
        }
    }];
    

}

- (void)getFeeds {
    
    __weak SPViewController *weakSelf = self;
    
    [[DataManager sharedInstance] getFeedsFromStoreWithStyle:feedStyle withPage:currentPage andCompletion:^(NSArray<RSSItem *> *items) {
        if (items.count) {
            
            [weakSelf.dataSource addObjectsFromArray:items];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)setUpPullToRefresh {
    
    __weak SPViewController *weakSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowsAtTop];
    }];
}

- (void)setUpInfinityScroll {
    
    __weak SPViewController *weakSelf = self;
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowsAtBottom];
    }];
}

- (void)insertRowsAtTop {
    
    __weak SPViewController *weakSelf = self;
    
    [[DataManager sharedInstance] loadFeedsWithStyle:feedStyle andCompletion:^(NSArray<RSSItem *> *items) {
        
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            if (items.count) {
                NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, items.count)];
                
                NSMutableArray<NSIndexPath *> *indexPathes = [NSMutableArray array];
                for (int i = 0; i < items.count; i++) {
                    [indexPathes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
                
                [weakSelf.tableView beginUpdates];
                
                [weakSelf.dataSource insertObjects:items atIndexes:indexes];
                [weakSelf.tableView insertRowsAtIndexPaths:indexPathes withRowAnimation:UITableViewRowAnimationBottom];
                
                [weakSelf.tableView endUpdates];
            }
            
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            
            [weakSelf sharingDateToExtension];
        });
    }];
}


- (void)insertRowsAtBottom {
    
    __weak SPViewController *weakSelf = self;
    
    [[DataManager sharedInstance] getFeedsFromStoreWithStyle:feedStyle withPage:++currentPage andCompletion:^(NSArray<RSSItem *> *items) {
        
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            if (items.count) {
                
                NSMutableArray<NSIndexPath *> *indexPathes = [NSMutableArray array];
                for (int i = 0; i < items.count; i++) {
                    [indexPathes addObject:[NSIndexPath indexPathForRow:weakSelf.dataSource.count-1+i inSection:0]];
                }
                
                [weakSelf.tableView beginUpdates];
                
                [weakSelf.dataSource addObjectsFromArray:items];
                [weakSelf.tableView insertRowsAtIndexPaths:indexPathes withRowAnimation:UITableViewRowAnimationTop];
                
                [weakSelf.tableView endUpdates];
            }
            
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        });
    }];
    
}

- (void)sharingDateToExtension {
    [sharedDefaults setObject:[NSDate date] forKey:@"RSSViewerLastUpdate"];
    [sharedDefaults synchronize];
}

#pragma mark: - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (dataSource.count) {
        return [dataSource count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RSSItem *item = [dataSource objectAtIndex:indexPath.row];
    
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[FeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.titleLabel.text = [item title];
    cell.dateLabel.text = [item stringFromDate];
    
    if ([[item imagesFromItemDescription] count] > 0) {
        cell.imageViewWidthConstraint.constant = 68;
        
        [[ConnectionManager sharedInstance] getImageWithPath:[item.imagesFromItemDescription objectAtIndex:0] andCompletion:^(NSError *error, id responseObject) {
            if (responseObject) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.feedImageView.image = responseObject;
                    
                    [cell setNeedsLayout];
                });
                
            }
        }];
    } else {
        cell.imageViewWidthConstraint.constant = 0;
        [cell layoutIfNeeded];
    }
    
    return cell;
}

#pragma mark: - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_tableView deselectRowAtIndexPath:indexPath animated:true];
    
    DetailViewController *detailVC = [[UIStoryboard storyboardWithName:storyboardIdentifier bundle:nil] instantiateViewControllerWithIdentifier:storyboardIdentifier];
    
    [detailVC setItem:[dataSource objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
