//
//  FeedTableViewCell.m
//  RSSViewer
//
//  Created by Сергей Пугач on 24.02.17.
//
//

#import "FeedTableViewCell.h"

@implementation FeedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    self.imageView.image = nil;
}

@end
