//
//  InvitesTableViewController.h
//  getTogether
//
//  Created by Brendan Walsh  on 9/9/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvitesTableViewController : UITableViewController <NSURLConnectionDelegate> {
    NSMutableData *_responseData;
    NSMutableArray *_sessionInvites;
    NSMutableArray *_friendInvites;
    NSMutableArray *_pendingInvites;
    NSDateFormatter *_dateFormatter;
}

@property NSMutableArray *arrays;

@end
