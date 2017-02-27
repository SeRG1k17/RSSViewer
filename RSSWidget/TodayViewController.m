//
//  TodayViewController.m
//  RSSWidget
//
//  Created by Сергей Пугач on 25.02.17.
//
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
//#import "ConnectionManager.h"
//#import "AppDelegate.h"

//NSString* const RSSViewerFeedsWasUpdated = @"RSSViewerFeedsWasUpdated";

@interface TodayViewController () <NCWidgetProviding>
{
    NSDateFormatter *dateFormatter;
}

@property (weak, nonatomic) IBOutlet UILabel *lastFeedLabel;

@end

@implementation TodayViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDefaultsDidChange:)
                                                     name:NSUserDefaultsDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.layer.cornerRadius = 10.0;
    self.view.layer.borderColor = [UIColor orangeColor].CGColor;
    self.view.layer.borderWidth = 1.5;
    self.view.clipsToBounds = true;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    [self updateDateLabelText];
    //AppDelegate* sharedDelegate = [AppDelegate appDelegate];
    
    //self.lastFeedLabel.text = [date stringFromDate: sharedDelegate.lastUpdate];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedsWasUpdated) name:RSSViewerFeedsWasUpdated object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (void)userDefaultsDidChange:(NSNotification *)notification {
    [self updateDateLabelText];
}

- (void)updateDateLabelText {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.SergeyPugach.RSSViewer"];
    
    NSDate *date = (NSDate *)[defaults objectForKey:@"RSSViewerLastUpdate"];
    if (date) {
        self.lastFeedLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
    }
}

- (IBAction)openApp:(UIButton *)sender {
    
    NSURL *url = [NSURL URLWithString:@"RSSViewer://"];
    if (url) {
        [self.extensionContext openURL:url completionHandler:nil];
    }
}

//#pragma mark: - ConnectionManagerDelegate
//- (void)feedsWasUpdated {
//    
//    NSString *dateString = [date stringFromDate:[NSDate date]];
//    self.lastFeedLabel.text = dateString;
//}



@end
