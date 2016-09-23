//
//  NetworkCommunicationViewController.m
//  Refresher-OBJC
//
//  Created by   on 9/5/16.
//  Copyright © 2016    Inc. All rights reserved.
//

/*
 References:
 http://codewithchris.com/tutorial-how-to-use-ios-nsurlconnection-by-example/#synchronous
 https://code.tutsplus.com/tutorials/networking-with-nsurlsession-part-1--mobile-21394
 http://sweettutos.com/2014/09/16/how-you-would-use-nsurlsession-to-download-files/
 http://hayageek.com/ios-nsurlsession-example/
 */
#import "NetworkCommunicationViewController.h"
#import "NetworkCommunication.h"
#import "RefresherConstants.h"

#define SCROLL_HEIGHT 200
#define SERVRER_IP @"10.155.111.5"
#define SERVER_PORT @"42001"

@interface NetworkCommunicationViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgressIndicator;
@property (weak, nonatomic) IBOutlet UIProgressView *uploadProgressIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (retain,nonatomic) NetworkCommunication *networkCommunication;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation NetworkCommunicationViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.downloadProgressIndicator setProgress:0 animated:NO];
    [self.uploadProgressIndicator setProgress:0 animated:NO];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+SCROLL_HEIGHT);

}

- (IBAction)didTapOnSyncronousButton:(id)sender {
    self.networkCommunication = [[NetworkCommunication alloc]initWithRootURL:[NSURL URLWithString:SAMPLE_IMAGE_URL1]];
    self.networkCommunication.delegate = self;
    [self.networkCommunication startSyncDownload];
}

- (IBAction)didTapOnAsyncronousWithDelegateButton:(id)sender {
    self.networkCommunication = [[NetworkCommunication alloc]initWithRootURL:[NSURL URLWithString:SAMPLE_IMAGE_URL1]];
    self.networkCommunication.delegate = self;
    [self.networkCommunication startAsyncDownloadWithDelegate];
}

- (IBAction)didTapOnAsyncronousWithCallbackButton:(id)sender {
    self.networkCommunication = [[NetworkCommunication alloc]initWithRootURL:[NSURL URLWithString:SAMPLE_IMAGE_URL1]];
    self.networkCommunication.delegate = self;
    [self.networkCommunication startAsyncDownloadWithDelegate];
}

# pragma mark - delegate methods

- (void)didFinishLoad:(NSDictionary *)info
{
    // Parse data here
    UIImage *image = [[UIImage alloc] initWithData:[info valueForKey:@"data"]];
    if (image) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.imageView.image = image;
        }];
        NSLog(@"image downloaded");
    }
}
- (void)didFinishImageDownload:(NSDictionary *)info{
        UIImage *image = [[UIImage alloc] initWithData:[info valueForKey:@"data"]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.imageView.image = image;
        }];
}
- (void)didFinishFileDownload:(NSDictionary *)info{
    
}
#pragma mark NSURLSession Methods

- (IBAction)didTapDatatask:(id)sender {
    self.networkCommunication = [[NetworkCommunication alloc]initWithRootURL:[NSURL URLWithString:APPLE_ITUNES_URL]];
    self.networkCommunication.delegate = self;
    [self.networkCommunication startDataTask];
}
- (IBAction)didTapImageDownloadTask:(id)sender {
    self.networkCommunication = [[NetworkCommunication alloc]initWithRootURL:[NSURL URLWithString:SAMPLE_IMAGE_URL4]];
    self.networkCommunication.delegate = self;
    [self.networkCommunication startImageDownloadTask];
}
- (IBAction)didTapFileDownloadTask:(id)sender {
    self.networkCommunication = [[NetworkCommunication alloc]initWithRootURL:[NSURL URLWithString:FILE_DOWNLOAD_URL_2]];
    self.networkCommunication.delegate = self;
    [self.networkCommunication startFileDownloadTask];
}

- (IBAction)didTapOnBGFileDownloadStartButton:(id)sender {
    self.networkCommunication = [[NetworkCommunication alloc]initWithRootURL:[NSURL URLWithString:FILE_DOWNLOAD_URL_3]];
    self.networkCommunication.delegate = self;
    [self.networkCommunication startBackgroundFileDownloadTask];
    [self.networkCommunication.downloadTask resume];
    [self.downloadProgressIndicator setProgress:0 animated:NO];
}
- (IBAction)didTapOnBGFileDownloadResumeButton:(id)sender {
    if (self.networkCommunication) {
        [self.networkCommunication.downloadTask resume];
    }
}
- (IBAction)didTapOnBGFileDownloadCancelButton:(id)sender {
    if (self.networkCommunication) {
        [self.networkCommunication.downloadTask cancel];
    }
}
- (IBAction)didTapFileUpload:(id)sender {
    /*
     1. Find your server IP/name and replace the macro definition on top.
     2. Run postserver.py script after updating the server IP/name (Line #73,postserver.py)
     3.Run this source code only after performing the above two steps
     */
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@", SERVRER_IP, SERVER_PORT]];
    self.networkCommunication = [[NetworkCommunication alloc]initWithRootURL:url];
    self.networkCommunication.delegate = self;
    [self.networkCommunication startFileUploadTask];
    [self.uploadProgressIndicator setProgress:0 animated:NO];
}

- (void)showDownloadProgress:(float)progress{
    [self.downloadProgressIndicator setProgress:progress
                          animated:YES];
}

- (void)showFile:(NSString*)path{
    // Check if the file exists
    BOOL isFound = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (isFound) {
        
        UIDocumentInteractionController *viewer = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:path]];
        viewer.delegate = self;
        [viewer presentPreviewAnimated:YES];
    }
}
- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller{
    return self;
}

- (void)showUploadProgress:(float)progress{
    [self.uploadProgressIndicator setProgress:progress
                                       animated:YES];
}
@end
