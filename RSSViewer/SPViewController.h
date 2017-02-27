//
//  SPViewController.h
//  RSSViewer
//
//  Created by Сергей Пугач on 25.02.17.
//
//

#import <UIKit/UIKit.h>

#import "DataManager.h"

@class RSSItem;

extern NSData *RSSViewerLastUpdate;

@interface SPViewController : UIViewController

@property (strong, nonatomic) NSMutableArray<RSSItem *> *dataSource;
@property (assign, nonatomic) FeedsStyle feedStyle;

@end
