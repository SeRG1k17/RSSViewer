//
//  DetailViewController.m
//  RSSViewer
//
//  Created by Сергей Пугач on 25.02.17.
//
//

#import "DetailViewController.h"
#import "RSSItem.h"

@interface DetailViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;

@end

@implementation DetailViewController
@synthesize item;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{
       NSFontAttributeName: [UIFont boldSystemFontOfSize:12.0],
       NSForegroundColorAttributeName: [UIColor whiteColor]
    }];
    
    [self setTitle:item.title];
    [_detailWebView loadHTMLString:item.itemDescription baseURL:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark: - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}


@end
