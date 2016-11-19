//
//  UIWebViewController.m
//  MasterRefresher
//
//  Created by   on 05/04/16.
//  Copyright © 2016    Inc. All rights reserved.
//

/*
 
 Reference:
 Creating a webview programmatically
 http://stackoverflow.com/questions/8310109/create-a-uiwebview-and-load-a-website-programmically
 */

#import "WebViewRemoteLoadViewController.h"

@interface WebViewRemoteLoadViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation WebViewRemoteLoadViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.activityIndicator startAnimating];
    self.webView.hidden=YES;
    NSString *urlAddress = @"http://www.apple.com";
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    self.webView.delegate=self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.webView.hidden=NO;
    [self.activityIndicator stopAnimating];
}
- (void)viewDidLayoutSubviews {
    self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}
@end
