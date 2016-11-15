//
//  SequeHomeViewController.m
//  Refresher-OBJC
//
//  Created by on 11/15/16.
//  Copyright © 2016 Inc. All rights reserved.
//

#import "SequeHomeViewController.h"
#import "CalenderViewControl.h"

@interface SequeHomeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *monthSelection;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@end

@implementation SequeHomeViewController

- (IBAction)sliderValueChanged:(id)sender {
    self.monthSelection.text = [NSString stringWithFormat:@"%d",(int)self.slider.value];
}

- (IBAction)didTapOnGo:(id)sender {
    [self performSegueWithIdentifier:@"showCalender" sender:self];
}

- (IBAction)close:(UIStoryboardSegue*)segue{
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showCalender"]) {
        CalenderViewControl* calender = (CalenderViewControl*) segue.destinationViewController;
        calender.selectedMonth = self.slider.value;
    }
}
@end
