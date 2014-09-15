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
#import "JGItemViewController.h"
#import "JGBucketListItemManager.h"
#import "JGBucketListFetchedResultsDelegate.h"

@interface JGBucketListViewController () 

// What is a NSFetchedResultsController?
//    class that takes a fetch request and executes it. Instead of executing it
//    one and returning the results, it will execute it and later on let us know
//    of any changes to the result happen. It does so through delegatioin --
//    like the method in this controller called: controllerDidChangeContent
// Create a new private property to represent our Fetch controller
@property(strong, nonatomic)
    NSFetchedResultsController *fetchedResultsController;
@property(strong, nonatomic) JGBucketListFetchedResultsDelegate *fetchedResultsDelegate;

@end

@implementation JGBucketListViewController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  
  


  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  // Uncomment the following line to display an Edit button in the navigation
  // bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;

  // In order to kick off the initial request of the fetched results controller,
  // we need to performFetch
  // can pass in an NSError object varaible if you want
  [self.fetchedResultsController performFetch:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // we use the section property on the fetched results controller and then
  // count to return the number of sections
  return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  // retrieve the section info from the fetchedResultsController and retrieve
  // from it the number of objects from the section.
  // Each section in our table view is represented by a sectionInfo object that
  // conforms to the NSFetchedResults section info prootocol.
  // we grab that specific section info object and return from it the number of
  // objects from that section
  

  id<NSFetchedResultsSectionInfo> sectionInfo =
      [self.fetchedResultsController sections][section];
  return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                      forIndexPath:indexPath];

  JGBucketListEntry *entry =
      [self.fetchedResultsController objectAtIndexPath:indexPath];
  NSLog(@"%@ - %@", entry.bucketListItemId, entry.title);

  cell.textLabel.text = entry.title;

  return cell;
}

// responsible for creating and configuring a fetch request to fetch all the
// items in our core data store sorted by title
// we put the fetch request in a method so it can be tested independently of
// actually fetching data
- (NSFetchRequest *)itemListFetchRequest {
  // this will create a fetch request for the entity JGBucketListEntry.
  NSFetchRequest *fetchRequest =
      [NSFetchRequest fetchRequestWithEntityName:@"JGBucketListEntry"];

  // Every fetch request MUST have a predicate or a sort descriptor, so we
  // implement a sort descriptor that sorts the items by the title
  // you can pass in more sort than one sort desciption, you just pass them in
  // as an array
  fetchRequest.sortDescriptors = @[
    [NSSortDescriptor sortDescriptorWithKey:@"updatedAt"
                                  ascending:YES]
  ];

  return fetchRequest;
}

// Asks for the editing style for a row at a specific index
// So this method defines what happens when you swipe the table cell
// To make the delete work, you also need to have the delegate method:
// commitEditingStyle below
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  // Editing styles can be:
  //     UITableViewCellEditingStyleDelete;
  //     UITableViewCellEditingStyleNone;
  //     UITableViewCellEditingStyleInsert;

  // we set our editing style to delete when we swipe
  return UITableViewCellEditingStyleDelete;
}

// This method defines what happens when we click delete; refer to the other
// delegate method above: editingStyleForRowAtIndex
- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {
  // to delete an item, you first have to get the element you want to delete
  JGBucketListEntry *entry =
      [self.fetchedResultsController objectAtIndexPath:indexPath];
  // get the core data stack
//  JGCoreDataStack *coreDataStack = [JGCoreDataStack defaultStack];
//  // to delete an object, we call the deleteObject on our managedObjectContext
//  RKManagedObjectStore *store = [RKManagedObjectStore defaultStore];
//  NSManagedObjectContext *managedObjectContext = entry.managedObjectContext;
//  
//  [managedObjectContext deleteObject:entry];
//  
//  NSError *error;
//  if (![managedObjectContext save:&error]) {
//    
//    NSLog(@"delete error");
//    
//    // Handle the error, update UI etc.
//   
//  }
  
  [[JGBucketListItemManager sharedManager] destroyItem:entry withParams:nil];
  // it's important to save the context so the changes are immediately available
  // in the persistent store
  // after we save the context, our fetch controller knows that our data has
  // changed, and it calls the delegate method we defined below:
  // controllerDidChangeContent
//  [coreDataStack saveContext];
//NSError *executeError = nil;
//if(![managedObjectContext saveToPersistentStore:&executeError]) {
//  NSLog(@"Failed to save to data store -- %@", [executeError localizedDescription]);
//}
  
}

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section {
  id<NSFetchedResultsSectionInfo> sectionInfo =
      [self.fetchedResultsController sections][section];
  return [sectionInfo name];
}

// What is a NSFetchedResultsController?
//  class that takes a fetch request and executes it. Instead of executing it
//  one and returning the results, it will execute it and later on let us know
//  of any changes to the result happen. It does so through delegatioin -- like
//  the method in this controller called: controllerDidChangeContent
// Create a new fetchResultsController if one if we haven't created one yet
- (NSFetchedResultsController *)fetchedResultsController {
  if (_fetchedResultsController != nil) {
    return _fetchedResultsController;
  }
//  NSManagedObjectContext *managedObjCtx = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
//  JGCoreDataStack *coreDataStack = [JGCoreDataStack defaultStack];
  // we grab our fetch request
  NSFetchRequest *fetchRequest = [self itemListFetchRequest];

  // we initialize the fetched results controller with the fetch request and our
  // managed object context
  // We use sectionName computed property for the sectionNameKeyPath argument
  _fetchedResultsController = [[NSFetchedResultsController alloc]
      initWithFetchRequest:fetchRequest
      managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext
        sectionNameKeyPath:@"isCompleted"
                 cacheName:nil];
  _fetchedResultsController.delegate = self.fetchedResultsDelegate;
  return _fetchedResultsController;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"edit"]) {
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    UINavigationController *navigationController =
        segue.destinationViewController;
    JGItemViewController *itemViewController =
        (JGItemViewController *)navigationController.topViewController;
    itemViewController.entry =
        [self.fetchedResultsController objectAtIndexPath:indexPath];
  }
}


// We overide the getter, so if no fetchedResultsDelegate exists, then we initialize one
-(JGBucketListFetchedResultsDelegate *)fetchedResultsDelegate
{
  if (_fetchedResultsDelegate == nil) {
    _fetchedResultsDelegate = [[JGBucketListFetchedResultsDelegate alloc]init];
    // We need to pass the table view to our delegate so we can 'reload' it in our delegate class
    _fetchedResultsDelegate.tableView = self.tableView;
  }
  // return the delegate
  return _fetchedResultsDelegate;
}

@end
