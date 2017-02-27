//
//  RSSItem.h
//  RSSViewer
//
//  Created by Сергей Пугач on 25.02.17.
//
//

#import <UIKit/UIKit.h>

@class Item;

@interface RSSItem : NSObject <NSCoding>

@property (strong,nonatomic) NSString *author;
@property (strong,nonatomic) NSString *category;
@property (strong,nonatomic) NSString *itemDescription;
@property (strong,nonatomic) NSString *guid;
@property (strong,nonatomic) NSURL *link;
@property (strong,nonatomic) NSDate *pubDate;
@property (strong,nonatomic) NSString *title;

@property (strong,nonatomic) NSString *content;
@property (strong,nonatomic) NSURL *commentsLink;
@property (strong,nonatomic) NSURL *commentsFeed;
@property (strong,nonatomic) NSNumber *commentsCount;

-(NSArray *)imagesFromItemDescription;
-(NSArray *)imagesFromContent;
-(NSString *)stringFromDate;

- (instancetype)initWithBDModel:(Item *)bdItem;

@end
