//
//  TweetCell.h
//  TestProject
//
//  Created by Svyatoslav Shaforenko on 7/31/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "SWTableViewCell.h"
#import "Tweet+Extensions.h"

@interface TweetCell : SWTableViewCell

+ (CGFloat) heightForCellWithMessage: (Tweet*) tweet;

@property (nonatomic, strong) Tweet* tweet;

@end
