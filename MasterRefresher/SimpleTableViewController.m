//
//  SimpleTableViewController.m
//  MasterRefresher
//
 
//  Copyright © 2016    Inc. All rights reserved.
//

#import "SimpleTableViewController.h"

@interface SimpleTableViewController ()
{
    NSMutableArray *recipes;
    BOOL isEditing;
}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editBarButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SimpleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isEditing=NO;
    self.editBarButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Edit"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(makeEditAvailable:)];
    self.navigationItem.rightBarButtonItem = self.editBarButton;
    
    // Do any additional setup after loading the view.
    // Initialize table data
    recipes = [NSMutableArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    
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

- (IBAction)addItem:(id)sender{
    
    [recipes addObject:@"A new Item"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[recipes indexOfObject:@"A new Item"] inSection:0];
    [self.tableView beginUpdates];
    [self.tableView
     insertRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
}

#pragma mark - Table View Data source Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [recipes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.imageView.image = [UIImage imageNamed:@"creme_brelee.jpg"];
    cell.textLabel.text = [recipes objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Default is 1 if not implemented
    return 1;
}


#pragma mark - Table View Delegates

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
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
        // Remove the row from data model
        [recipes removeObjectAtIndex:indexPath.row];
        // Request table view to reload
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //[tableView reloadData];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *stringToMove = recipes[sourceIndexPath.row];
    [recipes removeObjectAtIndex:sourceIndexPath.row];
    [recipes insertObject:stringToMove atIndex:destinationIndexPath.row];
}

@end
