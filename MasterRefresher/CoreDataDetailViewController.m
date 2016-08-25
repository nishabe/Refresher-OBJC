//
//  CoreDataDetailViewController.m
//  MasterRefresher
//
 
//  Copyright © 2016    Inc. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "CoreDataDetailViewController.h"

@interface CoreDataDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *version;
@property (weak, nonatomic) IBOutlet UITextField *company;


@end

@implementation CoreDataDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.device) {
        [self.name setText:[self.device valueForKey:@"name"]];
        [self.version setText:[self.device valueForKey:@"version"]];
        [self.company setText:[self.device valueForKey:@"company"]];
    }
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (IBAction)save:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (self.device) {
        // Update existing device
        [self.device setValue:self.name.text forKey:@"name"];
        [self.device setValue:self.version.text forKey:@"version"];
        [self.device setValue:self.company.text forKey:@"company"];
        
    } else {
        // Create a new managed object
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Device" inManagedObjectContext:context];
        [newDevice setValue:self.name.text forKey:@"name"];
        [newDevice setValue:self.version.text forKey:@"version"];
        [newDevice setValue:self.company.text forKey:@"company"];
    }
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
