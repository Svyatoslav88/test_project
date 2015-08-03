//
//  SearchViewController.m
//  TestProject
//
//  Created by Svyatoslav Shaforenko on 7/31/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchView.h"
#import "TwitterHelper.h"
#import "TweetCell.h"
#import "TPDBManager.h"

@interface SearchViewController () <SearchViewDelegate, UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate>

@property (nonatomic, strong) SearchView* contentView;
@property (nonatomic, strong) NSMutableArray* tweets;
@property (nonatomic, strong) NSString* currentSearchString;
@property (nonatomic, strong) NSString* nextSearch;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation SearchViewController

#pragma mark -
#pragma mark Lifecycle

- (void) loadView
{
    self.contentView = [[SearchView alloc] initWithFrame: CGRectZero];
    self.view = self.contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweets = [NSMutableArray array];
    self.currentSearchString = @"";
    self.contentView.delegate = self;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.contentView.tableView addSubview:refreshControl];
    self.contentView.tableView.delegate = self;
    self.contentView.tableView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Actions

- (void)refresh:(UIRefreshControl *)refreshControl {
    self.nextSearch = nil;
    [[TwitterHelper shared] getNextTweetsWithSearchString: self.currentSearchString
                                                     page: self.nextSearch
                                             SuccessBlock:^(NSArray *tweets, NSString *nextPage) {
                                                 [self.tweets removeAllObjects];
                                                 [refreshControl endRefreshing];
                                                 [self.tweets addObjectsFromArray: tweets];
                                                 [self.contentView.tableView reloadData];
                                             }
                                                  failure:^(NSError *error) {
                                                      [refreshControl endRefreshing];
                                                  }];
    
}

#pragma mark -
#pragma mark TableViewDelegate

- (CGFloat) tableView: (UITableView*) tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath
{
    return [TweetCell heightForCellWithMessage: [self.tweets objectAtIndex: indexPath.row]];
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection: (NSInteger) section
{
    return self.tweets.count;
}

- (UITableViewCell*) tableView: (UITableView*) tableView cellForRowAtIndexPath: (NSIndexPath*) indexPath
{
    TweetCell* cell = [tableView dequeueReusableCellWithIdentifier: @"Cell"];
    if(!cell)
    {
        cell = [[TweetCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"Cell"];
        
    }
    NSMutableArray* buttons = [NSMutableArray array];
    [buttons sw_addUtilityButtonWithColor: [UIColor greenColor] title: @"Add"];
    [cell setRightUtilityButtons: buttons WithButtonWidth: 100.0f];
    cell.delegate = self;
    cell.tweet = [self.tweets objectAtIndex: indexPath.row];
    
    if (indexPath.row == [self.tweets count] - 1)
    {
        [self loadMore];
    }
    
    return cell;
}

- (void) swipeableTableViewCell: (TweetCell*) cell didTriggerRightUtilityButtonWithIndex: (NSInteger) index;
{
    NSManagedObjectContext* context = [TPDBManager getNewDBContext];
    Tweet* tweet = [TPDBManager createTweetFromDictionary: [cell.tweet dictionaryFromModel] inContext: context];
    [TPDBManager saveContextAsync: context];
    [cell hideUtilityButtonsAnimated: YES];
}

- (void) loadMore
{
    if(self.isLoading)
        return;
    self.isLoading = YES;
    
    [[TwitterHelper shared] getNextTweetsWithSearchString: self.currentSearchString
                                                     page: self.nextSearch
                                             SuccessBlock:^(NSArray *tweets, NSString *nextPage) {
                                                 [self.tweets addObjectsFromArray: tweets];
                                                 [self.contentView.tableView reloadData];
                                                 self.isLoading = NO;
                                             }
                                                  failure:^(NSError *error) {
                                                      self.isLoading = NO;
                                                  }];
}

#pragma mark -
#pragma mark SearchViewDelegate

- (void) searchWithString: (NSString*) string
{
    self.nextSearch = nil;
    self.currentSearchString = string;
    [[TwitterHelper shared] getNextTweetsWithSearchString: self.currentSearchString
                                                     page: self.nextSearch
                                             SuccessBlock:^(NSArray *tweets, NSString *nextPage) {
                                                 [self.tweets removeAllObjects];
                                                 [self.tweets addObjectsFromArray: tweets];
                                                 self.nextSearch = nextPage;
                                                 [self.contentView.tableView reloadData];
                                             }
                                                  failure:^(NSError *error) {
                                                      
                                                  }];
}

@end
