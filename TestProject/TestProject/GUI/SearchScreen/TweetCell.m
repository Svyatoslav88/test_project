//
//  TweetCell.m
//  TestProject
//
//  Created by Svyatoslav Shaforenko on 7/31/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "TweetCell.h"
#import "UIView+Extensions.h"

@interface TweetCell ()

@property (nonatomic, strong) UILabel* tweetLabel;

@end

@implementation TweetCell

#pragma mark -
#pragma mark Lifecycle

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle: style reuseIdentifier: reuseIdentifier];
    if(self)
    {
        [self createSubviews];
    }
    return self;
}

- (void) createSubviews
{
    self.clipsToBounds = YES;
    self.tweetLabel = (
                       {
                           UILabel* label = [[UILabel alloc] init];
                           label.backgroundColor = [UIColor clearColor];
                           label.numberOfLines = 0;
                           label.font = [UIFont systemFontOfSize: 14.0f];
                           
                           [self.contentView addSubview: label];
                           label;
                       });
    UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(leftSwipe)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer: swipe];
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(rightSwipe)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer: swipe];
    self.userInteractionEnabled = YES;
}

- (void) setTweet: (Tweet*) tweet
{
    _tweet = tweet;
    self.tweetLabel.text = tweet.text;
}

- (void) leftSwipe
{
    [self showRightUtilityButtonsAnimated: YES];
}

- (void) rightSwipe
{
    [self hideUtilityButtonsAnimated: YES];
}

- (void) layoutSubviews
{
    self.tweetLabel.frame = CGRectMake(5.0f, 5.0f, self.width - 10.0f, [TweetCell heightForCellWithMessage: self.tweet] - 10.0f);
}

+ (CGFloat) heightForCellWithMessage: (Tweet*) tweet
{
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize: 14.0f]};
    
    CGSize size = [tweet.text sizeWithFont: [UIFont systemFontOfSize: 14.0f] constrainedToSize: CGSizeMake([UIScreen mainScreen].bounds.size.width - 10.0f, CGFLOAT_MAX) lineBreakMode: NSLineBreakByWordWrapping];
//    CGRect rect = [tweet.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 10.0f, CGFLOAT_MAX)
//                                              options:NSStringDrawingUsesLineFragmentOrigin
//                                           attributes:attributes
//                                              context:nil];
    return size.height + 10.0f;
}

@end
