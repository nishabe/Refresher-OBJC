//
//  ChildViewController.m
//  Refresher-OBJC
//
//  Created by   on 11/5/16.
//  Copyright © 2016    Inc. All rights reserved.
//

#import "ChildViewController.h"
#import "Utilities.h"

@interface ChildViewController ()

@end

@implementation ChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Setting bg color
    self.view.backgroundColor = [Utilities getRandomColor];
    // Creating label
    UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    aLabel.font = [UIFont boldSystemFontOfSize:24];
    aLabel.center = self.view.center;
    [aLabel setBackgroundColor:[UIColor clearColor]];
    NSString* labelString = [NSString stringWithFormat:@"Screen %d",(int)self.index + 1];
    [aLabel setText:labelString];
    [[self view] addSubview:aLabel];

}

@end
