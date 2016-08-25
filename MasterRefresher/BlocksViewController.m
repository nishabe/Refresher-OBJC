//
//  BlocksViewController.m
//  Refresher-OBJC
//
//  Created by on 8/24/16.
//  Copyright © 2016    Inc. All rights reserved.
//

#import "BlocksViewController.h"
#import "BlockTester.h"

@implementation BlocksViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    BlockTester* tester = [[BlockTester alloc] init];
    [tester runTests];
}
@end
