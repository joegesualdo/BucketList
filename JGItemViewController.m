//
//  JGNewItemViewController.m
//  JGBucketList
//
//  Created by Joe Gesualdo on 8/29/14.
//  Copyright (c) 2014 Joe Gesualdo. All rights reserved.
//

#import "JGItemViewController.h"
#import "JGBucketListEntry.h"
#import "JGCoreDataStack.h"
#import "JGBucketListItemManager.h"
#import "JGAttributeHelper.h"

@interface JGItemViewController ()

@end

@implementation JGItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
    
  // Do any additional setup after loading the view.
  if (self.entry != nil) {
    self.textField.text = self.entry.title;
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneWasPressed:(UIBarButtonItem *)sender {
  if (self.entry != nil) {
    [self updateEntry];
    [self dismissSelf];
  } else {
    [self dismissSelf];
    [self insertBucketListItem];
  }
}

- (void)updateEntry {
  self.entry.title = self.textField.text;

//  JGCoreDataStack *coreDataStack = [JGCoreDataStack defaultStack];
//  [coreDataStack saveContext];
  [[JGBucketListItemManager sharedManager]patchItem:self.entry withParams:nil];
}

- (IBAction)cancelWasPressed:(UIBarButtonItem *)sender {
  [self dismissSelf];
}

- (void)dismissSelf {
  [self.presentingViewController dismissViewControllerAnimated:YES
                                                    completion:nil];
}

// Create a new BucketListEmtry instance and insert it into our managed object
// context. Then save the context.
- (void)insertBucketListItem {
  // Grab the applications core data stack
  JGCoreDataStack *coreDataStack = [JGCoreDataStack defaultStack];
  // define bucket list entry
  // inserts a new entity into our core data stack environment
//  JGBucketListEntry *entry = [NSEntityDescription
//      insertNewObjectForEntityForName:@"JGBucketListEntry"
//               inManagedObjectContext:coreDataStack.managedObjectContext];
  [coreDataStack saveContext];
  NSManagedObjectContext *managedObjCtx = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
  JGBucketListEntry *entry = [managedObjCtx insertNewObjectForEntityForName:@"JGBucketListEntry"];
  // configure that entry
  // This creates a uique number that will be appied to each etry
  entry.uuid = [JGAttributeHelper uuid];
  entry.title = self.textField.text;
  entry.isCompleted = NO;
  entry.createdAt = [JGAttributeHelper timestampUTC];
  entry.updatedAt = [JGAttributeHelper timestampUTC];
  
  // It appears I don't need to persist the entity. Instead I can just post it
//  NSError *executeError = nil;
//  if([managedObjCtx saveToPersistentStore:&executeError]) {
//    NSLog(@"Failed to save to data store");
//  }
  [[JGBucketListItemManager sharedManager] postItem:entry withParams:nil];
}
@end
