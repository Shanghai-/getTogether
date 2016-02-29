//
//  GTImageHandler.m
//  getTogether
//
//  Created by Brendan Walsh  on 10/13/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import "GTImageHandler.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation GTImageHandler

+(UIImage *) markerImageWithAvatar:(UIImage *)avatar Color:(UIColor *)color {
    UIImage *baseMarker = [GMSMarker markerImageWithColor:color];
    UIImage *resizedAvatar = [GTImageHandler resizeImage:avatar newSize:CGSizeMake(18.5, 18.5)];
    
    CGImageRef avatarImage = resizedAvatar.CGImage;
    CGImageRef maskImage = [UIImage imageNamed:@"markerMask"].CGImage;
    CGRect markerRect = CGRectMake(0, 0, baseMarker.size.width, baseMarker.size.height);
    CGRect avatarRect = CGRectMake(1.5, 2.5, 18.5, 18.5);
    
    UIGraphicsBeginImageContextWithOptions(baseMarker.size, NO, 0.0);
    [baseMarker drawInRect:markerRect];
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskImage),
                                        CGImageGetHeight(maskImage),
                                        CGImageGetBitsPerComponent(maskImage),
                                        CGImageGetBitsPerPixel(maskImage),
                                        CGImageGetBytesPerRow(maskImage),
                                        CGImageGetDataProvider(maskImage), NULL, false);
    
    CGImageRef maskedAvatar = CGImageCreateWithMask(avatarImage, mask);
    UIImage *maskedAv = [UIImage imageWithCGImage:maskedAvatar];
    CGImageRelease(mask);
    CGImageRelease(maskedAvatar);
    
    [maskedAv drawInRect:avatarRect];
    
    UIImage *customMarker = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return customMarker;
}

+(UIImage *) avatarWithImage:(UIImage *)img size:(CGSize)box {
    UIImage *resizedAvatar = [GTImageHandler resizeImage:img newSize:box];
    
    CGImageRef avatarImage = resizedAvatar.CGImage;
    CGImageRef maskImage = [UIImage imageNamed:@"avatarMask"].CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskImage),
                                        CGImageGetHeight(maskImage),
                                        CGImageGetBitsPerComponent(maskImage),
                                        CGImageGetBitsPerPixel(maskImage),
                                        CGImageGetBytesPerRow(maskImage),
                                        CGImageGetDataProvider(maskImage), NULL, false);

    CGImageRef maskedAvatar = CGImageCreateWithMask(avatarImage, mask);
    
    //Release all the remaining images
    CGImageRelease(avatarImage);
    CGImageRelease(maskImage);
    CGImageRelease(mask);
    
    return [UIImage imageWithCGImage:maskedAvatar];
}

/*-(UIImage *) circularImage:(UIImage *)img {
    UIGraphicsBeginImageContextWithOptions(img.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, 37, 37);
    [[UIColor blackColor] setFill];
    CGContextFillEllipseInRect(context, rect);
    CGContextClip(context);
    //CGContextDrawImage(context, rect, refImg);
    UIGraphicsEndImageContext();
    return img;
}*/

+ (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    NSLog(@"Rescaling image...");
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
