//
//  ConnectionManager.h
//  RSSViewer
//
//  Created by Сергей Пугач on 25.02.17.
//
//

#import <Foundation/Foundation.h>

@class RSSParser, RSSItem;

typedef enum FeedsStyle {
    FeedsStyleLive,
    FeedsStyleAnalytics
}FeedsStyle;

typedef void(^CompletionBlock)(NSError *error, id responseObject);
typedef void(^FeedsCompletionBlock)(NSError *error, NSArray<RSSItem *> *feeds);


@interface ConnectionManager : NSObject

@property(strong, nonatomic, readwrite) NSString *liveNewsUrl;
@property(strong, nonatomic, readwrite) NSString *analyticsUrl;

+ (instancetype)sharedInstance;

- (void)getFeedsWithStyle:(FeedsStyle)feedStyle andCompletion:(FeedsCompletionBlock)completion;

- (void)getImageWithPath:(NSString*)path andCompletion:(CompletionBlock)completion;


- (NSString *)convertFeedStyleToString:(FeedsStyle)style;

@end
