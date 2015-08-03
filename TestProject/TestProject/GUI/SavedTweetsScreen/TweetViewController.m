//
//  TweetViewController.m
//  TestProject
//
//  Created by Svyatoslav Shaforenko on 7/31/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "TweetViewController.h"
#import "TweetView.h"
#import "TweetCell.h"
#import "TPDBManager.h"

@interface TweetViewController ()<UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) TweetView* contentView;
@property (nonatomic, strong) NSManagedObjectContext* context;
@property (nonatomic, strong) NSFetchedResultsController* frc;

@end

@implementation TweetViewController

#pragma mark -
#pragma mark Lifecycle

- (void) loadView
{
    self.contentView = [[TweetView alloc] initWithFrame: CGRectZero];
    self.view = self.contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.context = [TPDBManager getMainContext];
    [self setupDefaultFRC];
    self.contentView.tableView.delegate = self;
    self.contentView.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark FRC

- (void) setupDefaultFRC
{
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName: @"Tweet"];
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"id_str" ascending: NO];
    [fetchRequest setSortDescriptors: [NSArray arrayWithObject: sortDescriptor]];
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest: fetchRequest
                                                                          managedObjectContext: self.context
                                                                            sectionNameKeyPath: nil
                                                                                     cacheName: nil];
    
    frc.delegate = self;
    
    NSError *error;
    if (![frc performFetch:&error])
    {
        NSLog(@"%@ - error: %@", NSStringFromSelector(_cmd), error);
    }
    
    self.frc = frc;
}

- (void) controllerDidChangeContent: (NSFetchedResultsController*) controller
{
    [self.contentView.tableView reloadData];
}

#pragma mark -
#pragma mark TableViewDelegate

- (CGFloat) tableView: (UITableView*) tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath
{
    return [TweetCell heightForCellWithMessage: [self.frc.fetchedObjects objectAtIndex: indexPath.row]];
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection: (NSInteger) section
{
    return self.frc.fetchedObjects.count;
}

- (UITableViewCell*) tableView: (UITableView*) tableView cellForRowAtIndexPath: (NSIndexPath*) indexPath
{
    TweetCell* cell = [tableView dequeueReusableCellWithIdentifier: @"Cell"];
    if(!cell)
    {
        cell = [[TweetCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"Cell"];
        
    }
    NSMutableArray* buttons = [NSMutableArray array];
    [buttons sw_addUtilityButtonWithColor: [UIColor redColor] title: @"Delete"];
    [cell setRightUtilityButtons: buttons WithButtonWidth: 100.0f];
    cell.delegate = self;
    cell.tweet = [self.frc.fetchedObjects objectAtIndex: indexPath.row];
    
    return cell;
}

- (void) swipeableTableViewCell: (TweetCell*) cell didTriggerRightUtilityButtonWithIndex: (NSInteger) index;
{
    NSManagedObjectContext* context = [TPDBManager getNewDBContext];
    Tweet* tweet = [TPDBManager tweetWithStrId: cell.tweet.id_str inContext: context];
    [TPDBManager deleteObject: tweet context: context];
    [TPDBManager saveContextAsync: context];
}

@end
