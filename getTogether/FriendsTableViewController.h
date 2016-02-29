//
//  FriendsTableViewController.h
//  getTogether
//
//  Created by Brendan Walsh  on 8/29/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsTableViewController : UITableViewController <NSURLConnectionDelegate> {
    NSMutableData *_responseData;
    NSMutableArray *_sessions;
    NSMutableArray *_bestFriends;
    NSMutableArray *_onlineFriends;
    NSMutableArray *_offlineFriends;
    
    BOOL _showingOfflineFriends;
}

@property NSMutableArray *arrays;
@property (strong, nonatomic) NSNumber *editing;

@end
