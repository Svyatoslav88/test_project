//
//  TweetView.m
//  TestProject
//
//  Created by Svyatoslav Shaforenko on 7/31/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "TweetView.h"
#import "UIView+Extensions.h"

@implementation TweetView

#pragma mark -
#pragma mark Lifecycle

- (instancetype) initWithFrame: (CGRect) frame
{
    self= [super initWithFrame: frame];
    if(self)
    {
        [self createSubviews];
    }
    return self;
}

- (void) createSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    
        self.tableView = (
                      {
                          UITableView* tableView = [[UITableView alloc] init];
                          tableView.backgroundColor = [UIColor clearColor];
                          tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                          tableView.clipsToBounds = YES;
                          
                          [self addSubview: tableView];
                          
                          tableView;
                      });
}

- (void) layoutSubviews
{
    self.tableView.frame = CGRectMake(0.0f, 0.0f, self.width, self.height);
}


@end
