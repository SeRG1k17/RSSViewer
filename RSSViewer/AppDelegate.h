//
//  AppDelegate.h
//  RSSViewer
//
//  Created by Сергей Пугач on 24.02.17.
//
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(strong, nonatomic) NSDate *lastUpdate;

+ (AppDelegate *)appDelegate;

@end

