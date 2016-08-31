//
//  MethodSwizzlingViewController.m
//  Refresher-OBJC
//
//  Created by      on 8/30/16.
//  Copyright © 2016     Inc. All rights reserved.
//

#import "MethodSwizzlingViewController.h"
#import "TaxProcessor.h"
#import "TaxProcessor+Snoopy.h"

@interface MethodSwizzlingViewController()
@property (weak, nonatomic) IBOutlet UITextField *income;
@end

@implementation MethodSwizzlingViewController

- (IBAction)didTapOnSubmit:(id)sender {
    TaxProcessor *processor = [[TaxProcessor alloc]init];
    [processor sendTaxReturnToBank:self.income.text];
}

@end
