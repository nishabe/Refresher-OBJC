//
//  NeworkCommunication.h
//  Refresher-OBJC
//
//  Created by   on 9/5/16.
//  Copyright © 2016    Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkOperationDelegate.h"

@interface NetworkCommunication : NSObject <NSURLSessionDelegate>
@property (nonatomic, assign) id <NetworkOperationDelegate>delegate;
@property (nonatomic, retain) NSURL *urlToLoad;
@property (nonatomic, retain) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, retain) NSURLSessionUploadTask *uploadTask;


- (id)initWithRootURL:(NSURL *)url;
- (void)startSyncDownload;
- (void)startAsyncDownloadWithDelegate;
- (void)startAsyncDownloadWithBlock;
- (void)startDataTask;
- (void)startImageDownloadTask;
- (void)startFileDownloadTask;
- (void)startBackgroundFileDownloadTask;
- (void)startFileUploadTask;


-(void)pauseDownloadTask;
-(void)cancelDownloadTask;

@end
