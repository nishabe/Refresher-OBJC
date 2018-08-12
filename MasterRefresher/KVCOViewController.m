//
//  KVCOViewController.m
//  Refresher-OBJC
//
//  Copyright © 2016    Inc. All rights reserved.
//

#import "KVCOViewController.h"
@interface KVCOViewController()
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *age;
@end

static void *PrivateKVOContext = &PrivateKVOContext;

@implementation KVCOViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.studentA = [[Student alloc] init];
    // Assigning values to the properties using KVC
    [self.studentA setValue:@"John" forKey:@"name"];
    [self.studentA setValue:[NSNumber numberWithInteger:50] forKey:@"age"];
    // Reading property values using KVC
    NSString* name = [self.studentA valueForKey:@"name"];
    NSString *age = [[self.studentA valueForKey:@"age"] stringValue];
    self.name.text = name;
    self.age.text = age;
    self.messageLabel.text = [NSString stringWithFormat:@"Mr.%@ is of %@ years old",name,age];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // Adding observer for property change
    /*
     addObserver: This is the observing class, usually the self object.
     forKeyPath: It is the string you used as a key or a key path and matches to the property you want to observe. 
     options: By setting a value other than 0 (zero) to this parameter, you specify what the notification should contain. You can set a single value, or a combination of NSKeyValueObservingOptions values, combining them using the logical or (|)
     context: This is a pointer that can be used as a unique identifier for the change of the property we observe.
     */
    
    [self.studentA addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:&PrivateKVOContext];
    [self.studentA addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:&PrivateKVOContext];

}
// Now that we have made our class able to observe for any changes in the above two properties, we must implement the observeValueForKeyPath:ofObject:change:context: method. Its implementation is mandatory

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == PrivateKVOContext) {
        if ([keyPath isEqualToString:@"name"]) {
            NSString* oldName = (NSString *)[change objectForKey:@"old"];
            NSString* newName = (NSString *)[change objectForKey:@"new"];
            self.messageLabel.text = [NSString stringWithFormat:@"Old Name:%@, New Name:%@",oldName,newName];
        }
        if ([keyPath isEqualToString:@"age"]) {
            NSString* oldAge = (NSString *)[change objectForKey:@"old"];
            NSString* newAge = (NSString *)[change objectForKey:@"new"];
            self.messageLabel.text = [NSString stringWithFormat:@"Old Age:%ld, New Age:%ld",(long)[oldAge integerValue],(long)[newAge integerValue]];
        }
    }
    else{
        // Handle different context here if you are observing more object properties.
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.studentA removeObserver:self forKeyPath:@"name"];
    [self.studentA removeObserver:self forKeyPath:@"age"];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.name) {
        self.studentA.name = textField.text;
    } else if (textField == self.age) {
        self.studentA.age = [textField.text integerValue];
    }
}
@end
