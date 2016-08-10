//
//  Logger.h
//  Refresher-OBJC
//
//  Copyright © 2016 Ammini Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Logger : NSObject

@property(nonatomic, assign) NSString* aText;
@property (strong, nonatomic) NSMutableArray *aCollection;
@property (assign) int aNumber;

#pragma mark -
#pragma mark Class Methods
+ (Logger *)sharedLogger;
- (NSString *)getRandomString;

@end
