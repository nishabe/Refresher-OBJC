//
//  PinchZoomGestureViewController.m
//  Refresher-OBJC
//
//  Created by  on 10/31/16.
//  Copyright © 2016  Inc. All rights reserved.
//

#import "PinchZoomGestureViewController.h"

@interface PinchZoomGestureViewController ()
@property (nonatomic,strong) UIImageView* imageView;
@end

@implementation PinchZoomGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureImageView];
    [self configureGestures];
}

-(void)configureImageView
{
    UIImage* image = [UIImage imageNamed:@"watch.jpg"];
    self.imageView = [[UIImageView alloc]initWithImage:image];
    self.imageView.frame = self.view.bounds;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.center = self.view.center;
    self.imageView.userInteractionEnabled = YES;
    [self.view addSubview:self.imageView];
}
- (void)configureGestures{
    // The pinch gesture is useful for changing the transform of a view by scaling it up or down.
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.imageView addGestureRecognizer:pinchGestureRecognizer];
}
- (void) handlePinch:(UIPinchGestureRecognizer *)pinchGestureRecognizer{
    self.imageView.transform = CGAffineTransformScale(self.imageView.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
    pinchGestureRecognizer.scale = 1.0;
}
@end
