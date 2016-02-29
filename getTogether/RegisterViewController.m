//
//  RegisterViewController.m
//  getTogether
//
//  Created by Brendan Walsh  on 9/23/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterSingleton.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableBG"]];
    [bgImage setFrame:self.view.bounds];
    [bgImage setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:bgImage];
    [self.view sendSubviewToBack:bgImage];
    
    /*UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTapRecognizer setNumberOfTapsRequired:1];
    [singleTapRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTapRecognizer];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}

- (IBAction)fieldEdited:(UITextField *)sender {
    self.currentResponder = sender;
    [sender setBackgroundColor:[UIColor whiteColor]];
}

- (IBAction)setCurrentResponder:(id)sender {
    self.currentResponder = sender;
}

- (IBAction)makeCurrentResponder:(id)sender {
    self.currentResponder = (UITextField *)sender;
}

- (IBAction)nextButton:(UIButton *)sender {
    NSString *desiredUsername = _usernameField.text;
    NSString *desiredPassword = _passwordField.text;
    NSString *confirmPassword = _confirmPasswordField.text;
    
    if ([self allFieldsFilled]) {
        UIColor *badFieldRed = [UIColor colorWithRed:1.0 green:0.3 blue:0.3 alpha:1.0];
        if ([desiredPassword isEqualToString:confirmPassword]) {
            if ([self usernameValid] && [self passwordValid]) {
                [_spinner startAnimating];
                NSLog(@"Checking database for extant username...");
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://walsh.browning.edu/checkUsername.php?username=%@", desiredUsername]];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                NSURLResponse *response = nil;
                NSError *error = nil;
                NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                NSLog(@"Connection complete!");
                
                if (error == nil) {
                    NSLog(@"No connection error hit.");
                    if (data) {
                        NSLog(@"Data downloaded.");
                        NSString *testito = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:NSJSONReadingAllowFragments
                                                                              error:&error];
                        if (error == nil) {
                            if ([testito isEqualToString:@"error"]) {
                                [_spinner stopAnimating];
                                [_usernameField setBackgroundColor:badFieldRed];
                                UIAlertView *takenUsername = [[UIAlertView alloc] initWithTitle:@"Username Taken"
                                                                                        message:@"An account has already been registered with this username. Please try another name."
                                                                                       delegate:self
                                                                              cancelButtonTitle:@"OK"
                                                                              otherButtonTitles:nil];
                                [takenUsername show];
                            }
                        } else {
                            NSLog(@"All is well. Moving onward...");
                            RegisterSingleton *singleton = [RegisterSingleton getInstance];
                            [singleton setUsername:desiredUsername];
                            [singleton setPassword:desiredPassword];
                            NSLog(@"Data saved to singleton. Performing segue...");
                            [self performSegueWithIdentifier:@"toPage2" sender:self];
                        }
                    }
                } else {
                    NSLog(@"Error: %@", error.description);
                }
            } else {
                UIAlertView *invalidChars = [[UIAlertView alloc] initWithTitle:@"Invalid Characters"
                                                                       message:@"Username or password contains invalid characters. Please use only alphaneumeric characters."
                                                                      delegate:self
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles: nil];
                [invalidChars show];
            }
        } else {
            NSLog(@"Passwords do not match.");
            [_passwordField setBackgroundColor:badFieldRed];
            [_confirmPasswordField setBackgroundColor:badFieldRed];
        }
    } else {
        NSLog(@"Please fill out all fields");
    }
}



-(BOOL) allFieldsFilled {
    if ([_usernameField.text isEqualToString:@""] ||
        [_passwordField.text isEqualToString:@""] ||
        [_confirmPasswordField.text isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

//Checks if the entered username only contains alphaneumeric characters
-(BOOL) usernameValid {
    NSCharacterSet *alphaSet = [NSCharacterSet alphanumericCharacterSet];
    if ([[_usernameField.text stringByTrimmingCharactersInSet:alphaSet] isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

//Checks if the entered password only contains alphaneumeric characters
-(BOOL) passwordValid {
    NSCharacterSet *alphaSet = [NSCharacterSet alphanumericCharacterSet];
    if ([[_passwordField.text stringByTrimmingCharactersInSet:alphaSet] isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
