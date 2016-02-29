//
//  FriendsTableViewController.m
//  getTogether
//
//  Created by Brendan Walsh  on 8/29/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "UserDataSingleton.h"
#import "OtherUser.h"
#import "Session.h"
#import "CellButton.h"
#import "GTImageHandler.h"

@interface FriendsTableViewController ()

@end

@implementation FriendsTableViewController

static NSString *sessionCellIdentifier = @"sessionCell";
static NSString *friendCellIdentifier = @"friendCell";

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Loading friend list view");
    
    _sessions = [[NSMutableArray alloc] init];
    _bestFriends = [[NSMutableArray alloc] init];
    _onlineFriends = [[NSMutableArray alloc] init];
    _offlineFriends = [[NSMutableArray alloc] init];
    
    UIRefreshControl *refresher = [[UIRefreshControl alloc] init];
    [refresher addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresher;
    
    //Gets the userdata singleton instance and pulls the user ID from it
    UserDataSingleton *singleton = [UserDataSingleton getInstance];
    NSNumber *userID = [singleton getUserID];
    NSDictionary *settings = [[NSUserDefaults standardUserDefaults] objectForKey:[userID description]];
    _showingOfflineFriends = [[settings objectForKey:@"show offline friends"] boolValue];
    
    //Sends an asynchronous network request to the database to find friends of the user
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:
                                       @"http://walsh.browning.edu/getFriendIDs.php?user=%i", [userID intValue]]];
    NSURLRequest *friendsRequest = [NSURLRequest requestWithURL:URL];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:friendsRequest delegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (_showingOfflineFriends) {
        return 4;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return [_sessions count];
        case 1:
            return [_bestFriends count];
        case 2:
            return [_onlineFriends count];
        case 3:
            return [_offlineFriends count];
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Current Sessions";
        case 1:
            return @"Best Friends";
        case 2:
            return @"Online Friends";
        case 3:
            return @"Offline Friends";
        default:
            return @"";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Index path section:%li row:%li", (long)indexPath.section, (long)indexPath.row);
    if ((int)indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sessionCellIdentifier];
        Session *session = [[_arrays objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        UIImageView *avatarView = (UIImageView *)[cell.contentView viewWithTag:10];
        NSString *urlString = [NSString stringWithFormat:@"http://walsh.browning.edu/users/%i/avatar.png", [[[session getPartner] userID] intValue]];
        UIImage *avatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
        if (avatar == nil) avatar = [UIImage imageNamed:@"defaultAvatar"];
        [avatarView setImage:avatar];
        avatarView.clipsToBounds = YES;
        avatarView.layer.cornerRadius = avatarView.bounds.size.width / 2;
        
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:11];
        [nameLabel setText:[[session getPartner] fullname]];
        
        UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:12];
        //NSTimeInterval testin = [session timeLeft];
        [timeLabel setText:@"14m left"];
        
        CellButton *closeSession = (CellButton *)[cell.contentView viewWithTag:13];
        [closeSession setImage:[UIImage imageNamed:@"endSession"] forState:UIControlStateNormal];
        //[closeSession addTarget:self action:@selector(endSession:) forControlEvents:UIControlEventTouchDown];
        
        UIView *colorView = (UIView *)[cell.contentView viewWithTag:14];
        [colorView setBackgroundColor:[[session partner] markerColor]];
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCellIdentifier];
        OtherUser *friend = [[_arrays objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        // Configure Cell
        UIImageView *avatarView = (UIImageView *)[cell.contentView viewWithTag:15];
        NSString *urlString = [NSString stringWithFormat:@"http://walsh.browning.edu/users/%i/avatar.png", [friend.userID intValue]];
        UIImage *avatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
        if (avatar == nil) avatar = [UIImage imageNamed:@"defaultAvatar"];
        [avatarView setImage:avatar];
        avatarView.clipsToBounds = YES;
        avatarView.layer.cornerRadius = avatarView.bounds.size.width / 2;
        
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:16];
        [nameLabel setText:[friend fullname]];
        
        UILabel *sessionLabel = (UILabel *)[cell.contentView viewWithTag:17];
        [sessionLabel setText:[NSString stringWithFormat:@"@%@",[friend username]]];
        
        CellButton *inviteToSession = (CellButton *)[cell.contentView viewWithTag:18];
        if (friend.isOnline && friend.isAvailable) {
            [inviteToSession setImage:[UIImage imageNamed:@"invite to session"] forState:UIControlStateNormal];
            inviteToSession.associatedID = friend.userID;
            inviteToSession.indPath = indexPath;
            [inviteToSession addTarget:self action:@selector(invitePressedAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [inviteToSession removeFromSuperview];
        }
        return cell;
    }
    
    return nil;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)refreshTable:(UIRefreshControl *)refreshControl {
    //Gets the userdata singleton instance and pulls the user ID from it
    UserDataSingleton *singleton = [UserDataSingleton getInstance];
    int userID = [[singleton getUserID] intValue];
    
    //Sends an asynchronous network request to the database to find friends of the user
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:
                                       @"http://walsh.browning.edu/getFriendIDs.php?user=%i", userID]];
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

