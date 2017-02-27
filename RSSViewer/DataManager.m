//
//  DataManager.m
//  RSSViewer
//
//  Created by Сергей Пугач on 25.02.17.
//
//

#import "DataManager.h"
#import "StoreManager.h"
#import "RSSItem.h"

@interface DataManager ()
{
    StoreManager *storeManager;
    ConnectionManager *connectionManager;
    
    NSMutableDictionary *feedsDict;
}

@end

@implementation DataManager

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        storeManager = [StoreManager sharedInstance];
        connectionManager = [ConnectionManager sharedInstance];
        
        feedsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                     [NSNumber numberWithInt: FeedsStyleLive], [NSArray array],
                     [NSNumber numberWithInt: FeedsStyleAnalytics], [NSArray array],
                     nil];
    }
    return self;
}

- (void)loadFeedsWithStyle:(FeedsStyle)feedStyle andCompletion:(ItemsCompletionBlock)completion {
    
    [connectionManager getFeedsWithStyle:feedStyle andCompletion:^(NSError *error, NSArray<RSSItem *> *feeds) {
        if (!error) {
            
            if (feeds.count) {
                
                NSArray *oldFeeds = (NSArray *)[feedsDict objectForKey:[NSNumber numberWithInt:feedStyle]];
                NSArray *comparedArray = [NSArray array];
                
                if (oldFeeds.count) {
                    comparedArray = [self findNewFeedsFromOldArray:oldFeeds andNewArray:feeds];
                    
                    NSMutableArray *savingArray = [NSMutableArray arrayWithArray:oldFeeds];
                    [savingArray addObjectsFromArray:comparedArray];
                    
                    [feedsDict setObject:[self sortFeedsArrayByDate:savingArray]
                                  forKey:[NSNumber numberWithInt:feedStyle]];
                    
                } else {
                    comparedArray = feeds;
                    [feedsDict setObject:[self sortFeedsArrayByDate:comparedArray]
                                  forKey:[NSNumber numberWithInt:feedStyle]];
                }
                
                if (comparedArray.count) {
                    
                    NSArray *sortedArray = [self sortFeedsArrayByDate:comparedArray];
                    [self saveFeedsInStore:sortedArray withAttribute: [connectionManager convertFeedStyleToString:feedStyle]];
                    
                    completion(sortedArray);
                    
                } else {
                    
                    completion(nil);
                }
            } else {
               completion(nil);
            }
        } else {
            NSLog(@"%@",error.localizedDescription);
            completion(nil);
        }
    }];
}

- (void)getFeedsFromStoreWithStyle:(FeedsStyle)feedStyle withPage:(NSInteger)page andCompletion:(ItemsCompletionBlock)completion {
    
    [storeManager getRSSItemsForAttribute:[connectionManager convertFeedStyleToString:feedStyle] withPage:page andCompletion:^(NSArray<RSSItem *> *items) {
        if (items.count) {
            
            NSArray *sortedItems = [self sortFeedsArrayByDate:items];
            
            NSMutableArray *oldFeeds = [NSMutableArray arrayWithArray:(NSArray *)[feedsDict objectForKey:[NSNumber numberWithInt:feedStyle]]];
            
            if (oldFeeds.count) {
                [oldFeeds addObjectsFromArray:sortedItems];
            } else {
                oldFeeds = [NSMutableArray arrayWithArray:sortedItems];
            }
            
            [feedsDict setObject:oldFeeds forKey:[NSNumber numberWithInt:feedStyle]];
            
            completion(sortedItems);
            
        } else {
            completion(nil);
        }
    }];
}

- (void)saveFeedsInStore:(NSArray<RSSItem *> *)items withAttribute:(NSString *)attribute {
    
    [storeManager saveRSSItems:items withAttribute:attribute withCompletion:^(NSError *error, BOOL contextDidSave) {
        
        if (!error) {
            NSLog(@"SAVED");
        }
    }];
}

#pragma mark: - Helpers
- (NSArray<RSSItem *> *)findNewFeedsFromOldArray:(NSArray<RSSItem *> *)oldFeeds andNewArray:(NSArray<RSSItem *> *)newFeeds {
    
    NSMutableArray<RSSItem *> *resultantArray = [NSMutableArray array];
    
    for (RSSItem *newItem in newFeeds) {
        
        BOOL newFeedIsNew = true;
        
        for (RSSItem *oldItem in oldFeeds) {
            NSComparisonResult result = [newItem.pubDate compare:oldItem.pubDate];
            
            if (result == NSOrderedAscending) {
                newFeedIsNew = false;
                break;
                
            } else if (result == NSOrderedDescending) {
                continue;
                
            } else { //NSOrderedSame
                
                newFeedIsNew = false;
                
                BOOL isSame = true;
                
                if (![newItem.title isEqualToString:oldItem.title]) {
                    isSame = false;
                }
                if (![newItem.itemDescription isEqualToString:oldItem.itemDescription]) {
                    isSame = false;
                }
                if (![newItem.category isEqualToString:oldItem.category]) {
                    isSame = false;
                }
                if (![newItem.author isEqualToString:oldItem.author]) {
                    isSame = false;
                }
                if (![newItem.guid isEqualToString:oldItem.guid]) {
                    isSame = false;
                }
                if (![newItem.link.absoluteString isEqualToString:oldItem.link.absoluteString]) {
                    isSame = false;
                }
                
                if (!isSame) {
                    newFeedIsNew = true;
                }
            }
        }
        
        if (newFeedIsNew) {
            [resultantArray addObject:newItem];
        }
    }
    
    return resultantArray;
}

- (NSArray<RSSItem *> *)sortFeedsArrayByDate:(NSArray<RSSItem *> *)feeds {
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pubDate" ascending:false];
    
    NSArray *sortedArray = [feeds sortedArrayUsingDescriptors:@[sortDescriptor]];
    return sortedArray;
}

@end



