//
//  NeworkCommunication.m
//  Refresher-OBJC
//
//  Created by   on 9/5/16.
//  Copyright © 2016    Inc. All rights reserved.
//

#import "NetworkCommunication.h"
#import <UIKit/UIKit.h>

@interface NetworkCommunication ()
{
    NSURLConnection *_connection;
    NSMutableData   *_responseData;
}
@end
@implementation NetworkCommunication

- (id)initWithRootURL:(NSURL *)url
{
    self = [super init];
    if (self)
    {
        self.urlToLoad = url;
    }
    return self;
}

- (void)startDownload
{
    // Below is an example to suppress a compiler warning.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    // NSURLConnection sendAsynchronousRequest is depracted. Added below just for reference purpose. Suggested to use NSURLSession.
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.urlToLoad cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    if(_connection) {
        _responseData = [[NSMutableData alloc] init];
    }
#pragma clang diagnostic pop

}

- (void)finish {
    _connection = nil;
    _responseData = nil;
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [_responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"Connection failed! Error - %@",
          [error localizedDescription]);
    [self finish];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    UIImage *image = [[UIImage alloc] initWithData:_responseData];
    if (image) {
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:image, @"image", _urlToLoad, @"url", nil];
        if([_delegate respondsToSelector:@selector(didFinishLoad:)]) {
            [_delegate performSelector:@selector(didFinishLoad:) withObject:info];
        }
        [self finish];
    }
}
- (void)startSyncDownload{
    // Send a synchronous request
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:self.urlToLoad];
    NSURLResponse * response = nil;
    NSError * error = nil;
    
    _responseData = (NSMutableData*)[NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    if (error == nil)
    {
        // Parse data here
        UIImage *image = [[UIImage alloc] initWithData:_responseData];
        if (image) {
            NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:image, @"image", _urlToLoad, @"url", nil];
            if([_delegate respondsToSelector:@selector(didFinishLoad:)]) {
                [_delegate performSelector:@selector(didFinishLoad:) withObject:info];
            }
            [self finish];
        }
    }
}

@end
