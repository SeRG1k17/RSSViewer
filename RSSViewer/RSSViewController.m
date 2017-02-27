//
//  RSSViewController.m
//  RSSViewer
//
//  Created by Сергей Пугач on 25.02.17.
//
//

#import "RSSViewController.h"
#import "CAPSPageMenu.h"

#import "SPViewController.h"
#import "ConnectionManager.h"
#import "DataManager.h"

@interface RSSViewController ()

@property (nonatomic) CAPSPageMenu *pageMenu;

@end

@implementation RSSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigationBarSettings];
    [self setUpPageMenu];

}

#pragma mark: - UI
- (void)setUpNavigationBarSettings {
    
    self.title = @"RSS Viewer";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor orangeColor]};
}

- (void)setUpPageMenu {
    NSString *storyboardIdentifier = NSStringFromClass([SPViewController class]);
    
    //Live
    SPViewController *liveController = [[UIStoryboard storyboardWithName:storyboardIdentifier bundle:nil] instantiateViewControllerWithIdentifier:storyboardIdentifier];
    liveController.title = @"Live news";
    liveController.feedStyle = FeedsStyleLive;
    
    UINavigationController *liveNav = [[UINavigationController alloc] initWithRootViewController:liveController];
    
    
    //Analytics
    SPViewController *analyticsController = [[UIStoryboard storyboardWithName:storyboardIdentifier bundle:nil] instantiateViewControllerWithIdentifier:storyboardIdentifier];
    analyticsController.title = @"Analytics";
    analyticsController.feedStyle = FeedsStyleAnalytics;
    
    UINavigationController *analyticsNav = [[UINavigationController alloc] initWithRootViewController:analyticsController];
    
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor orangeColor],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0],
                                 //CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue" size:13.0],
                                 //CAPSPageMenuOptionMenuHeight: @(40.0),
                                 //CAPSPageMenuOptionMenuItemWidth: @(90.0),
                                 //CAPSPageMenuOptionCenterMenuItems: @(YES)
                                 
                                 CAPSPageMenuOptionUseMenuLikeSegmentedControl: @(YES),
                                 CAPSPageMenuOptionMenuItemSeparatorPercentageHeight: @(0.1),
                                 CAPSPageMenuOptionMenuItemSeparatorWidth: @(4.3)
                                 };
    
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:@[liveNav, analyticsNav]
                                                        frame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)
                                                      options:parameters];
    [self.view addSubview:_pageMenu.view];
}


@end
