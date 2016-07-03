//
//  UIWebViewController.m
//  MasterRefresher
//
//  Created by Aneesh on 05/04/16.
//  Copyright © 2016 Ammini Inc. All rights reserved.
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
    //UIWebView *tempWebview = [[UIWebView alloc]initWithFrame:theFrame];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
