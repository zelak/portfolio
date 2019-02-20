//
//  UIImage+Mask.m
//  Polite
//
//  Created by Andre Mauricio Zelak on 10/07/13.
//  Copyright (c) 2013 PoliteApp. All rights reserved.
//

#import "UIImage+Mask.h"

@implementation UIImage (Mask)

+ (UIImage *)image:(UIImage*)image withMask:(UIImage *)maskImage
{
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    return [UIImage imageWithCGImage:masked];
}

+ (UIImage *)imageNamed:(NSString *)name withMask:(UIImage *)maskImage
{
    UIImage *image = [UIImage imageNamed:name];
    
    return [UIImage image:image withMask:maskImage];
}

@end
