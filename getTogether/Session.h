//
//  Session.h
//  getTogether
//
//  Created by Brendan Walsh  on 9/30/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OtherUser.h"

@interface Session : NSObject

@property (strong, nonatomic) OtherUser *partner;
@property (strong, nonatomic) NSDate *timeStarted;

-(NSTimeInterval) timeLeft;
-(OtherUser *) getPartner;

@end
