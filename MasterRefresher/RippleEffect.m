//
//  RippleEffect.m
//  AudioBook
//
//  Created by on 6/16/16.
//  Copyright © 2016 . All rights reserved.
//

#import "RippleEffect.h"
#import <UIKit/UIKit.h>




// macro from https://gist.github.com/uechi/7688152
//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

// Usage
// UIColorFromRGB(0xCECECE);
// UIColorFromRGBWithAlpha(0xCECECE, 0.8);

@interface RippleEffect ()
@property (nonatomic, strong) NSArray *colors;
@end

@implementation RippleEffect

- (UIColor *)randomColor
{
    if (!_colors) {
        _colors = @[
                    UIColorFromRGB(0xff7f7f),
                    UIColorFromRGB(0xff7fbf),
                    UIColorFromRGB(0xff7fff),
                    UIColorFromRGB(0xbf7fff),
                    UIColorFromRGB(0x7f7fff),
                    UIColorFromRGB(0x7fbfff),
                    UIColorFromRGB(0x7fffff),
                    UIColorFromRGB(0x7fffbf),
                    UIColorFromRGB(0x7fff7f),
                    UIColorFromRGB(0xbfff7f),
                    UIColorFromRGB(0xffff7f),
                    UIColorFromRGB(0xffbf7f)
                    ];
    }
    
    NSInteger count = _colors.count;
    NSInteger r = arc4random() % count;
    return _colors[r];
}

+ (void)rippleWithView:(UIView *)view center:(CGPoint)center  colorFrom:(UIColor *)colorFrom colorTo:(UIColor *)colorTo
{
    if (!view) {
        return;
    }
    CGFloat radius = 40.0f;
    UIView *ripple = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, radius, radius)];
    ripple.layer.cornerRadius = radius * 0.5f;
    ripple.backgroundColor = colorFrom;
    ripple.alpha = 1.0f;
    [view insertSubview:ripple atIndex:0];
    ripple.center = center;
    CGFloat scale = 8.0f;
    [UIView animateWithDuration:0.6f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        ripple.transform = CGAffineTransformMakeScale(scale, scale);
        ripple.alpha = 0.0f;
        ripple.backgroundColor = colorTo;
    } completion:^(BOOL finished) {
        [ripple removeFromSuperview];
    }];
}

// Usage
// [self rippleWithView:view center:view.center colorFrom:[self randomColor] colorTo:[self randomColor]];

@end
