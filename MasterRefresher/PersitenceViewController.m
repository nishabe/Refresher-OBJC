//
//  PersitenceViewController.m
//  Refresher-OBJC
//
//  Created by on 11/6/16.
//  Copyright © 2016 Inc. All rights reserved.
// Ref: https://github.com/jkereako/GenericKeychain
// https://www.techotopia.com/index.php/An_Example_SQLite_based_iOS_7_Application

#import "PersitenceViewController.h"
#import "KeychainItemWrapper.h"
#import "DBManager.h"

@interface PersitenceViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *selectionField;
@property (nonatomic) KeychainItemWrapper *keychainItemWrapper;
@property (nonatomic,strong) NSArray* pickerItems;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (nonatomic,retain) DBManager* DBmanager;
@end

@implementation PersitenceViewController
#pragma mark View Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark User actions
- (IBAction)didTapOnSaveUserName:(id)sender {
    NSString* userName = self.userName.text;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userName forKey:@"USER_NAME"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (IBAction)didTapOnReadUserName:(id)sender {
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_NAME"];
    self.userName.text=userName;
}
- (IBAction)didTapOnSavePassword:(id)sender {
    self.keychainItemWrapper =  [[KeychainItemWrapper alloc] initWithIdentifier:@"MY_APP_CREDENTIALS" accessGroup:nil];
    [self.keychainItemWrapper setObject:self.password.text forKey:(id)kSecValueData];
}
- (IBAction)didTapOnReadPassword:(id)sender {
    NSString* password = [self.keychainItemWrapper objectForKey:(id)kSecValueData];
    self.password.text=password;
    NSLog(@"%@",password);
}
- (IBAction)didTapOnReset:(id)sender {
    [self.keychainItemWrapper resetKeychainItem];
    NSLog(@"Keychain Reset over");
}

- (IBAction)didTapOnReadMonths:(id)sender {
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"]];
    NSArray* options = [dictionary objectForKey:@"MonthOptions"];
    self.pickerItems=options;
    /* Reading rest of the info:
     BOOL customer = [[dictionary objectForKey:@"PaidCustomer"] boolValue];
     NSDictionary* credentials = [dictionary objectForKey:@"Credentials"];
     NSString* firstName = [credentials valueForKey:@"FirstName"];
     NSString* secondName = [credentials valueForKey:@"SecondName"];
     */
    UIPickerView* aPickerView = [[UIPickerView alloc]init];
    aPickerView.dataSource = self;
    aPickerView.delegate = self;
    self.selectionField.inputView = aPickerView;
}
- (IBAction)didTapOnSaveSqlite:(id)sender {
    self.DBmanager = [DBManager getSharedInstance];
    [self.DBmanager saveData:self.userName.text password:self.password.text andSelectedMonth:self.selectionField.text];
}
- (IBAction)didTapOnFindInSqlite:(id)sender {
    self.DBmanager = [DBManager getSharedInstance];
    [self.DBmanager findContact:self.userName.text];
}

#pragma mark Private methods

#pragma mark Picker View Data Source

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.pickerItems.count;
}

#pragma mark Picker View Delegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [self.pickerItems objectAtIndex:row];
    return title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectionField.text = [self.pickerItems objectAtIndex:row];
    [self.selectionField resignFirstResponder];
}
@end
