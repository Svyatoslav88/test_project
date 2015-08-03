//
//  SearchView.m
//  TestProject
//
//  Created by Svyatoslav Shaforenko on 7/31/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "SearchView.h"
#import "UIView+Extensions.h"

@interface SearchView () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField* searchField;

@end

@implementation SearchView

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
    
    self.searchField = (
                        {
                            UITextField* textField = [[UITextField alloc] init];
                            
                            textField.delegate = self;
                            textField.layer.borderWidth = 1.0f;
                            textField.layer.borderColor = [[UIColor grayColor] CGColor];
                            textField.layer.cornerRadius = 3.0f;
                            textField.placeholder = NSLocalizedString(@"Enter search string", "");
                            textField.returnKeyType = UIReturnKeySearch;
                            
                            [self addSubview: textField];
                            
                            textField;
                        });
    
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
    self.searchField.frame = CGRectMake(5.0f, 5.0f, self.width - 10.0f, 30.0f);
    self.tableView.frame = CGRectMake(0.0f, 40.0f, self.width, self.height - 40.0f);
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField*) textField
{
    [textField resignFirstResponder];
    if(self.delegate && [self.delegate respondsToSelector: @selector(searchWithString:)])
        [self.delegate searchWithString: textField.text];
    return YES;
}

@end
