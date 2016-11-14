//
//  NonConCurrentOperationDelegate.h
//  Refresher-OBJC
//
//  Created by       on 9/5/16.
//  Copyright © 2016        Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkOperationDelegate <NSObject>
@optional
- (void)didFinishLoad:(NSDictionary *)info;
- (void)didFinishImageDownload:(NSDictionary *)info;
- (void)didFinishFileDownload:(NSDictionary *)info;
- (void)showDownloadProgress:(float)progress;
- (void)showFile:(NSString*)path;
- (void)showUploadProgress:(float)progress;
- (void)didRecieveResponse:(NSDictionary *)info;
@end
