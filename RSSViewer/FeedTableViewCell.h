//
//  FeedTableViewCell.h
//  RSSViewer
//
//  Created by Сергей Пугач on 24.02.17.
//
//

#import <UIKit/UIKit.h>

@interface FeedTableViewCell : UITableViewCell

    @property (weak, nonatomic) IBOutlet UIImageView *feedImageView;
    @property (weak, nonatomic) IBOutlet UILabel *titleLabel;
    @property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;
    
    
@end
