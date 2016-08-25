//
//  NotificationViewController.m
//  Refresher-OBJC
//
//  Copyright © 2016    Inc. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationSample.h"

@interface NotificationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation NotificationViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.label.text = @"Process has started...";
    NotificationSample *aSample = [[NotificationSample alloc] init];
    [aSample startLongRunningProcess];
    
}
-(void)updateUser:(NSNotification*)notification{
    NSDictionary *responseObject = [NSDictionary
                                    dictionaryWithDictionary:notification.userInfo];
    NSString *finalResponse = (NSString*)[responseObject objectForKey:@"Response"];
    NSString* description =  [NSString stringWithFormat:@"Process completed. Final response is:%@",finalResponse];
    self.label.text = description;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUser:)
                                                 name:@"SampleNotification"
                                               object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SampleNotification" object:nil];
    
    
}
@end
