//
//  ConcurrentOperation.h
//  Refresher-OBJC
//
//  Created by       on 9/5/16.
//  Copyright © 2016        Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkOperationDelegate.h"

@interface ConcurrentOperation : NSOperation
{
    BOOL        executing;
    BOOL        finished;
}
@property (nonatomic, assign) id <NetworkOperationDelegate>delegate;

- (id)initWithRootURL:(NSURL *)url;
- (void)completeOperation;
@end
