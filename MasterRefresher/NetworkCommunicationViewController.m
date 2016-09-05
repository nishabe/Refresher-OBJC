//
//  NetworkCommunicationViewController.m
//  Refresher-OBJC
//
//  Created by   on 9/5/16.
//  Copyright © 2016    Inc. All rights reserved.
//

#import "NetworkCommunicationViewController.h"
#import "NetworkCommunication.h"
#import "RefresherConstants.h"

@interface NetworkCommunicationViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation NetworkCommunicationViewController
- (IBAction)didTapOnAsyncronousButton:(id)sender {
    NetworkCommunication* networkCommunication = [[NetworkCommunication alloc]initWithRootURL:[NSURL URLWithString:SAMPLE_IMAGE_URL1]];
    networkCommunication.delegate = self;
    [networkCommunication startAsyncDownload];
}
- (IBAction)didTapOnSyncronousButton:(id)sender {
    NetworkCommunication* networkCommunication = [[NetworkCommunication alloc]initWithRootURL:[NSURL URLWithString:SAMPLE_IMAGE_URL1]];
    networkCommunication.delegate = self;
    [networkCommunication startSyncDownload];
}

# pragma mark - delegate methods

- (void)didFinishLoad:(NSDictionary *)info
{
    NSLog(@"image downloaded");
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.imageView.image = [info valueForKey:@"image"];
    }];
}
@end
