//
//  PresentationViewController.m
//  Refresher-OBJC
//
//  Created by on 11/1/16.
//  Copyright © 2016 Inc. All rights reserved.
//  Ref: http://pinkstone.co.uk/how-to-create-popovers-in-ios-9/

#import "PresentationViewController.h"
#import "PopViewController.h"

@interface PresentationViewController () <UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *popOverButton;

@end

@implementation PresentationViewController
- (IBAction)showPopover:(id)sender {
    // 1. Create view controller we want to show within Pop over
    UIViewController *controller = [[PopViewController alloc]init];
    // 2. Set the presentatin style and present the controller
    // on iPad, this will be a Popover
    // on iPhone, this will be an Modal View
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    // 3. Configure the Popover presentation controller
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.sourceView = self.popOverButton;
    popController.delegate = self;
}
- (IBAction)showModalView:(id)sender {
    UIViewController *controller = [[PopViewController alloc]init];
    [self presentViewController:controller animated:YES completion:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

# pragma mark - Popover Presentation Controller Delegate

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    // called when a Popover is dismissed
    NSLog(@"Popover was dismissed with external tap. Have a nice day!");
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    // return YES if the Popover should be dismissed
    // return NO if the Popover should not be dismissed
    return YES;
}

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing  _Nonnull *)view {
    
    // called when the Popover changes positon
}
@end
