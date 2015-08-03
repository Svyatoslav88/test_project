//
//  MainViewController.m
//  TestProject
//
//  Created by Svyatoslav Shaforenko on 7/31/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import "TwitterHelper.h"
#import "SearchViewController.h"
#import "TweetViewController.h"

@interface MainViewController () <MainViewDelegate>

@property (nonatomic, strong) MainView* contentView;
@property (nonatomic, strong) SearchViewController* searchVC;
@property (nonatomic, strong) TweetViewController* tweetVC;

@end

@implementation MainViewController

#pragma mark -
#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView = [[MainView alloc] initWithFrame: self.view.bounds];
    self.contentView.delegate = self;
    [self.view addSubview: self.contentView];
    
    self.searchVC = [[SearchViewController alloc] init];
    [self addChildViewController: self.searchVC];
    [self.contentView addContentView: self.searchVC.view];
    
    self.tweetVC = [[TweetViewController alloc] init];
    [self addChildViewController: self.tweetVC];
    
    [self showHud];
    [[TwitterHelper shared] loginTwitterSuccess:^{
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        [self showAlertViewWithTitle: NSLocalizedString(@"Error", "") andMessage: error.localizedDescription];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark MainViewDelegate

- (void) searchItemSelected
{
    [self.contentView addContentView: self.searchVC.view];
    [self.contentView setNeedsLayout];
}

- (void) savedItemSelected
{
    [self.contentView addContentView: self.tweetVC.view];
    [self.contentView setNeedsLayout];
}
@end
