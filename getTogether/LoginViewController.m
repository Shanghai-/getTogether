//
//  LoginViewController.m
//  getTogether
//
//  Created by Brendan Walsh  on 7/10/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import "LoginViewController.h"
#import "OtherUser.h" //IS THIS NECESSARY?
#import "UserDataSingleton.h"
#import "GTImageHandler.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginBG"]];
    [bgImage setFrame:self.view.bounds];
    [bgImage setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:bgImage];
    [self.view sendSubviewToBack:bgImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-----------------------------------------------------
#pragma mark IB Methods
//-----------------------------------------------------

//Called when the "Done" button on the keyboard is pressed
- (IBAction)doneEditing:(id)sender {
    [sender resignFirstResponder];
}

//Called when the login button is pressed
- (IBAction)authenticateUser:(id)sender {
    //Adds a spinner to the view to indicate loading
    [_spinner startAnimating];
    
    //Checks if the username and password are valid
    if ([self allFieldsFilled]) {
        if ([self usernameValid] && [self passwordValid]) {
            //Sends a synchronous login request to the database with the entered credentials
            NSURL *loginURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://walsh.browning.edu/login.php?username=%@&password=%@", _usernameField.text, _passwordField.text]];
            NSURLRequest *request = [NSURLRequest requestWithURL:loginURL];
            NSURLResponse *response = nil;
            NSError *error = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
            
            //Checks if the connection returned without an error
            if (error == nil) {
                
                //Checks if the connection returned any data
                if (data != nil) {
                    
                    //Creates a dictionary with the downloaded info
                    NSDictionary *downloadedUserInfo = [NSJSONSerialization JSONObjectWithData:data
                                                                                       options:kNilOptions
                                                                                         error:&error];
                    if (downloadedUserInfo[@"userID"] != [NSNull null]) {
                        //Saves the user data to a singleton so that it can be accessed by other viewcontrollers
                        UserDataSingleton *singleton = [UserDataSingleton getInstance];
                        [singleton setUserID:downloadedUserInfo[@"userID"]];
                        [singleton setFirstname:downloadedUserInfo[@"firstname"]];
                        [singleton setLastname:downloadedUserInfo[@"lastname"]];
                        [singleton setEmail:downloadedUserInfo[@"email"]];
                        
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        NSString *uIDString = [downloadedUserInfo[@"userID"] description];
                        
                        if ([defaults objectForKey:uIDString]) {
                            //Segues to the friends list view controller
                            NSLog(@"Settings found, moving on");
                            NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
                            [self performSegueWithIdentifier:@"toTabBarController" sender:self];
                        } else {
                            NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
                            [temp setValue:[NSArray array] forKey:@"best friends"];
                            [temp setValue:[NSArray array] forKey:@"blocked users"];
                            [temp setValue:[NSNumber numberWithBool:YES] forKey:@"show offline friends"];
                            [temp setValue:[NSNumber numberWithBool:YES] forKey:@"low-data mode"];
                            NSDictionary *settings = [NSDictionary dictionaryWithDictionary:temp];
                            [defaults setValue:settings forKey:uIDString];
                            
                            NSLog(@"No settings found for user %@, settings created instead", uIDString);
                            NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
                            
                            [self performSegueWithIdentifier:@"toWelcomeScreen" sender:self];
                        }
                    } else {
                        UIAlertView *badInfo = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                                          message:@"Username or password incorrect. Please try again."
                                                                         delegate:nil
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil];
                        [badInfo show];
                    }
                    
                } else {
                    //Shows a bad login info alert
                    UIAlertView *badInfo = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                                      message:@"Username or password incorrect. Please try again."
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                    [badInfo show];
                }
            } else {
                //Shows a connection error alert
                UIAlertView *badConnection = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                                        message:@"The connection to the server failed. Please try again later."
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                [badConnection show];
            }
        } else {
            //Shows a "no login info entered" error alert
            UIAlertView *notAlphaInfo = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                                   message:@"The username or password fields contain illegal (non-alphaneumeric) characters. Please remove all non-alphaneumeric characters and try again."
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
            [notAlphaInfo show];
        }
    } else {
        //Shows a "no login info entered" error alert
        UIAlertView *notEnoughInfo = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                                message:@"Please fill in a username and a password."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
        [notEnoughInfo show];
    }
    
    [_spinner stopAnimating];
}

//TODO: Are these uname/pw validations necessary?
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

-(BOOL) allFieldsFilled {
    if ([_usernameField.text isEqualToString:@""] ||
        [_passwordField.text isEqualToString:@""]) {
        return NO;
    }
    return YES;
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
