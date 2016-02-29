//
//  SettingsTableViewController.m
//  getTogether
//
//  Created by Brendan Walsh  on 9/17/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "UserDataSingleton.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableBG"]];
    [bgImage setFrame:self.tableView.bounds];
    [bgImage setBackgroundColor:[UIColor lightGrayColor]];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:bgImage];
    [self.view sendSubviewToBack:bgImage];
    
    UserDataSingleton *singleton = [UserDataSingleton getInstance];
    _settings = [[NSUserDefaults standardUserDefaults] objectForKey:[[singleton getUserID] description]];
    
    [self updateTableText];
}

- (NSString *) numericalBool:(NSNumber *)aNumber toStringType:(int)type {
    switch (type) {
        case 0:
            if([aNumber intValue] == 0){return @"No";} else {return @"Yes";};
        case 1:
            if([aNumber intValue] == 0){return @"Disabled";} else {return @"Enabled";};
        default:
            return @"ERR";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateTableText {
    NSLog(@"Updating Table Data");
    UserDataSingleton *singleton = [UserDataSingleton getInstance];
    
    NSString *dataOption = [self numericalBool:[_settings objectForKey:@"low-data mode"] toStringType:1];
    NSString *offlineOption = [self numericalBool:[_settings objectForKey:@"show offline friends"] toStringType:0];
    
    self.firstnameLabel.text = [singleton getFirstname];
    self.lastnameLabel.text = [singleton getLastname];
    self.emailLabel.text = [singleton getEmail];
    self.showOfflineFriendsLabel.text = offlineOption;
    self.lowDataModeLabel.text = dataOption;
}

#pragma mark - Button Callbacks

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == [[NSNumber numberWithInt:3] integerValue]) {
        if (indexPath.row == [[NSNumber numberWithInt:0] integerValue]) {
            if ([[_settings objectForKey:@"show offline friends"] intValue] == 0) {
                [_settings setValue:[NSNumber numberWithInt:1] forKey:@"show offline friends"];
            } else if ([[_settings objectForKey:@"show offline friends"] intValue] == 1) {
                [_settings setValue:[NSNumber numberWithInt:0] forKey:@"show offline friends"];
            } else {
                NSLog(@"Error");
            }
            
            [self updateTableText];
        } else if (indexPath.row == 1){
            //TODO: Change bariable and label
        }
    }
}

/*#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
        case 1:
        case 2:
        case 3:
            return 2;
        default:
            return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
