//
//  Invite.h
//  getTogether
//
//  Created by Brendan Walsh  on 9/11/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Invite : NSObject

@property (strong, nonatomic) NSNumber *userID;
@property (copy, nonatomic) NSString *firstname;
@property (copy, nonatomic) NSString *lastname;
@property (copy, nonatomic) NSString *username;
@property (strong, nonatomic) NSDate *sentOn;

- (NSString *) fullname;

@end
