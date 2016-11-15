//
//  CalenderViewControl.m
//  Refresher-OBJC
//
//  Created by on 11/15/16.
//  Copyright © 2016 Inc. All rights reserved.
//

#import "CalenderViewControl.h"
@interface CalenderViewControl()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
@implementation CalenderViewControl

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString* imageName = [NSString stringWithFormat:@"%02d.jpg",(int)self.selectedMonth];
    self.imageView.image = [UIImage imageNamed:imageName];
}

- (IBAction)didTapOnCloseButton:(id)sender {
}

@end