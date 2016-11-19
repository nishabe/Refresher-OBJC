//
//  HTMLViewController.m
//  VideoPlayer
//
//  Created by on 11/17/16.
//  Copyright © 2016 ABC. All rights reserved.
//

#import "HTMLViewController.h"

@interface HTMLViewController()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation HTMLViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"html5Video" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlString baseURL:nil];
}
- (void)viewDidLayoutSubviews {
    self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}
@end
