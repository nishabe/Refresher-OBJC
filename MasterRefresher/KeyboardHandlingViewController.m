//
//  KeyboardHandlingViewController.m
//  Refresher-OBJC
//
//  Created by     on 10/21/16.
//  Copyright © 2016     . All rights reserved.
//
// Ref: http://stackoverflow.com/questions/19647096/dismiss-the-keyboard-multiple-uitextfields-in-ios-7

#import "KeyboardHandlingViewController.h"

@interface KeyboardHandlingViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *secondNameField;
@property (weak, nonatomic) UITextField *activeTextField;
@end

@implementation KeyboardHandlingViewController

#pragma mark View Life cycle handling

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addGesture];
    [self createAccessoryViews];
}

#pragma mark Text field delegate handling

// 1. Use resignFirstResponder on delegate handling. KB will be dimissed while tapping on the onscreen 'return' button

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    
    // 1.1 - Resign the active textfield
    [textField resignFirstResponder];
    // Or, 1.2
    //[[self view] endEditing:YES];
    // Or, 1.3
    //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    // became first responder
    self.activeTextField = textField;
    
}

#pragma mark Custom View Delegate handling

- (void)didTapOnSuggestionButton:(id)sender{
    
    UIButton* button = (UIButton*) sender;
    self.activeTextField.text = button.titleLabel.text;
}

#pragma mark Private Methods

- (void) addGesture{
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleTap];
}
- (void) registerForNotifications{
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(noticeShowKeyboard:) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(noticeHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    [center addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    /*
     * UIKeyboardWillShowNotification
     * UIKeyboardDidShowNotification
     * UIKeyboardWillHideNotification
     * UIKeyboardDidHideNotification
     */
}
- (void) createAccessoryViews{
    
    CustomScrollView* customView = [[CustomScrollView alloc]initWithFrame:CGRectMake(0, self.view.bounds.origin.y + 100, self.view.bounds.size.width, 50)];
    customView.backgroundColor = [UIColor grayColor];
    customView.delegate= self;
    customView.buttonLabels = @[@"James",@"John",@"Robert",@"Michael",@"William",@"David",@"Richard"];
    [customView configureView];
    self.firstNameField.inputAccessoryView = customView;
    
    customView = [[CustomScrollView alloc]initWithFrame:CGRectMake(0, self.view.bounds.origin.y + 100, self.view.bounds.size.width, 50)];
    customView.backgroundColor = [UIColor grayColor];
    customView.delegate= self;
    customView.buttonLabels = @[@"Smith",@"Jones",@"Williams",@"Taylor",@"Brown",@"Evans",@"Wilson"];
    [customView configureView];
    self.secondNameField.inputAccessoryView = customView;
}

// 2. Dismiss keyboard while tapping on the view outside the text field.

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

#pragma mark keyboard notification handling

-(void) noticeShowKeyboard:(NSNotification *)inNotification {
    // Do something here
}

-(void) noticeHideKeyboard:(NSNotification *)inNotification {
    // Do something here
}

-(void) handleKeyboardWillShow:(NSNotification *)inNotification {
    // Do something here
}

@end
