//
//  SimpleCoredataHomeViewController.m
//  MasterRefresher
//
 
//  Copyright © 2016 Ammini Inc. All rights reserved.
//

#import "SimpleCoredataHomeViewController.h"
#import "CoreDataDetailViewController.h"

@interface SimpleCoredataHomeViewController ()
{
    BOOL isEditing;
}
@property (strong) NSMutableArray *devices;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editBarButton;
@property (strong, nonatomic)  UIBarButtonItem *sortBarButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation SimpleCoredataHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.devices = [NSMutableArray array];
    NSString* cellIdentifier = @"Cell";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    /* Reference: 
     http://tinyletter.com/iosdev/letters/ios-dev-tip-50-uitableview-registerclass-forcellreuseidentifier
     https://developer.apple.com/library/ios/documentation/UIKit/Reference/UITableView_Class/index.html#//apple_ref/occ/instm/UITableView/dequeueReusableCellWithIdentifier:forIndexPath:
     
     */
    
    // Adding custom toolbar items
    
    NSMutableArray *toolbarItems = [NSMutableArray array];
    // Add Edit button
    self.editBarButton = [[UIBarButtonItem alloc]
                          initWithTitle:@"Edit"
                          style:UIBarButtonItemStylePlain
                          target:self
                          action:@selector(makeEditAvailable:)];
    [toolbarItems addObject:self.editBarButton];

    // Add Read all button
    UIBarButtonItem* readAllBarButton = [[UIBarButtonItem alloc]
                                         initWithTitle:@"Read All"
                                         style:UIBarButtonItemStylePlain
                                         target:self
                                         action:@selector(readAllFromContext)];
    [toolbarItems addObject:readAllBarButton];

    // Add Company button
    UIBarButtonItem* companyBarButton = [[UIBarButtonItem alloc]
                          initWithTitle:@"Company"
                          style:UIBarButtonItemStylePlain
                          target:self
                          action:@selector(readCompanyFromContext)];
    [toolbarItems addObject:companyBarButton];
    
    // Add Predicate button
    UIBarButtonItem* predicateBarButton = [[UIBarButtonItem alloc]
                                         initWithTitle:@"Predicate"
                                         style:UIBarButtonItemStylePlain
                                         target:self
                                         action:@selector(callWithPredicate)];
    [toolbarItems addObject:predicateBarButton];
    
    // Add sort button
    self.sortBarButton = [[UIBarButtonItem alloc]
                          initWithTitle:@"Sort"
                          style:UIBarButtonItemStylePlain
                          target:self
                          action:@selector(sort:)];
    [toolbarItems addObject:self.sortBarButton];
    
    // Add barbuttons to toolbarItems array
    [self.toolbar setItems:toolbarItems animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
// Reference: https://developer.apple.com/library/mac/documentation/DataManagement/Conceptual/CoreDataSnippets/Articles/fetching.html

-(IBAction)readAllFromContext{
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    // Setting up a NSFetchRequest is equivalent to a SELECT statetement in SQL language.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Device"];
    self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.tableView reloadData];
}

-(IBAction)readCompanyFromContext{
    // refer: https://developer.apple.com/library/ios/documentation/DataManagement/Conceptual/CoreDataSnippets/Articles/fetchExpressions.html
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription  entityForName:@"Device" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setResultType:NSDictionaryResultType];
    [request setReturnsDistinctResults:YES];
    [request setPropertiesToFetch:@[@"company"]];
    // Execute the fetch.
    NSError *error;
    self.devices = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (self.devices == nil) {
        // Handle the error.
    }
    [self.tableView reloadData];
}
-(IBAction)callWithPredicate{

    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    // Setting up a NSFetchRequest is equivalent to a SELECT statetement in SQL language.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Device"];
    NSString *predicateString = @"Apple";
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"company == %@", predicateString]];
    self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.tableView reloadData];
}
- (IBAction)sort:(id)sender{
    //TODO: Crashing now. Need to fix.
   /*
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Device"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Company"
                                                                   ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    self.devices = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if (self.devices == nil) {
        // Handle the error.
    }
*/
}
-(void)deleteFromContext:(NSInteger)row{
    [[self managedObjectContext] deleteObject:[self.devices objectAtIndex:row]];
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
    }
}

- (IBAction)makeEditAvailable:(id)sender{
    
    if (isEditing) {
        isEditing=NO;
        [self.tableView setEditing:NO animated:YES];
        self.editBarButton.title=@"Edit";
    }else{
        isEditing=YES;
        [self.tableView setEditing:YES animated:YES];
        self.editBarButton.title=@"Done";
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"UpdateDevice"]) {
        NSManagedObject *selectedDevice = [self.devices objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        CoreDataDetailViewController *destViewController = segue.destinationViewController;
        destViewController.device = selectedDevice;
    }
}

#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
    // Configure the cell...
    NSManagedObject *device = [self.devices objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ - %@ - %@", [device valueForKey:@"name"], [device valueForKey:@"version"],[device valueForKey:@"company"]]];
    
    return cell;
}


#pragma mark - Table View Delegates


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete object from database
        [self deleteFromContext:indexPath.row];
        // Remove device from table view
        [self.devices removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"UpdateDevice" sender:nil];
}
@end
