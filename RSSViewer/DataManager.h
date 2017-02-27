//
//  DataManager.h
//  RSSViewer
//
//  Created by Сергей Пугач on 25.02.17.
//
//

#import <Foundation/Foundation.h>
#import "ConnectionManager.h"

@class RSSItem;

typedef void(^ItemsCompletionBlock)(NSArray<RSSItem *> *items);

@interface DataManager : NSObject

+ (instancetype)sharedInstance;

- (void)loadFeedsWithStyle:(FeedsStyle)feedStyle andCompletion:(ItemsCompletionBlock)completion;
- (void)getFeedsFromStoreWithStyle:(FeedsStyle)feedStyle withPage:(NSInteger)page andCompletion:(ItemsCompletionBlock)completion;

@end
