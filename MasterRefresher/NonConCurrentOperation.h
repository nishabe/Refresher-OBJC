//
//  NonConCurrentOperation.h
//  Refresher-OBJC
//
//  Created by       on 9/5/16.
//  Copyright © 2016        Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NonConCurrentOperationDelegate.h"

@interface NonConCurrentOperation : NSOperation
- (id)initWithRootURL:(NSURL *)url;

@property (nonatomic, assign) id <NonConCurrentOperationDelegate>delegate;

@end
