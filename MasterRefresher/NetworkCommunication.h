//
//  NeworkCommunication.h
//  Refresher-OBJC
//
//  Created by   on 9/5/16.
//  Copyright © 2016    Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NonConCurrentOperationDelegate.h"

@interface NetworkCommunication : NSObject
@property (nonatomic, assign) id <NonConCurrentOperationDelegate>delegate;
@property (nonatomic, retain) NSURL *urlToLoad;
- (id)initWithRootURL:(NSURL *)url;
- (void)startAsyncDownload;
- (void)startSyncDownload;

@end
