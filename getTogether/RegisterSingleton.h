//
//  RegisterSingleton.h
//  getTogether
//
//  Created by Brendan Walsh  on 9/26/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterSingleton : NSObject {
    NSString *desiredUsername;
    NSString *desiredPassword;
    NSString *desiredEmail;
    NSString *desiredFirstname;
    NSString *desiredLastname;
}

+(RegisterSingleton *) getInstance;

-(void) setUsername:(NSString *)uname;
-(NSString *) getUsername;

-(void) setPassword:(NSString *)pword;
-(NSString *) getPassword;

-(void) setEmail:(NSString *)email;
-(NSString *) getEmail;

-(void) setFirstname:(NSString *)fname;
-(NSString *) getFirstname;

-(void) setLastname:(NSString *)lname;
-(NSString *) getLastname;

@end
