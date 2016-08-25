//
//  BlockTester.m
//  Refresher-OBJC
//
//  Created by on 8/24/16.
//  Copyright © 2016    Inc. All rights reserved.
//

#import "BlockTester.h"

// Typedefing blocks
typedef void (^MyBlockType)(id, NSUInteger, BOOL *);

@interface BlockTester ()
@property (nonatomic,copy) MyBlockType block;
@end

@implementation BlockTester
-(void)runTests{
    
    // 1. Creating a block
    void (^MyBlock) (id,NSUInteger,BOOL*) = ^ (id object,NSUInteger index, BOOL*stop){
        NSLog(@"The name is %@.",(NSString*)object);
    };
    // 1.1 Calling a block
    BOOL stop;
    MyBlock(@"AA",0,&stop);
    
    // 2. Passing block to a method
    NSArray* names = @[@"BB",@"CC",@"DD",@"EE"];
    [names enumerateObjectsUsingBlock:MyBlock];
    
    // 3. 1) Using block inline 2) read a local varibale 3) Update a local variable which is prefixed with __block Syntax
    NSString* sampleName = @"DD";
    __block int count = 0;
    [names enumerateObjectsUsingBlock:^ (id object,NSUInteger index, BOOL*stop){
        if ([sampleName isEqualToString:(NSString *)object]) {
            NSLog(@"Matched!");
        }
        NSLog(@"The name is %@.",(NSString*)object);
        count++;
    }];
    NSLog(@"The total count is: %d",count);
    // 4. Pass a block as a parameter to method.
    // May resukt in retain cycle
    //[self doSomething:MyBlock];
    [self doSomething:^(id object, NSUInteger index, BOOL *stop){
        //[self logDone]; // This will result in strong reference
        __weak BlockTester *weakSelf = self;
        [weakSelf logDone];
    }];
    
}
-(void)logDone{
    NSLog(@"Done");
}
-(void)doSomething:(MyBlockType)block{
    self.block = block;
    [self performSelector:@selector(afterOneSecond) withObject:self afterDelay:1.0];
}
-(void)afterOneSecond{
    BOOL stop;
    self.block(@"FF",0,&stop);
}
- (void)dealloc{
    NSLog(@"deallocated");
}
@end
