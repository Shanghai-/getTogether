//
//  GTImageHandler.h
//  getTogether
//
//  Created by Brendan Walsh  on 10/13/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface GTImageHandler : NSObject

+(UIImage *) markerImageWithAvatar:(UIImage *)avatar Color:(UIColor *)color;
+(UIImage *) avatarWithImage:(UIImage *)img boundingBox:(CGSize)box;
+(UIImage *) resizeImage:(UIImage*)image newSize:(CGSize)newSize;

@end
