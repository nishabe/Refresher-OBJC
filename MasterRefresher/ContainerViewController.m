//
//  ContainerViewController.m
//  Refresher-OBJC
//
//  Created by     on 11/5/16.
//  Copyright © 2016      Inc. All rights reserved.
// Ref: https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/ImplementingaContainerViewController.html#//apple_ref/doc/uid/TP40007457-CH11-SW12

#import "ContainerViewController.h"
#import "ChildViewController.h"

@interface ContainerViewController ()
@property (nonatomic,strong) UIViewController* childViewController;
@property (assign)BOOL isChildAdded;
@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBottomToolbar];
}
- (void)createBottomToolbar{
    
    CGRect frame = CGRectMake(0, self.view.bounds.size.height - 88, self.view.bounds.size.width, 44);
    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:frame];
    toolbar.translucent = NO;
    toolbar.tintColor = [UIColor greenColor];
    toolbar.barTintColor = [UIColor grayColor];
    UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithTitle:@"Add Child" style:UIBarButtonItemStyleDone target:self action:@selector(addChild)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *button2=[[UIBarButtonItem alloc]initWithTitle:@"Remove Child" style:UIBarButtonItemStyleDone target:self action:@selector(hideChild)];
    [toolbar setItems:[[NSArray alloc] initWithObjects:button1,spacer,button2,nil]];
    [toolbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    [self.view addSubview:toolbar];
}
- (void) addChild{
    if (!self.isChildAdded) {
        ChildViewController* childViewController = [[ChildViewController alloc]init];
        childViewController.index = 0;
        [self displayContentController:childViewController];
        self.isChildAdded = YES;
        self.childViewController = childViewController;
    }
}
- (void)hideChild{
    if (self.childViewController) {
        [self hideContentController:self.childViewController];
        self.isChildAdded = NO;
    }
}
- (void) displayContentController: (UIViewController*) content {
    [self addChildViewController:content];
    CGRect frame = self.view.bounds;
    frame.size.width = frame.size.width/2;
    frame.size.height = frame.size.height/2;
    content.view.frame = frame;
    content.view.center = self.view.center;
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];
}

- (void) hideContentController: (UIViewController*) content {
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
}

@end
