//
//  ExtensionViewController.m
//  Refresher-OBJC
//
//  Created by     on 8/9/16.
//  Copyright © 2016 Ammini Inc. All rights reserved.
//

#import "ExtensionViewController.h"

@interface ExtensionViewController ()
// 'announcement' variable re-declared as readwrite property.
@property (readwrite,nonatomic) NSString *announcement;
// Declaring the method
-(void)showAnnouncement;
@end

@implementation ExtensionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Value assigned to 'announcement' variable
    self.announcement = @"This is a 're-written' announcement";
    // Method declared within extension is called
    [self showAnnouncement];
}
-(void)showAnnouncement{
    self.label.text = self.announcement;
}

@end
