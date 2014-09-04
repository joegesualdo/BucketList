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

  JGCoreDataStack *coreDataStack = [JGCoreDataStack defaultStack];
  [coreDataStack saveContext];
}

- (void)postBucketListItems:(JGBucketListEntry *)item {
  //  /* -- Enable this for debugging purposes
  //   RKLogConfigureByName("RestKit", RKLogLevelWarning);
  //   RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
  //   RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
  //   */
  //
  //  // Enable Activity Indicator Spinner
  //  [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
  //
  //  RKObjectManager *manager = [RKObjectManager sharedManager];
  //  RKObjectMapping *responseMapping =
  //      [RKObjectMapping mappingForClass:[JGBucketListEntry class]];
  //
  //  NSDictionary *mappingDictionary = @{
  //    @"bucketListItemId" : @"id",
  //    @"title" : @"title",
  //    @"isCompleted" : @"is_completed",
  //  };
  //
  //  [responseMapping addAttributeMappingsFromDictionary:mappingDictionary];
  //  // Set MIME Type to JSON
  //  manager.requestSerializationMIMEType = RKMIMETypeJSON;
  //
  //  NSIndexSet *statusCodes =
  //      RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
  //  RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
  //      responseDescriptorWithMapping:responseMapping
  //                             method:RKRequestMethodAny
  //                        pathPattern:@"/bucket_list_items.json"
  //                            keyPath:nil
  //                        statusCodes:statusCodes];
  //
  //  // Define Mapping
  //  RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
  //  [requestMapping addAttributeMappingsFromDictionary:mappingDictionary];
  //
  //  RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor
  //      requestDescriptorWithMapping:requestMapping
  //                       objectClass:[JGBucketListEntry class]
  //                       rootKeyPath:nil
  //                            method:RKRequestMethodAny];
  //
  //  // Define Response Descriptor
  //  [manager addResponseDescriptor:responseDescriptor];
  //  [manager addRequestDescriptor:requestDescriptor];
  //
  //  //  // Convert Date to String Format for JSON
  //  //  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  //  //  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  //  //  NSString *dateString = [dateFormatter
  //  stringFromDate:complaint.createdAt];
  //
  NSDictionary *params = @{
    @"title" : item.title,
    @"uuid" : item.uuid,
    @"is_completed" : @"false",
  };

  [[JGBucketListItemManager sharedManager] postItem:item withParams:params];

  // POST using Parameters
  //  [manager postObject:item
  //      path:@"/bucket_list_items.json"
  //      parameters:params
  //      success:^(RKObjectRequestOperation *operation,
  //                RKMappingResult *mappingResult) {
  //          NSLog(@"SUCCESS: %@", mappingResult.array);
  //      }
  //      failure:^(RKObjectRequestOperation *operation,
  //                NSError *error) { NSLog(@"FAILED: %@", error); }];
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
  JGBucketListEntry *entry = [NSEntityDescription
      insertNewObjectForEntityForName:@"JGBucketListEntry"
               inManagedObjectContext:coreDataStack.managedObjectContext];
  // configure that entry
  // This creates a uique number that will be appied to each etry
  NSString *uuid = [[NSUUID UUID] UUIDString];
  entry.uuid = uuid;
  NSLog(@"The uuid -- %@", uuid);
  NSLog(@"The entry has uuid -- %@", entry.uuid);
  entry.title = self.textField.text;
  entry.isCompleted = NO;

  // save core data stack because a new entity we want to save
  [coreDataStack saveContext];
  [self postBucketListItems:entry];
}
@end
