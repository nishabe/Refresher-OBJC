//
//  PinchZoomViewController.m
//  Refresher-OBJC
//
//  Created by Aneesh Abraham01 on 10/27/16.
//  Copyright © 2016 Ammini Inc. All rights reserved.
// Ref: https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/UIScrollView_pg/ZoomZoom/ZoomZoom.html

#import "PinchZoomViewController.h"

@interface PinchZoomViewController ()
@property (nonatomic,strong) UIScrollView* scrollView;
@property (nonatomic,strong) UIImageView* imageView;
@property (assign)BOOL isZoomed;
@end

@implementation PinchZoomViewController

#pragma mark View Life cycle 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureScrollView];
    // Support zoom in and zoom out while double tapping on the scroll view
    [self configureGestures];
}
- (void)loadView {
    CGRect fullScreenRect=[[UIScreen mainScreen] bounds];
    self.scrollView=[[UIScrollView alloc] initWithFrame:fullScreenRect];
    self.view=self.scrollView;
    self.scrollView.contentSize=CGSizeMake(320,758);
    self.view=self.scrollView;
}

# pragma mark Private Functions

- (void)configureGestures{
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap)];
    doubleTap.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTap];
}

- (void)handleDoubleTap{
    
    if (self.isZoomed) {
        [self.scrollView setZoomScale:1.0 animated:YES];
        self.isZoomed = NO;
    }else{
        [self.scrollView setZoomScale:6.0 animated:YES];
        self.isZoomed = YES;
    }
}

- (void) configureScrollView{
    
    self.scrollView.minimumZoomScale=0.5;
    self.scrollView.maximumZoomScale=6.0;
    self.scrollView.contentSize=CGSizeMake(1280, 960);
    self.scrollView.delegate=self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"watch.jpg"]];
    self.imageView.frame = self.view.bounds;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
}

#pragma mark Scroll View Delegate handling

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
@end
