//
//  JGBucketListFetchedResultsDelegate.m
//  JGBucketList
//
//  Created by Joe Gesualdo on 9/15/14.
//  Copyright (c) 2014 Joe Gesualdo. All rights reserved.
//

#import "JGBucketListFetchedResultsDelegate.h"

@implementation JGBucketListFetchedResultsDelegate 

#pragma mark - Animations for deleting, moving, updating, and changing rows
// The code below is stock code that will be almost always used with the fetch
// cotroller.

// Animations in tableviews use a batch approach, where we begin the updates,
// perform the updates that aren't reflected immediately, and then end the
// update, and then all the updates are reflected at once with animation
// To do this animation we implement these 4 methods, instead of just doing
// controller:didChangeChangeContent and reloading the tableview
//    1) controllerWillChangeContent
//    2) controllerDidChangeObject:atIndexPath:forChangeType:newIndexPath
//    3) controllerDidChnageSEction
//    4) controllerDidChangeContent
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  
  [self.tableView beginUpdates];
}

// Caled whenever a row is inserted, deleted, chagned, or moved
// We pass in the type to chagne the action depending on what actaully happened
- (void)controller:(NSFetchedResultsController *)controller
    didChangeObject:(id)anObject
        atIndexPath:(NSIndexPath *)indexPath
      forChangeType:(NSFetchedResultsChangeType)type
       newIndexPath:(NSIndexPath *)newIndexPath {
  switch (type) {
  // If the type is NSFetchedResultsChangeInsert, the method
  // insertRowAtIndexPath method will be called on the table view. This will
  // insert a new row at the specified indexPath. This will do it with animation
  // automatic
//    case NSFetchedResultsChangeInsert:
//      [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//      break;
//      
//    case NSFetchedResultsChangeDelete:
//      if ([[self.fetchedResultsController fetchedObjects] count] == 0) {
//        // Last object removed, "object cell" is replaced by "empty cell"
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//      } else {
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//      }
//      break;
  case NSFetchedResultsChangeInsert:
    // You can choose many types of animations
    [self.tableView insertRowsAtIndexPaths:@[ newIndexPath ]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    break;
  // we pass indexPath and not newIndexPath
  case NSFetchedResultsChangeDelete:
    [self.tableView deleteRowsAtIndexPaths:@[ indexPath ]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    break;
  case NSFetchedResultsChangeUpdate:
    [self.tableView reloadRowsAtIndexPaths:@[ indexPath ]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
//    break;
//  default:
//    break;
  }
}

// Belongs to NSFetchedResultsControllerDelegate protocol
// It's called whenver a section is inserted or deleted. So when we delete the
// last row of a section, this is called. Or when we insert the first row of a
// section this is called
- (void)controller:(NSFetchedResultsController *)controller
    didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
             atIndex:(NSUInteger)sectionIndex
       forChangeType:(NSFetchedResultsChangeType)type {
  switch (type) {
  case NSFetchedResultsChangeInsert:
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
    break;
  case NSFetchedResultsChangeDelete:
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
    break;

  default:
    break;
  }
}

// this is a NSFetchedResultsControllerDelegate method that will be called
// everytime the data in the fetch changes
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  // reload the table view data whenever the content it is displaying changes
  // We are commenting it out, because we want to add animation so we implemetn
  // both controllerWillChangeContent also
  // [self.tableView reloadData];

  [self.tableView endUpdates];
}
@end
