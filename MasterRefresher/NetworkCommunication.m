//
//  NeworkCommunication.m
//  Refresher-OBJC
//
//  Created by   on 9/5/16.
//  Copyright © 2016    Inc. All rights reserved.
//
/*
 Reference:
 http://www.localwisdom.com/blog/2013/07/blocks-in-objective-c-performing-asynchronous-urlrequests-using-an-nsoperationqueue/
 https://github.com/drbobdugan/NSURLSessionUploadTaskExample
 */
#import "NetworkCommunication.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#define BACKGROUND_SESSION_IDENTIFIER_1 @"backgroundDownloadTask1"
#define BACKGROUND_SESSION_IDENTIFIER_2 @"uploadTask1"

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

- (void)startAsyncDownloadWithDelegate
{
    // Suppressing a compiler warning.
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
- (void)startAsyncDownloadWithBlock
{
    // Suppressing a compiler warning.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    // NSURLConnection sendAsynchronousRequest is depracted. Added below just for reference purpose. Suggested to use NSURLSession.
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.urlToLoad cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    // Supported from iOS5
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:operationQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               // Check to make sure there are no errors
                               if (error) {
                                   NSLog(@"Error in updateInfoFromServer: %@ %@", error, [error localizedDescription]);
                               } else if (!response) {
                                   NSLog(@"Could not reach server!");
                               } else if (!data) {
                                   NSLog(@"Server did not return any data!");
                               } else {
                                   if (_responseData.length>0) {
                                       [self callDelegate:_responseData];
                                       [self finish];
                                   }
                               }
                           }];
#pragma clang diagnostic pop
    
}
- (void)startSyncDownload{
    // Send a synchronous request
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:self.urlToLoad];
    NSURLResponse * response = nil;
    NSError * error = nil;
    // Suppressing a compiler warning.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    // UI would be frozen while the synchronous request is doing its thing
    _responseData = (NSMutableData*)[NSURLConnection sendSynchronousRequest:urlRequest
                                                          returningResponse:&response
                                                                      error:&error];
#pragma clang diagnostic pop
    
    if (error == nil)
    {
        if (_responseData.length>0) {
            [self callDelegate:_responseData];
            [self finish];
        }
    }
}
- (void)finish {
    _connection = nil;
    _responseData = nil;
}
-(void)callDelegate:(NSData*)data{
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:data, @"data", _urlToLoad, @"url", nil];
    if([_delegate respondsToSelector:@selector(didFinishLoad:)]) {
        [_delegate performSelector:@selector(didFinishLoad:) withObject:info];
    }
}

-(void)pauseDownloadTask{
    [self.downloadTask suspend];
}
-(void)cancelDownloadTask{
    [self.downloadTask cancel];
}
#pragma mark - NSURLConnection Delegates

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
    if (_responseData.length>0) {
        [self callDelegate:_responseData];
        [self finish];
    }
}

#pragma mark NSURLSession Methods
// NSURLSession supports iOS 7 and above
- (void)startDataTask{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:self.urlToLoad completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@", json);
    }];
    [dataTask resume];
}
- (void)startImageDownloadTask{
    NSURLSessionDownloadTask *downloadPhotoTask = [[NSURLSession sharedSession] downloadTaskWithURL:self.urlToLoad completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData *data = [NSData dataWithContentsOfURL:location];
        if (data.length>0) {
            NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:data, @"data", _urlToLoad, @"url", nil];
            if([_delegate respondsToSelector:@selector(didFinishImageDownload:)]) {
                [_delegate performSelector:@selector(didFinishImageDownload:) withObject:info];
            }
        }
    }];
    [downloadPhotoTask resume];
}

- (void)startFileDownloadTask{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURLSessionDownloadTask * downloadTask =[ defaultSession downloadTaskWithURL:self.urlToLoad];
    [downloadTask resume];
}
- (void)startBackgroundFileDownloadTask{
    NSURLSessionConfiguration * backgroundConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:BACKGROUND_SESSION_IDENTIFIER_1];
    NSURLSession *backgroundSeesion = [NSURLSession sessionWithConfiguration: backgroundConfig delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    self.downloadTask =[ backgroundSeesion downloadTaskWithURL:self.urlToLoad];
    [self.downloadTask resume];
}
- (void)startFileUploadTask{
    if (self.uploadTask.state == NSURLSessionTaskStateRunning) {
        [self.uploadTask cancel];
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:BACKGROUND_SESSION_IDENTIFIER_2];
        NSURLSession *session = [NSURLSession sessionWithConfiguration: configuration delegate:self delegateQueue: [NSOperationQueue mainQueue]];
        NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:self.urlToLoad];
        [urlRequest setHTTPMethod:@"POST"];
        NSString *filePath = [NSString stringWithFormat:@"file://%@", [[NSBundle mainBundle] pathForResource:@"5MB_UPLOAD_FILE" ofType:@"pdf"]];
        self.uploadTask = [session uploadTaskWithRequest:urlRequest fromFile:[NSURL URLWithString:filePath]];
        [self.uploadTask resume];
    }
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    // Find the Documents directory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectoryPath = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *destinationURL;
    NSError *error = nil;
    // File names and handling is different for filedownload task(pdf) and image download task
    if ([session.configuration.identifier isEqualToString:BACKGROUND_SESSION_IDENTIFIER_1]) {
        destinationURL = [NSURL fileURLWithPath:[documentDirectoryPath stringByAppendingPathComponent:@"file.pdf"]];
    }else{
        destinationURL = [NSURL fileURLWithPath:[documentDirectoryPath stringByAppendingPathComponent:@"out.zip"]];
    }
    
    
    if ([fileManager fileExistsAtPath:[destinationURL path]]){
        [fileManager replaceItemAtURL:destinationURL withItemAtURL:destinationURL backupItemName:nil options:NSFileManagerItemReplacementUsingNewMetadataOnly resultingItemURL:nil error:&error];
        if ([session.configuration.identifier isEqualToString:BACKGROUND_SESSION_IDENTIFIER_1]) {
            if([_delegate respondsToSelector:@selector(showFile:)]) {
                [_delegate showFile:[destinationURL path]];
            }
        }else{
            NSLog(@"File is saved to =%@",[destinationURL path]);
        }
        
        
    }else{
        
        if ([fileManager moveItemAtURL:location toURL:destinationURL error:&error]) {
            if ([session.configuration.identifier isEqualToString:BACKGROUND_SESSION_IDENTIFIER_1]) {
                if([_delegate respondsToSelector:@selector(showFile:)]) {
                    [_delegate showFile:[destinationURL path]];
                }
                else{
                    NSLog(@"File is saved to =%@",[destinationURL path]);
                }
            }else{
                // error handling here
            }
        }
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    //You can get progress here
    NSLog(@"Received: %lld bytes (Downloaded: %lld bytes)  Expected: %lld bytes.\n",
          bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    if([_delegate respondsToSelector:@selector(showDownloadProgress:)]) {
        [_delegate showDownloadProgress:(double)totalBytesWritten/(double)totalBytesExpectedToWrite];
    }
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    // Compute progress percentage
    float progress = (float)totalBytesSent / (float)totalBytesExpectedToSend;
    // Send info to console
    NSLog(@"bytesSent = %lld, totalBytesSent: %lld, totalBytesExpectedToSend: %lld, progress %.3f", bytesSent, totalBytesSent, totalBytesExpectedToSend, progress*100);
    if([_delegate respondsToSelector:@selector(showUploadProgress:)]) {
        [_delegate showUploadProgress:progress];
    }
}
@end
