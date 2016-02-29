//
//  RegisterSingleton.m
//  getTogether
//
//  Created by Brendan Walsh  on 9/26/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import "RegisterSingleton.h"

@implementation RegisterSingleton

static RegisterSingleton *singletonInstance;

+ (RegisterSingleton *) getInstance {
    if (singletonInstance == nil) {
        singletonInstance = [[super alloc] init];
    }
    return singletonInstance;
}

-(void) setUsername:(NSString *)uname {
    desiredUsername = uname;
}
-(NSString *) getUsername {
    return desiredUsername;
}

-(void) setPassword:(NSString *)pword {
    desiredPassword = pword;
}
-(NSString *) getPassword {
    return desiredPassword;
}

-(void) setEmail:(NSString *)email {
    desiredEmail = email;
}
-(NSString *) getEmail {
    return desiredEmail;
}

-(void) setFirstname:(NSString *)fname {
    desiredFirstname = fname;
}
-(NSString *) getFirstname {
    return desiredFirstname;
}

-(void) setLastname:(NSString *)lname {
    desiredLastname = lname;
}
-(NSString *) getLastname {
    return desiredLastname;
}

@end
