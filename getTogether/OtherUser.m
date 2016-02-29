//
//  OtherUser.m
//  getTogether
//
//  Created by Brendan Walsh  on 8/23/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import "OtherUser.h"

@implementation OtherUser

//Initializes an empty User object
- (id)init {
    self = [super init];
    if (self) {
        self.userID = 0;
        self.username = @"";
        self.firstname = @"";
        self.lastname = @"";
        self.isOnline = NO;
        self.isAvailable = NO;
        self.markerColor = [UIColor whiteColor];
        
        return self;
    }
    return nil;
}

- (id)initWithJSON:(NSData *)JSONdata {
    self = [super init];
    if (self) {
        NSError *error = [[NSError alloc] init];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSONdata
                                                             options:kNilOptions
                                                               error:&error];
        if (error == nil) {
            return [self initWithDictionary:dict];
        }
        return nil;
    }
    return nil;
}

- (id)initWithFirstname:(NSString *)firstName Lastname:(NSString *)lastName
               Username:(NSString *)userName UserID:(NSNumber *)uID
            OnlineState:(BOOL)online Availability:(BOOL)availability
            MarkerColor:(UIColor *)markerColor{
    self = [super init];
    
    if (self) {
        self.userID = uID;
        self.username = userName;
        self.firstname = firstName;
        self.lastname = lastName;
        self.isOnline = online;
        self.isAvailable = availability;
        self.markerColor = markerColor;
        
        NSLog(@"Friend %@ %@ created.", self.firstname, self.lastname);
        
        return self;
    }
    return nil;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.userID = [NSNumber numberWithInt:[[NSString stringWithString:dict[@"userID"]] intValue]];
        self.username = [NSString stringWithString:dict[@"username"]];
        self.firstname = [NSString stringWithString:dict[@"firstname"]];
        self.lastname = [NSString stringWithString:dict[@"lastname"]];
        self.isOnline = YES;
        self.isAvailable = YES;
        
        return self;
    }
    return nil;
}

- (NSString *)fullname {
    return [NSString stringWithFormat:@"%@ %@", self.firstname, self.lastname];
}

@end
