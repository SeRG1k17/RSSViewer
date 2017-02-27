//
//  StoreManager.h
//  RSSViewer
//
//  Created by Сергей Пугач on 26.02.17.
//
//

#import <Foundation/Foundation.h>

@class RSSItem;

typedef void(^ItemsCompletionBlock)(NSArray<RSSItem *> *items);
typedef void(^SavingCompletionBlock)(NSError *error, BOOL contextDidSave);

@interface StoreManager : NSObject

+ (instancetype)sharedInstance;

- (void)saveRSSItems:(NSArray<RSSItem *> *)feedItems withAttribute:(NSString *)attribute withCompletion:(SavingCompletionBlock)completion;
- (void)getRSSItemsForAttribute:(NSString *)attribute withPage:(NSInteger)page andCompletion:(ItemsCompletionBlock)completion;

@end
