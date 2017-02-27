//
//  DetailViewController.h
//  RSSViewer
//
//  Created by Сергей Пугач on 25.02.17.
//
//

#import <UIKit/UIKit.h>

@class RSSItem;
@interface DetailViewController : UIViewController

@property (assign,nonatomic) RSSItem *item;

@end
