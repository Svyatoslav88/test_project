//
//  BaseViewController.m
//  TestProject
//
//  Created by Svyatoslav Shaforenko on 7/31/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

#pragma mark -
#pragma mark Lifecycle

- (void) loadView
{
    [super loadView];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Public

- (void) showAlertViewWithTitle: (NSString*) title andMessage: (NSString*) message
{
    [[[UIAlertView alloc] initWithTitle: title
                                message: message
                               delegate: nil
                      cancelButtonTitle: @"Ok"
                      otherButtonTitles: nil] show];
}

- (void) showHud
{
    [MBProgressHUD showHUDAddedTo: self.view animated: YES];
}

- (void) hideHud
{
    [MBProgressHUD hideAllHUDsForView: self.view animated: YES];
}

@end
