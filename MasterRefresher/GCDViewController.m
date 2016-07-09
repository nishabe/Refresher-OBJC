//
//  GCDViewController.m
//  Refresher-OBJC
//
//  Created by Aneesh Abraham01 on 7/9/16.
//  Copyright © 2016 Ammini Inc. All rights reserved.
//

#import "GCDViewController.h"

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
                 @"http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg",
                 @"http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg",
                 @"http://algoos.com/wp-content/uploads/2015/08/ireland-02.jpg",
                 @"http://bdo.se/wp-content/uploads/2014/01/Stockholm1.jpg"
                 , nil];
    imageViews = [NSArray arrayWithObjects:imageView1,imageView2,imageView3,imageView4, nil];
}

@end



