//
//  ScrollViewSampleViewController.m
//  Refresher-OBJC
//
//  Created by   on 10/20/16.
//  Copyright © 2016   . All rights reserved.
//

#import "ScrollViewSampleViewController.h"

@implementation ScrollViewSampleViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self addCustomView];
}

- (void) addCustomView{
    
    CustomScrollView* customView = [[CustomScrollView alloc]initWithFrame:CGRectMake(0, self.view.bounds.origin.y + 100, self.view.bounds.size.width, 50)];
    customView.backgroundColor = [UIColor grayColor];
    customView.delegate= self;
    customView.buttonLabels = @[@"QAZ234234",@"WX",@"C",@"R64565FV",@"TGB",@"Y5656454HN",@"UGGFDFDJM"];
    [customView configureView];
    [self.view addSubview:customView];
}

- (void)didTapOnSuggestionButton:(id)sender{
    UIButton* button = (UIButton*) sender;
    NSLog(@"Tapped on %@",button.titleLabel.text);
}

@end
