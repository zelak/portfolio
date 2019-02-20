//
//  ThemeManager.h
//  Polite
//
//  Created by Andre Mauricio Zelak on 01/07/13.
//  Copyright (c) 2013 PoliteApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeManager : NSObject

@property (nonatomic,retain) NSDictionary* styles;
@property (nonatomic) CGFloat iphoneHeight;

+ (ThemeManager*)sharedManager;

// Interface methods
// with key
- (NSInteger)integerValue:(NSString*)key;
- (CGFloat)floatValue:(NSString*)key;
// with object name
- (CGRect)frame:(NSString*)object;
- (NSString*)title:(NSString*)object;
- (UIColor *)color:(NSString*)object;
- (UIImage *)image:(NSString*)object;
- (CGFloat)getiPhoneHeight;

@end
