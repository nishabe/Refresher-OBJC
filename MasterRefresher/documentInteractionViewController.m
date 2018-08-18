//
//  ViewController.m
//  DocumentInteraction
//
//  Created by Abraham, Aneesh on 8/13/18.
//  Copyright © 2018 Abraham, Aneesh. All rights reserved.
//

#import "documentInteractionViewController.h"

@interface documentInteractionViewController ()
@property UIDocumentInteractionController *documentInteractionController;
@end

@implementation documentInteractionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapOnShare:(id)sender {
    
    NSURL *filePath = [[NSBundle mainBundle] URLForResource:@"sample" withExtension:@".pdf"];
    NSString *path = [filePath path];
    NSURL *fileNameURL = [NSURL fileURLWithPath:path];


    //Use Document Iteraction controller
    if (fileNameURL != nil) {
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileNameURL];
        self.documentInteractionController.name = @"Title of Document";
        [self.documentInteractionController setDelegate:self];
        if (![self.documentInteractionController presentPreviewAnimated:YES]) {
            NSLog(@"Could not be displayed");
        }
    }
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    [UINavigationBar appearance].translucent = YES;
    return self;
}

@end
