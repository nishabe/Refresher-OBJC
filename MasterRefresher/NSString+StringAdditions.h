//
//  NSString+StringAdditions.h
//  Refresher-OBJC
//
//  Copyright © 2016 Ammini Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// The syntax to declare a category uses the @interface keyword, just like a standard Objective-C class description, but does not indicate any inheritance from a subclass. Instead, it specifies the name of the category in parentheses

@interface NSString (StringAdditions)

+(NSString *)getCopyRightString;

@end
