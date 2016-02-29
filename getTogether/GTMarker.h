//
//  GTMarker.h
//  getTogether
//
//  Created by Brendan Walsh  on 10/8/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import <CoreGraphics/CoreGraphics.h>

@interface GTMarker : GMSMarker

@property (weak, nonatomic) NSString *attachedName;
@property (weak, nonatomic) UIColor *assignedColor;

-(id) initWithName:(NSString *)name Color:(UIColor *)color;

@end
