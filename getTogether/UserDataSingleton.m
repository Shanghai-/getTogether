//
//  UserDataSingleton.m
//  getTogether
//
//  Created by Brendan Walsh  on 8/26/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import "UserDataSingleton.h"

@implementation UserDataSingleton

static UserDataSingleton *singletonInstance;

+ (UserDataSingleton *) getInstance {
    if (singletonInstance == nil) {
        singletonInstance = [[super alloc] init];
    }
    return singletonInstance;
}

- (void) setUserID:(NSNumber *)newID  {
    userID = newID;
}
- (NSNumber *) getUserID {
    return userID;
}

- (void) setFirstname:(NSString *)name {
    firstname = name;
}
- (NSString *) getFirstname {
    return firstname;
}

- (void) setLastname:(NSString *)name {
    lastname = name;
}
- (NSString *) getLastname {
    return lastname;
}

- (void) setUsername:(NSString *)name {
    username = name;
}
- (NSString *) getUsername {
    return username;
}

- (void) setEmail:(NSString *)mail {
    email = mail;
}
- (NSString *) getEmail {
    return email;
}

-(void) setSessionNumber:(NSNumber *)session {
    sessionNumber = session;
}
-(NSNumber *) getSessionNumber {
    return sessionNumber;
}

-(void) setSessions:(NSArray *)sessionList {
    sessions = sessionList;
}
-(NSArray *) getSessions {
    return sessions;
}

@end
