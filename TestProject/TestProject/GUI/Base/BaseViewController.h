//
//  BaseViewController.h
//  TestProject
//
//  Created by Svyatoslav Shaforenko on 7/31/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void) showAlertViewWithTitle: (NSString*) title andMessage: (NSString*) message;
- (void) showHud;
- (void) hideHud;

@end
