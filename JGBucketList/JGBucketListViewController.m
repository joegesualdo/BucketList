//
//  JGBucketListViewController.m
//  JGBucketList
//
//  Created by Joe Gesualdo on 8/29/14.
//  Copyright (c) 2014 Joe Gesualdo. All rights reserved.
//

#import "JGBucketListViewController.h"
#import "JGCoreDataStack.h"
#import "JGBucketListEntry.h"

@interface JGBucketListViewController () <NSFetchedResultsControllerDelegate>

// What is a NSFetchedResultsController?
//    class that takes a fetch request and executes it. Instead of executing it one and returning the results, it will execute it and later on let us know of any changes to the result happen. It does so through delegatioin -- like the method in this controller called: controllerDidChangeContent
// Create a new private property to represent our Fetch controller
@property(strong, nonatomic)NSFetchedResultsController *fetchedResultsController;

@end

@implementation JGBucketListViewController

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
    
    // In order to kick off the initial request of the fetched results controller, we need to performFetch
    // can pass in an NSError object varaible if you want
    [self.fetchedResultsController performFetch:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // we use the section property on the fetched results controller and then count to return the number of sections
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // retrieve the section info from the fetchedResultsController and retrieve from it the number of objects from the section.
    // Each section in our table view is represented by a sectionInfo object that conforms to the NSFetchedResults section info prootocol.
    // we grab that specific section info object and return from it the number of objects from that section
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    JGBucketListEntry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = entry.title;
    
    return cell;
}

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

// responsible for creating and configuring a fetch request to fetch all the items in our core data store sorted by title
// we put the fetch request in a method so it can be tested independently of actually fetching data
-(NSFetchRequest *)itemListFetchRequest
{
    // this will create a fetch request for the entity JGBucketListEntry.
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"JGBucketListEntry"];
    
    // Every fetch request MUST have a predicate or a sort descriptor, so we implement a sort descriptor that sorts the items by the title
    // you can pass in more sort than one sort desciption, you just pass them in as an array
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO]];
    
    return fetchRequest;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo name];
}

// What is a NSFetchedResultsController?
//    class that takes a fetch request and executes it. Instead of executing it one and returning the results, it will execute it and later on let us know of any changes to the result happen. It does so through delegatioin -- like the method in this controller called: controllerDidChangeContent
// Create a new fetchResultsController if one if we haven't created one yet
-(NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    JGCoreDataStack *coreDataStack = [JGCoreDataStack defaultStack];
    //we grab our fetch request
    NSFetchRequest *fetchRequest = [self itemListFetchRequest];
    
    // we initialize the fetched results controller with the fetch request and our managed object context
    // We use sectionName computed property for the sectionNameKeyPath argument
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:@"sectionName" cacheName:nil];
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

//this is a NSFetchedResultsControllerDelegate method that will be called everytime the data in the fetch changes
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // reload the table view data whenever the content it is displaying changes
    [self.tableView reloadData];
}

@end
