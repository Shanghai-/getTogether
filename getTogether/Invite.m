//
//  Invite.m
//  getTogether
//
//  Created by Brendan Walsh  on 9/11/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import "Invite.h"

@implementation Invite

-(id) init {
    self = [super init];
    if (self) {
        self.userID = [NSNumber numberWithInt:0];
        self.firstname = @"";
        self.lastname = @"";
        self.username = @"";
        self.sentOn = [NSDate date];
        return self;
    }
    return nil;
}

-(id) initWithID:(NSNumber *)uID Firstname:(NSString *)firstname Lastname:(NSString *)lastname Username:(NSString *)username {
    self = [self init];
    if (self) {
        self.userID = uID;
        self.firstname = firstname;
        self.lastname = lastname;
        self.username = username;
        return self;
    }
    return nil;
}

- (NSString *)fullname {
    return [NSString stringWithFormat:@"%@ %@", self.firstname, self.lastname];
}

@end
