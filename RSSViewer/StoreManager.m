//
//  StoreManager.m
//  RSSViewer
//
//  Created by Сергей Пугач on 26.02.17.
//
//

#import "StoreManager.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Item+CoreDataProperties.h"
#import "RSSItem.h"

@interface StoreManager ()
{
    NSInteger maxEntityCount;
    NSInteger maxFetchingCount;
}
@end

@implementation StoreManager

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
        
        maxEntityCount = 100;
        maxFetchingCount = 30;
        
        [MagicalRecord setShouldDeleteStoreOnModelMismatch:YES];
        [MagicalRecord setupCoreDataStack];
        
    }
    return self;
}

- (void)saveRSSItems:(NSArray<RSSItem *> *)feedItems withAttribute:(NSString *)attribute withCompletion:(SavingCompletionBlock)completion {
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        
        //[Item MR_truncateAllInContext:localContext];
        NSArray *sortedOldItems = [Item MR_findAllSortedBy:@"pubDate" ascending:false inContext:localContext];
        
        NSInteger deletingCount = sortedOldItems.count - maxEntityCount;
        if (deletingCount > 0) {
            
            for (Item *deletingItem in [sortedOldItems subarrayWithRange:NSMakeRange(maxEntityCount - 1, deletingCount)]) {
                
                [deletingItem MR_deleteEntityInContext:localContext];
            }
        }
        
        for (RSSItem *rssItem in feedItems) {
            Item *item = [Item MR_createEntityInContext:localContext];
            
            item.title = rssItem.title;
            item.itemDescription = rssItem.itemDescription;
            item.category = rssItem.category;
            item.author = rssItem.author;
            item.guid = rssItem.guid;
            item.pubDate = rssItem.pubDate;
            item.link = rssItem.link.absoluteString;
            
            item.feedStyle = attribute;
        }
        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        completion(error,contextDidSave);
    }];
}

- (void)getRSSItemsForAttribute:(NSString *)attribute withPage:(NSInteger)page andCompletion:(ItemsCompletionBlock)completion {
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"feedStyle==%@",attribute];
        NSArray *items = [Item MR_findAllWithPredicate:predicate inContext:localContext];
        
        if (items.count) {
            NSInteger firstItem = page * maxFetchingCount;
            if (firstItem < items.count) {
                
                NSInteger lastItem;
                
                NSInteger limit = items.count - maxFetchingCount;
                if (limit > 0) {
                    lastItem = firstItem + maxFetchingCount;
                } else {
                    lastItem = items.count;
                }
                
                NSRange range = NSMakeRange(firstItem, lastItem);
                
                NSMutableArray *rssItems = [NSMutableArray array];
                for (Item *bdItem in [items subarrayWithRange:range]) {
                    [rssItems addObject:[[RSSItem alloc]initWithBDModel:bdItem]];
                }
                
                completion(rssItems);
                
            } else {
                completion(nil);
            }
        } else {
            completion(nil);
        }
        
    }];
}

@end
