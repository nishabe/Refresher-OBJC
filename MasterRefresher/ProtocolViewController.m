//
//  ProtocolViewController.m
//  Refresher-OBJC
//
//  Copyright © 2016 Ammini Inc. All rights reserved.
//

#import "ProtocolViewController.h"

@interface ProtocolViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation ProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SampleProtocol *aSampleProtocol = [[SampleProtocol alloc]init];
    aSampleProtocol.delegate = self;
    [aSampleProtocol startSampleProcess];
    
}
#pragma mark - Sample protocol delegate
-(void)processCompleted{
    [self.label setText:@"Process Completed"];
}
@end
