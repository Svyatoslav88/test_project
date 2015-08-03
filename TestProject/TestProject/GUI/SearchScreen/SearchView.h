//
//  SearchView.h
//  TestProject
//
//  Created by Svyatoslav Shaforenko on 7/31/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchViewDelegate <NSObject>

- (void) searchWithString: (NSString*) string;

@end

@interface SearchView : UIView

@property (nonatomic, weak) id<SearchViewDelegate> delegate;
@property (nonatomic, strong) UITableView* tableView;

@end
