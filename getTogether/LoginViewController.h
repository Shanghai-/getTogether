//
//  LoginViewController.h
//  getTogether
//
//  Created by Brendan Walsh  on 7/10/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
