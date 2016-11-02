//
//  VisualEffectViewController.m
//  Refresher-OBJC
//
//  Created by Aneesh Abraham01 on 11/2/16.
//  Copyright © 2016 Ammini Inc. All rights reserved.
// Ref: https://www.omnigroup.com/developer/P5

#import "VisualEffectViewController.h"

@interface VisualEffectViewController ()
@property (nonatomic,strong)UIImageView* imageView;
@property (nonatomic,strong)UIVisualEffectView *blurEffectView;
@property (nonatomic,strong)UIVisualEffectView *vibrancyEffectView;
@end

@implementation VisualEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tile_1"]];
    [self createToolbar];
    
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ring_2"]];
    self.imageView.frame = CGRectMake(0, 0, 208, 208);
    self.imageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.imageView];
    self.imageView.center=self.view.center;

}

-(void)createToolbar{
    CGRect frame = CGRectMake(0, self.view.bounds.size.height - self.tabBarController.tabBar.frame.size.height*2, self.view.bounds.size.width, self.tabBarController.tabBar.frame.size.height);
    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:frame];
    toolbar.translucent = NO;
    toolbar.tintColor = [UIColor greenColor];
    toolbar.barTintColor = [UIColor whiteColor];
    // Creating segment control
    UISegmentedControl *aSegmentControl = [[UISegmentedControl alloc]initWithItems:@[@"Light Blur",@"Extra Light Blur",@"Dark Blur",@"Vibrant Blur"]];
    aSegmentControl.frame = toolbar.bounds;
    [aSegmentControl addTarget:self action:@selector(segmentControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [aSegmentControl setSelectedSegmentIndex:0];
    [toolbar addSubview:aSegmentControl];

    [toolbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    [self.view addSubview:toolbar];
}
#pragma marks Segmented Control Value changed

- (void)segmentControlValueDidChange:(UISegmentedControl *)segment{
    switch (segment.selectedSegmentIndex) {
        case 0:
        {
            [self.blurEffectView removeFromSuperview];
            // 1. Create effect
            UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            // 2. Add effect to an effect view
            self.blurEffectView = [[UIVisualEffectView alloc]initWithEffect:blur];
            // 3. Set frames
            self.blurEffectView.frame = self.imageView.bounds;
            //effectView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.tabBarController.tabBar.frame.size.height*2);
            // 4. Add effect view to base view
            [self.imageView addSubview:self.blurEffectView];
        }
            break;
        case 1:
        {
            [self.blurEffectView removeFromSuperview];
            // 1. Create effect
            UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            // 2. Add effect to an effect view
            self.blurEffectView = [[UIVisualEffectView alloc]initWithEffect:blur];
            // 3. Set frames
            self.blurEffectView.frame = self.imageView.bounds;
            //effectView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.tabBarController.tabBar.frame.size.height*2);
            // 4. Add effect view to base view
            [self.imageView addSubview:self.blurEffectView];

        }
            break;
        case 2:
        {
            [self.blurEffectView removeFromSuperview];
            // 1. Create effect
            UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            // 2. Add effect to an effect view
            self.blurEffectView = [[UIVisualEffectView alloc]initWithEffect:blur];
            // 3. Set frames
            //effectView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.tabBarController.tabBar.frame.size.height*2);
            self.blurEffectView.frame = self.imageView.bounds;
            // 4. Add effect view to base view
            [self.imageView addSubview:self.blurEffectView];
        }
            break;
        case 3:
        {
            [self.blurEffectView removeFromSuperview];
            [self.vibrancyEffectView removeFromSuperview];
            // 1. Create Blur Effect
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            [self.blurEffectView setFrame:self.imageView.bounds];
            [self.imageView addSubview:self.blurEffectView];
            // 2. Create Vibrancy Effect
            UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
            self.vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
            [self.vibrancyEffectView setFrame:self.imageView.bounds];
            // Add Vibrancy View to Blur View
            [self.blurEffectView.contentView addSubview:self.vibrancyEffectView];
        }
            break;
        default:
            break;
    }
}
@end
