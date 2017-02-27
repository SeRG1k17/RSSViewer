//
//  RSSParser.h
//  RSSViewer
//
//  Created by Сергей Пугач on 25.02.17.
//
//

#import <Foundation/Foundation.h>
#import "RSSItem.h"

@interface RSSParser : NSObject <NSXMLParserDelegate> {
    RSSItem *currentItem;
    NSMutableArray *items;
    NSMutableString *tmpString;
    void (^block)(NSArray *feedItems);
    void (^failblock)(NSError *error);
}



+ (void)parseRSSFeedForRequest:(NSURLRequest *)urlRequest
                       success:(void (^)(NSArray *feedItems))success
                       failure:(void (^)(NSError *error))failure;

- (void)parseRSSFeedForRequest:(NSURLRequest *)urlRequest
                       success:(void (^)(NSArray *feedItems))success
                       failure:(void (^)(NSError *error))failure;


@end
