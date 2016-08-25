//
//  NotificationSample.m
//  Refresher-OBJC
//
//  Copyright © 2016    Inc. All rights reserved.
//

#import "NotificationSample.h"

@implementation NotificationSample
-(void)startLongRunningProcess{
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(completeProcess)  userInfo:nil repeats:NO];
}
-(void)completeProcess{
    NSDictionary *processInformation = [NSDictionary
                            dictionaryWithObjectsAndKeys:[self randomStringWithLength:5],@"Response", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SampleNotification" object:self userInfo:processInformation];
}

-(NSString *) randomStringWithLength: (int) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    return randomString;
}
@end
