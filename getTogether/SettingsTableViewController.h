//
//  SettingsTableViewController.h
//  getTogether
//
//  Created by Brendan Walsh  on 9/17/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController {
    NSDictionary *_settings;
}

@property (weak, nonatomic) IBOutlet UILabel *firstnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *showOfflineFriendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowDataModeLabel;


@end
