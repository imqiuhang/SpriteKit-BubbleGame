//
//  UIColor+ColorExtension.h
//  Framework
//
//  Created by imqiuhang on 16/4/3.
//  Copyright © 2016年 imqiuhang. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

FOUNDATION_EXPORT UIColor* ColorWithRGBA(CGFloat r, CGFloat g, CGFloat b,CGFloat a);
FOUNDATION_EXPORT UIColor* ColorWithRGB(CGFloat r, CGFloat g, CGFloat b);
FOUNDATION_EXPORT UIColor* colorWithHexString(NSString *color);
FOUNDATION_EXPORT UIColor* colorWithHexStringAndAlpha(NSString *color ,float alpha);

@interface UIColor (ColorExtension)

#pragma mark - UIColor Create
+ (UIColor *) colorWithHexString: (NSString *)color;
+ (UIColor *) colorWithHexString: (NSString *)color alpha:(float)alpha;
+ (UIColor *) colorWithCyan:(CGFloat)cyan
                   magenta:(CGFloat)magenta
                    yellow:(CGFloat)yellow
                     black:(CGFloat)black
                     alpha:(CGFloat)alpha;///CMYK-A

+ (UIColor *)randomColor;

#pragma mark - color info  get
- (NSString *)hexString;///@"0066cc"
- (NSString *)hexStringWithAlpha;///@"0066ccff".
- (uint32_t)rgbValue;///0x66ccffff
- (uint32_t)rgbaValue;///0x66ccffff
- (NSString *)rgbaDescription;///@return String @"R:100,G100,B200,A:0.3"

///RGBA Value
@property (nonatomic, readonly) CGFloat red;
@property (nonatomic, readonly) CGFloat green;
@property (nonatomic, readonly) CGFloat blue;
@property (nonatomic, readonly) CGFloat alpha;

@end






