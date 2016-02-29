//
//  UserDataSingleton.h
//  getTogether
//
//  Created by Brendan Walsh  on 8/26/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataSingleton : NSObject {
    NSNumber *userID;
    NSString *username;
    NSString *firstname;
    NSString *lastname;
    NSString *email;
    NSNumber *sessionNumber;
    NSArray *sessions;
}

+(UserDataSingleton *) getInstance;

-(void) setUserID:(NSNumber *)newID;
-(NSNumber *) getUserID;

-(void) setFirstname:(NSString *)name;
-(NSString *) getFirstname;

-(void) setLastname:(NSString *)name;
-(NSString *) getLastname;

-(void) setUsername:(NSString *)name;
-(NSString *) getUsername;

-(void) setEmail:(NSString *)mail;
-(NSString *) getEmail;

-(void) setSessionNumber:(NSNumber *)session;
-(NSNumber *) getSessionNumber;

-(void) setSessions:(NSArray *)sessionList;
-(NSArray *) getSessions;

@end
