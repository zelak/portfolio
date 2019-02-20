//
//  ThemeManager.m
//  Polite
//
//  Created by Andre Mauricio Zelak on 01/07/13.
//  Copyright (c) 2013 PoliteApp. All rights reserved.
//

#import "ThemeManager.h"
#import "ColorUtils.h"

#define IPHONE5_MODEL 1
#define IPHONE4_MODEL 0

@implementation ThemeManager

@synthesize styles;
@synthesize iphoneHeight;

- (id)init
{
    if ((self = [super init])) {
        NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
        NSString       *themeName = [defaults objectForKey:@"theme"] ? : @"theme";
        NSString       *path      = [[NSBundle mainBundle] pathForResource:themeName ofType:@"plist"];
        self.styles = [NSDictionary dictionaryWithContentsOfFile:path];
        // store iPhone screen height
        iphoneHeight = [UIScreen mainScreen].bounds.size.height;
    }
    return self;
}

+ (ThemeManager*)sharedManager
{
    static ThemeManager *sharedManager = nil;
    if (sharedManager == nil)
    {
        sharedManager = [[ThemeManager alloc] init];
    }
    return sharedManager;
}

- (NSInteger)integerValue:(NSString*)key
{
    return [[styles valueForKey:key] integerValue];
}

- (CGFloat)floatValue:(NSString*)key
{
    return [[styles valueForKey:key] floatValue];
}

- (CGRect)frame:(NSString*)object
{
    return CGRectMake(
            [self floatValue:[NSString stringWithFormat:@"%@OriginX", object]],
            [self floatValue:[NSString stringWithFormat:@"%@OriginY", object]],
            [self floatValue:[NSString stringWithFormat:@"%@Width",   object]],
            [self floatValue:[NSString stringWithFormat:@"%@Height",  object]]);
}

- (NSString*)title:(NSString*)object
{
    return [styles valueForKey:[NSString stringWithFormat:@"%@Title", object]];
}

- (UIColor *)color:(NSString*)object
{
    NSString *string = [styles valueForKey:[NSString stringWithFormat:@"%@Color", object]];
    return [UIColor colorWithString:string];
}

- (UIImage *)image:(NSString*)object
{
    NSString *string = [styles valueForKey:[NSString stringWithFormat:@"%@Image", object]];
    return [UIImage imageNamed:string];
}

- (CGFloat)getiPhoneHeight
{
    return iphoneHeight;
}

@end
