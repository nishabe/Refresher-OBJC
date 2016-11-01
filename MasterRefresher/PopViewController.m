//
//  PopViewController.m
//  Refresher-OBJC
//
//  Created by on 11/1/16.
//  Copyright © 2016 Inc. All rights reserved.
//

#import "PopViewController.h"

@interface PopViewController ()

@end

@implementation PopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
    // add touch recogniser to dismiss this controller
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissMe)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissMe {
    
    NSLog(@"Popover was dismissed with internal tap");
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
