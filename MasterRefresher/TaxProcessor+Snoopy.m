//
//  TaxProcessor+Snoopy.m
//  Refresher-OBJC
//
//  Created by      on 8/30/16.
//  Copyright © 2016     Inc. All rights reserved.
//

#import "TaxProcessor+Snoopy.h"
#import <objc/message.h>

@implementation TaxProcessor (Snoopy)

// Swizzling should always be done in +load.
+ (void)load {
    // Swizzling should always be done in a dispatch_once.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [TaxProcessor class];
        SEL originalSelector = @selector(sendTaxReturnToBank:);
        SEL swizzledSelector = @selector(watch_sendTaxReturnToBank:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
    
}

-(void) watch_sendTaxReturnToBank:(NSString*)income{
    // It may appear that the following code will result in an infinite loop.
    // In the process of swizzling, watch_sendTaxReturnToBank: has been reassigned to the original implementation of TaxProcessor -sendTaxReturnToBank:.
    [self watch_sendTaxReturnToBank:income];
    if ([income integerValue] > 1000) {
        NSLog(@"Looks like a tax evader. Agency alerted!");
    }
}
@end
