//
//  RegisterViewController.h
//  getTogether
//
//  Created by Brendan Walsh  on 9/23/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (assign, nonatomic) UITextField *currentResponder;

@end
