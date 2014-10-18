//
//  personTableViewController.m
//  Portfolio
//
//  Created by Safin Ahmed on 29/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "personTableViewController.h"
#import "CoreData/Person.h"

@interface personTableViewController ()

@end

@implementation personTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    /* Create the fetch request first */
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]
                                    initWithEntityName:@"Person"];
    NSSortDescriptor *ageSort =
    [[NSSortDescriptor alloc] initWithKey:@"age"
                                ascending:YES];
    NSSortDescriptor *firstNameSort =
    [[NSSortDescriptor alloc] initWithKey:@"firstName"
                                ascending:YES];
    fetchRequest.sortDescriptors = @[ageSort, firstNameSort];
    
    self.frc = [[NSFetchedResultsController alloc]
     initWithFetchRequest:fetchRequest
     managedObjectContext:[self managedObjectContext]
     sectionNameKeyPath:nil
     cacheName:nil];
    self.frc.delegate = self;
    NSError *fetchingError = nil;
    if ([self.frc performFetch:&fetchingError])
    {
        NSLog(@"Successfully fetched.");
    }
    else
        {
            NSLog(@"Failed to fetch.");
    }
}

-(NSManagedObjectContext*) managedObjectContext
{
    safAppDelegate *appDelegate = (safAppDelegate*)[[UIApplication sharedApplication] delegate];
    return [appDelegate managedObjectContext];
}

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
        atIndexPath:(NSIndexPath *)indexPath
      forChangeType:(NSFetchedResultsChangeType)type
       newIndexPath:(NSIndexPath *)newIndexPath
    {
    if (type == NSFetchedResultsChangeDelete)
    {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                        withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (type == NSFetchedResultsChangeInsert)
    {
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                        withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = self.frc.sections[section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:PersonTableViewCell
                                           forIndexPath:indexPath];
    Person *person = [self.frc objectAtIndexPath:indexPath];
    cell.textLabel.text =
    [person.firstName stringByAppendingFormat:@" %@", person.lastName];
    cell.detailTextLabel.text =
    [NSString stringWithFormat:@"Age: %lu",
     (unsigned long)[person.age unsignedIntegerValue]]; return cell;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Person *personToDelete = [self.frc objectAtIndexPath:indexPath];
    [[self managedObjectContext] deleteObject:personToDelete];
    if ([personToDelete isDeleted]){
        NSError *savingError = nil;
        if ([[self managedObjectContext] save:&savingError]){
            NSLog(@"Successfully deleted the object"); }else{
                NSLog(@"Failed to save the context with error = %@", savingError);
            }
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
