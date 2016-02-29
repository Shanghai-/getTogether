//
//  OtherUser.h
//  getTogether
//
//  Created by Brendan Walsh  on 8/23/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OtherUser : NSObject

@property (strong, nonatomic) NSNumber *userID;
@property (copy, nonatomic) NSString *firstname;
@property (copy, nonatomic) NSString *lastname;
@property (copy, nonatomic) NSString *username;
@property (nonatomic, assign) BOOL isOnline;
@property (nonatomic, assign) BOOL isAvailable;
@property (strong, nonatomic) UIColor *markerColor;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;

- (id)initWithJSON:(NSData *)JSONdata;

- (id)initWithFirstname:(NSString *)firstName Lastname:(NSString *)lastName
               Username:(NSString *)userName UserID:(NSNumber *)uID
            OnlineState:(BOOL)online Availability:(BOOL)availability
            MarkerColor:(UIColor *)markerColor;

- (id) initWithDictionary:(NSDictionary *)dict;

- (id) init;

- (NSString *) fullname;

@end
