//
//  GCDViewController.m
//  Refresher-OBJC
//
//  Created by     on 7/9/16.
//  Copyright © 2016    Inc. All rights reserved.
//

#import "GCDViewController.h"
#import "RefresherConstants.h"

@interface Downloader : NSObject
+(UIImage*) downloadImageWithURL: (NSString*) url;
@end
@implementation Downloader
+(UIImage*) downloadImageWithURL: (NSString*) url{
    NSError* error = nil;
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:NSDataReadingUncached error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        NSLog(@"Data has loaded successfully.");
    }
    return [UIImage imageWithData:data];
}
@end
@implementation GCDViewController
{
    NSArray *imageViews;
    NSArray *imageURLs;
    __weak IBOutlet UIImageView *imageView1;
    
    __weak IBOutlet UIImageView *imageView2;
    
    __weak IBOutlet UIImageView *imageView3;
    
    __weak IBOutlet UIImageView *imageView4;
    
    __weak IBOutlet UILabel *sliderValueLabel;
}
- (IBAction)didTapOnSerial:(id)sender {
    dispatch_queue_t serialQueue = dispatch_queue_create("imagesQueue", DISPATCH_QUEUE_SERIAL);
    for(int i = 0; i < imageURLs.count ; i++)
    {
        dispatch_async(serialQueue, ^{
            // Perform long running process
            UIImage* image = [Downloader downloadImageWithURL:imageURLs[i]];
            NSLog(@"%@",image);
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                UIImageView* imageview = (UIImageView*)imageViews[i];
                imageview.image = image;
            });
        });
    }
}

- (IBAction)didTapOnconcurrent:(id)sender {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for(int i = 0; i < imageURLs.count ; i++)
    {
        dispatch_async(queue, ^{
            // Perform long running process
            UIImage* image = [Downloader downloadImageWithURL:imageURLs[i]];
            NSLog(@"%@",image);
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                UIImageView* imageview = (UIImageView*)imageViews[i];
                imageview.image = image;
            });
        });
    }
}

- (IBAction)didTapOnSyncronous:(id)sender {
    
    for(int i = 0; i < imageURLs.count ; i++)
    {
        UIImage* image = [Downloader downloadImageWithURL:imageURLs[i]];
        UIImageView* imageview = (UIImageView*)imageViews[i];
        imageview.image = image;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    imageURLs = [NSArray arrayWithObjects:
                 SAMPLE_IMAGE_URL1,
                 SAMPLE_IMAGE_URL2,
                 SAMPLE_IMAGE_URL3,
                 SAMPLE_IMAGE_URL4
                 , nil];
    imageViews = [NSArray arrayWithObjects:imageView1,imageView2,imageView3,imageView4, nil];
}

@end



