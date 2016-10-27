//
//  GestureRecognitionViewController.m
//  Refresher-OBJC
//
//  Created by   on 10/24/16.
//  Copyright © 2016    All rights reserved.
// Ref: https://www.appcoda.com/ios-gesture-recognizers/
//http://stackoverflow.com/questions/3319591/uilongpressgesturerecognizer-gets-called-twice-when-pressing-down

#import "GestureRecognitionViewController.h"
#import <CoreGraphics/CGBase.h>

@interface GestureRecognitionViewController ()
@property (nonatomic,strong) UIImageView* imageView;
@property (assign) float currentRadius;
@end

@implementation GestureRecognitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addImageView];
    [self configureGestures];
}

- (void)addImageView{
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"monkey_1.png"]];
    self.imageView.frame = CGRectMake(0, 0, 180, 172);
    [self.view addSubview:self.imageView];
    self.imageView.center = self.view.center;
    self.imageView.userInteractionEnabled = YES;
    self.imageView.backgroundColor = [UIColor redColor];
}
- (void)configureGestures{
    
    // Single tap
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    singleTap.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:singleTap];
    // Double Tap
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap)];
    doubleTap.numberOfTapsRequired = 2;
    [self.imageView addGestureRecognizer:doubleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    // Long Press
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.imageView addGestureRecognizer:longTap];
    // Swipe Left
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft)];
    gestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:gestureRecognizer];
    // Swipe Right
    gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight)];
    gestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:gestureRecognizer];
    // Swipe Up
    gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeUp)];
    gestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:gestureRecognizer];
    // Swipe Down
    gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeDown)];
    gestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:gestureRecognizer];
    // Pan  is handy when you want to allow your users to drag views around the screen.
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning:)];
    [self.imageView addGestureRecognizer:panGestureRecognizer];
    // A UIScreenEdgePanGestureRecognizer looks for panning (dragging) gestures that start near an edge of the screen.
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftEdgeGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:leftEdgeGesture];
    // Disabling back swipe gesture of navigation controller in order to support UIScreenEdgePanGestureRecognizer
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    // The pinch gesture is useful for changing the transform of a view by scaling it up or down.
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.imageView addGestureRecognizer:pinchGestureRecognizer];
    // Rotation gesture
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    [self.imageView addGestureRecognizer:rotationGestureRecognizer];
}

- (void)handleSingleTap{
    [self showMessage:@"Single Tap"];
}
- (void)handleDoubleTap{
    [self showMessage:@"Double Tap"];
}
- (void)handleLongPress:(UILongPressGestureRecognizer*)sender{
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        //Do Whatever You want on End of Gesture
        [self showMessage:@"Long press"];
    }
    else if (sender.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan.");
        //Do Whatever You want on Began of Gesture
    }
}
- (void) didSwipeLeft{
    [self showMessage:@"Left Swipe"];
}
- (void) didSwipeRight{
    [self showMessage:@"Right Swipe"];
}
- (void) didSwipeUp{
    [self showMessage:@"Swipe Up"];
}
- (void) didSwipeDown{
    [self showMessage:@"Swipe Down"];
}
- (void) handlePanning:(UIPanGestureRecognizer *)panGestureRecognizer{
    CGPoint touchLocation = [panGestureRecognizer locationInView:self.view];
    self.imageView.center = touchLocation;
}
- (void) handleLeftEdgeGesture:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (self.currentRadius == 360.0) {
            self.currentRadius = 0.0;
        }
        [UIView animateWithDuration:1.0 animations:^{
            self.currentRadius += 90.0;
            self.imageView.transform = CGAffineTransformMakeRotation((self.currentRadius * M_PI) / 180.0);
        }];
    }
}
- (void) handlePinch:(UIPinchGestureRecognizer *)pinchGestureRecognizer{
    self.imageView.transform = CGAffineTransformScale(self.imageView.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
    pinchGestureRecognizer.scale = 1.0;
}
- (void) handleRotation:(UIRotationGestureRecognizer *)rotationGestureRecognizer{
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, rotationGestureRecognizer.rotation);
    rotationGestureRecognizer.rotation = 0.0;
}
- (void)showMessage:(NSString*)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil]; //You can use a block here to handle a press on this button
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
