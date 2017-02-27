//
//  ConnectionManager.m
//  RSSViewer
//
//  Created by Сергей Пугач on 25.02.17.
//
//

#import "ConnectionManager.h"

#import "RSSParser.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface ConnectionManager ()
{
    //DataManager *dataManager;
}

@property (nonatomic, readonly) NSString *baseURL;
@property (nonatomic, strong) SDWebImageManager *imageManager;

@end

@implementation ConnectionManager
@synthesize liveNewsUrl = _liveNewsUrl, analyticsUrl = _analyticsUrl;

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        
        _baseURL = @"https://widgets.spotfxbroker.com:8088/";
        //dataManager = [DataManager sharedInstance];
        
        _liveNewsUrl = @"GetLiveNewsRss";
        _analyticsUrl = @"GetAnalyticsRss";
        
        _imageManager = [SDWebImageManager sharedManager];
        [_imageManager.imageDownloader setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
                             forHTTPHeaderField:@"Accept"];
    }
    return self;
}

- (void)getFeedsWithStyle:(FeedsStyle)feedStyle andCompletion:(FeedsCompletionBlock)completion {
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", _baseURL, [self convertFeedStyleToString:feedStyle]]]];
    [RSSParser parseRSSFeedForRequest:req success:^(NSArray *feedItems) {
        
        completion(nil, feedItems);
        
    } failure:^(NSError *error) {
        
        completion(error, nil);
        
    }];
    
    
}

- (void)getImageWithPath:(NSString*)path andCompletion:(CompletionBlock)completion {
    
    NSURL *imagePostURL = [NSURL URLWithString:path];
    
    [self.imageManager loadImageWithURL:imagePostURL
                                options:0
                               progress:nil
                              completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                  
                                  if (image && finished) {
                                      completion(nil, image);
                                  } else {
                                      completion(nil, nil);
                                  }
                              }];
}

#pragma mark: - Helpers
- (NSString *)convertFeedStyleToString:(FeedsStyle)style {
    
    NSString *requestURL;
    switch (style) {
            case FeedsStyleLive:
            requestURL = _liveNewsUrl;
            
            break;
            case FeedsStyleAnalytics:
            requestURL = _analyticsUrl;
        default:
            break;
    }
    
    return requestURL;
}

@end
