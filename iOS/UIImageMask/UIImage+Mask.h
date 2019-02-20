//
//  UIImage+Mask.h
//  Polite
//
//  Created by Andre Mauricio Zelak on 10/07/13.
//  Copyright (c) 2013 PoliteApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Mask)

+ (UIImage *)image:(UIImage*)image withMask:(UIImage *)maskImage;
+ (UIImage *)imageNamed:(NSString *)name withMask:(UIImage *)maskImage;

@end
