//
//  MainView.h
//  TestProject
//
//  Created by Svyatoslav Shaforenko on 7/31/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainViewDelegate <NSObject>

- (void) searchItemSelected;
- (void) savedItemSelected;

@end

@interface MainView : UIView

@property (nonatomic, weak) id<MainViewDelegate> delegate;

- (void) addContentView: (UIView*) view;

@end
