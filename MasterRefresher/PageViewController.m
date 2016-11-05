//
//  PageViewController.m
//  Refresher-OBJC
//
//  Created by   on 11/5/16.
//  Copyright © 2016    Inc. All rights reserved.
// Ref: http://www.appcoda.com/uipageviewcontroller-tutorial-intro/

#import "PageViewController.h"
#import "ChildViewController.h"

@interface PageViewController ()<UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageController;
@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 1. instantiate pageController, set the oriention behaviour
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    // 2. Set the delegate
    self.pageController.dataSource = self;
    // 3. Set the frame
    [[self.pageController view] setFrame:[[self view] bounds]];
    CGRect frameRect = self.pageController.view.frame;
    frameRect.origin.y =self.view.bounds.origin.y - self.tabBarController.tabBar.frame.size.height;
    [[self.pageController view] setFrame:frameRect];
    // 4. Get the instance of first child view
    ChildViewController *initialViewController = [self viewControllerAtIndex:0];
    // 5. Create the array of child view controllers
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    // 6. Set the array of child view controllers, set the directino behaviour
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    // 7. Add the childview controller instance to parent view
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    self.pageController.view.backgroundColor = [UIColor grayColor];
}
- (ChildViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    ChildViewController *childViewController = [[ChildViewController alloc] init];
    childViewController.index = index;
    return childViewController;
}

#pragma mark <UIPageViewControllerDataSource> Handling

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [(ChildViewController *)viewController index];
    if (index == 0) {
        return nil;
    }
    // Decrease the index by 1 to return
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [(ChildViewController *)viewController index];
    index++;
    if (index == 5) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 5;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

@end