- (void)invitePressedAtIndexPath:(id)sender{
    NSLog(@"Button pressed!");
    CellButton *cellButton = (CellButton *)sender;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:cellButton.indPath];
    UILabel *sessionLabel = (UILabel *)[cell.contentView viewWithTag:11];
    sessionLabel.textColor = [UIColor blueColor];
    sessionLabel.text = @"Awaiting response...";
    //[sender setImage:[UIImage imageNamed:@"awaiting response2"] forState:UIControlStateNormal];
    [sender removeFromSuperview];
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
    
    //Converts downloaded JSON data to an array
    NSError *error = [[NSError alloc] init];
    if ([NSJSONSerialization isValidJSONObject:_responseData]) NSLog(@"ValidObject");
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:_responseData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&error];
    
    NSLog(@"%@", [arr description]);
    //Checks if the array was properly instantiated
    if (!arr) {
        NSLog(@"Error parsing JSON: %@", error);
    } else {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        NSArray *bffs = [def objectForKey:@"bestFriends"];
        
        //Clears the arrays so the downloaded data does not create duplicate entries
        [_sessions removeAllObjects];
        [_bestFriends removeAllObjects];
        [_onlineFriends removeAllObjects];
        [_offlineFriends removeAllObjects];
        
        //Loops through each result dictionary and creates a friend object with its contents
        for(NSMutableDictionary *item in arr) {
            OtherUser *friend = [[OtherUser alloc] initWithDictionary:[NSDictionary dictionaryWithDictionary:item]];
            if (friend.isOnline) {
                [_onlineFriends addObject:friend];
            } else {
                [_offlineFriends addObject:friend];
            }
        }
        OtherUser *testuser = [[OtherUser alloc] init];
        testuser.username = @"horny4bird";
        testuser.firstname = @"Carl";
        testuser.lastname = @"Wheezer";
        testuser.userID = [NSNumber numberWithInt:44];
        testuser.isOnline = YES;
        testuser.isAvailable = YES;
        testuser.markerColor = [UIColor blueColor];
        
        OtherUser *testuser2 = [[OtherUser alloc] init];
        testuser2.username = @"ectobiologist";
        testuser2.firstname = @"John";
        testuser2.lastname = @"Egbert";
        testuser2.userID = [NSNumber numberWithInt:45];
        testuser2.isOnline = YES;
        testuser2.isAvailable = YES;
        testuser2.markerColor = [UIColor yellowColor];
        
        Session *testsession = [[Session alloc] init];
        testsession.partner = testuser;
        testsession.timeStarted = [NSDate date];
        
        Session *testsession2 = [[Session alloc] init];
        testsession2.partner = testuser2;
        testsession2.timeStarted = [NSDate date];
        
        [_sessions addObject:testsession];
        [_sessions addObject:testsession2];
    }
    
    self.arrays = [NSMutableArray arrayWithObjects: _sessions, _bestFriends, _onlineFriends, _offlineFriends, nil];
    
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


/*
 OtherUser *friend = [[OtherUser alloc] initWithFirstname:[NSString stringWithString:[item objectForKey:@"firstname"]]
 Lastname:[NSString stringWithString:[item objectForKey:@"lastname"]]
 Username:[NSString stringWithString:[item objectForKey:@"username"]]
 UserID:[ [[item objectForKey:@"userID"] intValue]]
 OnlineState:[[item objectForKey:@"isOnline"] boolValue]
 SessionState:[[item objectForKey:@"isInSession"] boolValue]];
 */
@end
