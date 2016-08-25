//
//  CategoryViewController.m
//  Refresher-OBJC
//
//  Copyright © 2016    Inc. All rights reserved.
//

#import "CategoryViewController.h"
#import "NSString+StringAdditions.h"

@interface CategoryViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.label.text = [NSString getCopyRightString];
    
}
@end
