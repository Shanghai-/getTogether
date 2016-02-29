//
//  Session.m
//  getTogether
//
//  Created by Brendan Walsh  on 9/30/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import "Session.h"

@implementation Session

-(id) init {
    self = [super init];
    if (self) {
        self.timeStarted = [NSDate date];
        self.partner = [[OtherUser alloc] init];
        return self;
    }
    return nil;
}

-(NSTimeInterval) timeLeft {
    NSDate *now = [NSDate date];
    NSTimeInterval time = [now timeIntervalSinceDate:self.timeStarted];
    return time;
}

-(OtherUser *) getPartner {
    return self.partner;
}

@end
