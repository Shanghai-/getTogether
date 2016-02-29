//
//  GTMarker.m
//  getTogether
//
//  Created by Brendan Walsh  on 10/8/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import "GTMarker.h"

@implementation GTMarker {
    UIImageView *_imgView;
}

-(id) init{
    self = [super init];
    if (self) {
        return self;
    }
    return nil;
}

-(id) initWithName:(NSString *)name Color:(UIColor *)color {
    self = [self init];
    if (self) {
        self.attachedName = name;
        self.assignedColor = color;
        [self setFlat:YES];
        UIImage *img = [UIImage imageNamed:@"marker_self"];
        //UIImage *img = [UIImage imageNamed:@"GTMarkerTest"];
        [self setIcon:img];
        
        UIGraphicsBeginImageContextWithOptions (img.size, NO, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(context, 0, img.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
        
        // draw tint color
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        [color setFill];
        CGContextFillRect(context, rect);
        
        // draw black background to preserve color of transparent pixels
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        [[UIColor blackColor] setFill];
        CGContextFillRect(context, rect);
        
        // draw original image
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        CGContextDrawImage(context, rect, img.CGImage);
        
        // tint image (loosing alpha) - the luminosity of the original image is preserved
        CGContextSetBlendMode(context, kCGBlendModeColor);
        [color setFill];
        CGContextFillRect(context, rect);
        
        // mask by alpha values of original image
        CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
        CGContextDrawImage(context, rect, img.CGImage);
        
        UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self setIcon:coloredImage];
        
        [self setTitle:self.attachedName];
        return self;
    }
    return nil;
}

@end
