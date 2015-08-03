//
//  MainView.m
//  TestProject
//
//  Created by Svyatoslav Shaforenko on 7/31/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "MainView.h"
#import "UIView+Extensions.h"

@interface MainView ()

@property (nonatomic, strong) UIButton* searchButton;
@property (nonatomic, strong) UIButton* savedItemsButton;
@property (nonatomic, strong) UIView* contentView;

@end

@implementation MainView

#pragma mark -
#pragma mark Lifecycle

- (instancetype) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    if(self)
    {
        [self createSubviews];
    }
    return self;
}

- (void) createSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.searchButton = (
                         {
                             UIButton* button = [[UIButton alloc] init];
                             
                             button.backgroundColor = [UIColor clearColor];
                             [button setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
                             [button setTitleColor: [UIColor blueColor] forState: UIControlStateSelected];
                             [button setTitle: NSLocalizedString(@"Search", "") forState: UIControlStateNormal];
                             
                             [button addTarget: self action: @selector(searchButtonTapped) forControlEvents: UIControlEventTouchUpInside];
                             
                             [self addSubview: button];
                             button;
                         });
    [self.searchButton setSelected: YES];
    
    self.savedItemsButton = (
                         {
                             UIButton* button = [[UIButton alloc] init];
                             
                             button.backgroundColor = [UIColor clearColor];
                             [button setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
                             [button setTitleColor: [UIColor blueColor] forState: UIControlStateSelected];
                             [button setTitle: NSLocalizedString(@"Saved", "") forState: UIControlStateNormal];
                             
                             [button addTarget: self action: @selector(savedItemsButtonTapped) forControlEvents: UIControlEventTouchUpInside];
                             
                             [self addSubview: button];
                             button;
                         });
}

- (void) layoutSubviews
{
    self.searchButton.frame = CGRectMake(0.0f, 20.0f, self.width / 2, 40.0f);
    self.savedItemsButton.frame = CGRectMake(self.width / 2, 20.0f, self.width / 2, 40.0f);
    if(self.contentView)
    {
        self.contentView.frame = CGRectMake(0.0f, 60.0f, self.width, self.height - 60.0f);
        [self.contentView setNeedsLayout];
    }
}

#pragma mark -
#pragma mark Actions

- (void) searchButtonTapped
{
    if(self.searchButton.isSelected)
        return;
    [self.searchButton setSelected: YES];
    [self.savedItemsButton setSelected: NO];
    
    if(self.delegate && [self.delegate respondsToSelector: @selector(searchItemSelected)])
        [self.delegate searchItemSelected];
}

- (void) savedItemsButtonTapped
{
    if(self.savedItemsButton.isSelected)
        return;
    [self.savedItemsButton setSelected: YES];
    [self.searchButton setSelected: NO];
    
    if(self.delegate && [self.delegate respondsToSelector: @selector(savedItemSelected)])
        [self.delegate savedItemSelected];
}

#pragma mark -
#pragma mark Public

- (void) addContentView: (UIView*) view
{
    if(self.contentView)
       [self.contentView removeFromSuperview];
    self.contentView = view;
    [self addSubview: self.contentView];
}

@end
