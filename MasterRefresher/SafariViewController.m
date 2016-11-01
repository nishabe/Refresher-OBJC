//
//  SafariViewController.m
//  Refresher-OBJC
//
//  Created by   on 11/1/16.
//  Copyright © 2016   All rights reserved.
// Ref: http://stackoverflow.com/questions/34233159/how-do-i-use-the-safariviewcontroller-in-objective-c

#import "SafariViewController.h"
#import <SafariServices/SafariServices.h>

@interface SafariViewController () <SFSafariViewControllerDelegate>

@end

@implementation SafariViewController

#pragma marks UX handling

- (IBAction)openWebPage:(id)sender {
    SFSafariViewController *svc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://apple.com"]];
    svc.delegate = self;
    [self presentViewController:svc animated:YES completion:nil];
}

#pragma mark Handling SFSafariViewControllerDelegate methods

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
