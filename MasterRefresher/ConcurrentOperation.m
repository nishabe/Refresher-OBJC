//
//  ConcurrentOperation.m
//  Refresher-OBJC
//
//  Created by       on 9/5/16.
//  Copyright © 2016        Inc. All rights reserved.
//
// References:
/*
 https://developer.apple.com/library/mac/documentation/General/Conceptual/ConcurrencyProgrammingGuide/OperationObjects/OperationObjects.html
 
 */
#import "ConcurrentOperation.h"
#import <UIKit/UIKit.h>


@interface ConcurrentOperation ()
@property (nonatomic, strong) NSURL *rootURL;
@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;
@end

@implementation ConcurrentOperation

- (id)init {
    self = [super init];
    if (self) {
        executing = NO;
        finished = NO;
    }
    return self;
}
- (id)initWithRootURL:(NSURL *)url
{
    self = [super init];
    if (self)
    {
        self.rootURL = url;
    }
    return self;
}
//isConcurrent in ios<8
- (BOOL)isAsynchronous {
    return YES;
}

- (BOOL)isExecuting {
    return executing;
}

- (BOOL)isFinished {
    return finished;
}

- (void)start {
    // Always check for cancellation before launching the task.
    if ([self isCancelled])
    {
        // Must move the operation to the finished state if it is canceled.
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    // If the operation is not canceled, begin executing the task.
    /*
      In this case, the method simply starts up a new thread and configures it to call the main method. The method also updates the executing member variable and generates KVO notifications for the isExecuting key path to reflect the change in that value. With its work done, this method then simply returns, leaving the newly detached thread to perform the actual task.
     */
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)main {
    @try {
        if(self.cancelled) {
            return;
        }
        else{
            // Do the main work of the operation here.
            {
                
                // Execute your long task here. The task will execute in background task for you
                // As a suggestion, check the cancelled property
                // in order to rollback an invalid state introduced by the operation
                
                if(self.cancelled) {
                    return;
                }
                else{
                    NSURLRequest *request = [NSURLRequest requestWithURL:self.rootURL];
                    // create an session data task to obtain and download the app icon
                    self.sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        // in case we want to know the response status code
                        //NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
                        if (error != nil)
                        {
                            if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection)
                            {
                                // if you get error NSURLErrorAppTransportSecurityRequiresSecureConnection (-1022),
                                // then your Info.plist has not been properly configured to match the target server.
                                //
                                abort();
                            }
                        }
                        UIImage *image = [[UIImage alloc] initWithData:data];
                        if (image) {
                            NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:image, @"image", _rootURL, @"url", nil];
                            if([_delegate respondsToSelector:@selector(didFinishLoad:)]) {
                                [_delegate performSelector:@selector(didFinishLoad:) withObject:info];
                                [self completeOperation];
                            }
                        }
                    }];
                    [self.sessionTask resume];
                }
            }
        }
    }
    @catch(...) {
        // Do not rethrow exceptions.
    }
}

- (void)completeOperation {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = NO;
    finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end
