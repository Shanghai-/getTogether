//
//  InvitesTableViewController.m
//  getTogether
//
//  Created by Brendan Walsh  on 9/9/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import "InvitesTableViewController.h"
#import "UserDataSingleton.h"
#import "CellButton.h"
#import "Invite.h"

@interface InvitesTableViewController ()

@end

@implementation InvitesTableViewController

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
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"YYYY-MM-DD"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIRefreshControl *refresher = [[UIRefreshControl alloc] init];
    [refresher addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresher;
    
    //Gets the userdata singleton instance and pulls the user ID from it
    UserDataSingleton *singleton = [UserDataSingleton getInstance];
    int userID = [[singleton getUserID] intValue];
    
    //Sends an asynchronous network request to the database to find friends of the user
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:
                                       @"http://walsh.browning.edu/getFriendInvites.php?user=%i", userID]];
    NSURLRequest *invitesRequest = [NSURLRequest requestWithURL:URL];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:invitesRequest delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Session Invites";
        case 1:
            return @"Friend Requests";
        case 2:
            return @"Sent Friend Requests";
        default:
            return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return [_sessionInvites count];
        case 1:
            return [_friendInvites count];
        case 2:
            return [_pendingInvites count];
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    Invite *inv = [[self.arrays objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:20];
    nameLabel.text = [inv fullname];
    UILabel *sessionLabel = (UILabel *)[cell.contentView viewWithTag:21];
    [_dateFormatter setDateFormat:@"MMM DD, YYYY"];
    sessionLabel.text = [NSString stringWithFormat:@"Sent on %@", [_dateFormatter stringFromDate:[inv sentOn]]];
    
    CellButton *acceptInvite = (CellButton *)[cell.contentView viewWithTag:22];
    acceptInvite.indPath = indexPath;
    [acceptInvite addTarget:self action:@selector(acceptPressedAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];
    CellButton *denyInvite = (CellButton *)[cell.contentView viewWithTag:23];
    denyInvite.indPath = indexPath;
    [denyInvite addTarget:self action:@selector(denyPressedAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)refreshTable:(UIRefreshControl *)refreshControl {
    //Gets the userdata singleton instance and pulls the user ID from it
    UserDataSingleton *singleton = [UserDataSingleton getInstance];
    int userID = [[singleton getUserID] intValue];
    
    //Sends an asynchronous network request to the database to find friends of the user
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:
                                       @"http://walsh.browning.edu/getFriendInvites.php?user=%i", userID]];
    NSLog(@"Refresh called");
    NSURLRequest *friendsRequest = [NSURLRequest requestWithURL:URL];
    NSURLConnection *ref = [[NSURLConnection alloc] initWithRequest:friendsRequest delegate:self];
}

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

#pragma mark - Button callbacks

- (void)acceptPressedAtIndexPath:(id)sender{
    CellButton *acceptButton = (CellButton *)sender;
    NSIndexPath *indexPath = acceptButton.indPath;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Accepted invite.");
    [_arrays removeObject:[[_arrays objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    NSArray *miniArray = [NSArray arrayWithObject:cell];
    [self.tableView deleteRowsAtIndexPaths:miniArray withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)denyPressedAtIndexPath:(id)sender{
    CellButton *denyButton = (CellButton *)sender;
    NSIndexPath *indexPath = denyButton.indPath;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Denied invite.");
    [_arrays removeObject:[[_arrays objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    NSArray *miniArray = [NSArray arrayWithObject:cell];
    [self.tableView deleteRowsAtIndexPaths:miniArray withRowAnimation:UITableViewRowAnimationLeft];
}

#pragma mark - NSURLConnectionDelegate Methods

//Called when the server responds to the asynchronous data request.
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc] init];
    NSLog(@"Response received!");
}

//Called when the asynchronous data request receives data
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
    NSLog(@"Incoming data...");
}

//Called when the connection will cache the url or something???
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

//Called when the connection finishes loading all data
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Connection finished!");
    
    if (!_sessionInvites) _sessionInvites = [[NSMutableArray alloc] init];
    if (!_friendInvites) _friendInvites = [[NSMutableArray alloc] init];
    if (!_pendingInvites) _pendingInvites = [[NSMutableArray alloc] init];
    
    [_sessionInvites removeAllObjects];
    [_friendInvites removeAllObjects];
    [_pendingInvites removeAllObjects];
    
    //Converts downloaded JSON data to an array
    NSError *error = [[NSError alloc] init];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:_responseData
                                                   options:kNilOptions
                                                     error:&error];
    
    //Checks if the array was properly instantiated
    if (!arr) {
        NSLog(@"Error parsing JSON: %@", error);
    } else {
        [_dateFormatter setDateFormat:@"YYYY-MM-DD"];
        for (NSArray *list in arr) {
            for(NSDictionary *item in list) {
                Invite *inv = [[Invite alloc] init];
                inv.userID = item[@"userID"];
                inv.firstname = item[@"firstname"];
                inv.lastname = item[@"lastname"];
                inv.username = item[@"username"];
                inv.sentOn = [_dateFormatter dateFromString:item[@"sentOn"]];
                if ([item[@"type"] isEqualToString:@"friend"]) {
                    [_friendInvites addObject:inv];
                } else if ([item[@"type"] isEqualToString:@"session"]) {
                    [_sessionInvites addObject:inv];
                    
                } else if ([item[@"type"] isEqualToString:@"pending"]) {
                    [_pendingInvites addObject:inv];
                } else {
                    NSLog(@"Typeless invite found.");
                }
            }
        }
    }
    
    self.arrays = [NSMutableArray arrayWithObjects:_friendInvites, _sessionInvites, _pendingInvites, nil];
    
    if ([self.refreshControl isRefreshing]) [self.refreshControl endRefreshing];
    [self.tableView reloadData];
    NSLog(@"reloading data...");
}

//Called if the connection fails
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *badConnection = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                            message:@"The connection to the server failed. Please try again later."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
    [badConnection show];
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
