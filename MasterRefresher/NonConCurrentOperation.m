//
//  NonConCurrentOperation.m
//  Refresher-OBJC
//
//  Created by       on 9/5/16.
//  Copyright © 2016        Inc. All rights reserved.
//


/*
 References:
 http://www.cimgf.com/2008/02/16/cocoa-tutorial-    -and-    queue/
 http://www.knowstack.com/concurrency-    queue-grand-central-dispatch/
 http://nshipster.com/    /
 https://www.youtube.com/watch?v=C_AdCxYmWnA
 http://www.dribin.org/dave/blog/archives/2009/05/05/concurrent_operations/
 */

#import "NonConCurrentOperation.h"
#import <UIKit/UIKit.h>

@interface NonConCurrentOperation ()
@property (nonatomic, strong) NSURL *rootURL;
@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;

@end
@implementation NonConCurrentOperation

- (id)initWithRootURL:(NSURL *)url
{
    self = [super init];
    if (self)
    {
        self.rootURL = url;
    }
    return self;
}
-(void)main {
    @try {
        
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
                    }
                }
            }];
            [self.sessionTask resume];
        }
    }
    @catch (NSException *exception) {
        //Handle an exception thrown in the @try block
        NSLog(@"%@",exception.description);
    } @finally {
        // Code that gets executed whether or not an exception is thrown
    }
}

@end
