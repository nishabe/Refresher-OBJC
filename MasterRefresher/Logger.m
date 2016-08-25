//
//  Logger.m
//  Refresher-OBJC
//
//  Copyright © 2016    Inc. All rights reserved.
//

#import "Logger.h"

@implementation Logger

#pragma mark -
#pragma mark Class Methods
+ (Logger *)sharedLogger {
    // A static variable _sharedInstance that will hold a reference to the singleton object.
    static Logger *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    //The dispatch_once function ensures that the block we pass it is executed once for the lifetime of the application.
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (NSString *)getRandomString{
    return [[NSUUID UUID] UUIDString];
}

@end
