//
//  RippleEffect.h
//  AudioBook
//
//  Created by on 6/16/16.
//  Copyright © 2016. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RippleEffect : NSObject
+ (void)rippleWithView:(UIView *)view center:(CGPoint)center  colorFrom:(UIColor *)colorFrom colorTo:(UIColor *)colorTo;
@end
