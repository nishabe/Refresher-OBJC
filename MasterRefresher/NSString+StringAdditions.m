//
//  NSString+StringAdditions.m
//  Refresher-OBJC
//
//  Copyright © 2016    Inc. All rights reserved.
//

#import "NSString+StringAdditions.h"
// The syntax to declare a category uses the @interface keyword, just like a standard Objective-C class description, but does not indicate any inheritance from a subclass. Instead, it specifies the name of the category in parentheses

@implementation NSString (StringAdditions)

+(NSString *)getCopyRightString{
    return @"Copyright © 2016    Inc. All rights reserved.";
}
@end
