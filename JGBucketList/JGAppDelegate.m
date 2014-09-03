//
//  JGAppDelegate.m
//  JGBucketList
//
//  Created by Joe Gesualdo on 8/29/14.
//  Copyright (c) 2014 Joe Gesualdo. All rights reserved.
//

#import "JGAppDelegate.h"
#import "JGBucketListEntry.h"
#import "JGBucketListItemManager.h"

@implementation JGAppDelegate

- (BOOL)application:(UIApplication *)application
    willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  return YES;
}
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  // setup CoreData to work with restkit
  [self setupCoreDataWithRestKit];

  [[JGBucketListItemManager sharedManager] loadItems];

  self.window.backgroundColor = [UIColor whiteColor];

  // before window is visible, call the setupAppearance method to design the
  // window
  [self setupAppearance];

  [self.window makeKeyAndVisible];

  return YES;
}

- (void)loadComplaints {
  // Enable Activity Indicator Spinner
  [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

  RKObjectManager *manager = [RKObjectManager sharedManager];

  // Now for the object mappings
  //  RKEntityMapping *itemMapping =
  //      [RKEntityMapping mappingForEntityForName:@"JGBucketListEntry"
  //                          inManagedObjectStore:manager.managedObjectStore];
  //  NSDictionary *mappingDictionary = @{
  //    @"id" : @"bucketListItemId",
  //    @"title" : @"title",
  //    @"is_completed" : @"isCompleted",
  //  };
  //  [itemMapping addAttributeMappingsFromDictionary:mappingDictionary];
  //
  //  itemMapping.identificationAttributes = @[ @"bucketListItemId" ];
  //
  // register mappings with the provider using a response descriptor
  //  RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
  //      responseDescriptorWithMapping:itemMapping
  //                             method:RKRequestMethodGET
  //                        pathPattern:@"/bucket_list_items.json"
  //                            keyPath:nil
  //                        statusCodes:[NSIndexSet indexSetWithIndex:200]];
  //
  //  [manager addResponseDescriptor:responseDescriptor];

  //  NSDictionary *queryParams = @{ @"user" : @"username" };
  [manager getObjectsAtPath:@"/bucket_list_items.json"
      parameters:nil
      success:^(RKObjectRequestOperation *operation,
                RKMappingResult *mappingResult) {
          NSArray *arout = mappingResult.array;
          NSLog(@"items: %@", arout);
      }
      failure:^(RKObjectRequestOperation *operation,
                NSError *error) { NSLog(@"Error response': %@", error); }];
}

- (void)setupAppearance {
  // grab the proxy object for the UINavigationBar
  UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
  // set the bars tint color
  // need to have .0 so we do float division instead of integer divisioin
  navigationBarAppearance.barTintColor = [UIColor colorWithRed:77.0 / 255.0
                                                         green:164.0 / 255.0
                                                          blue:191.0 / 255.0
                                                         alpha:1.0f];
  // set the naviagtion bar tint color
  navigationBarAppearance.tintColor = [UIColor whiteColor];
  // set the title text attributes, the attributes applied to the title text in
  // a navigation bar
  // Makes sure our title text is always white.
  navigationBarAppearance.titleTextAttributes =
      @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

- (void)setupCoreDataWithRestKit {
  NSManagedObjectModel *managedObjectModel =
      [NSManagedObjectModel mergedModelFromBundles:nil];
  RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc]
      initWithManagedObjectModel:managedObjectModel];

  [managedObjectStore createPersistentStoreCoordinator];
  NSString *storePath = [RKApplicationDataDirectory()
      stringByAppendingPathComponent:@"JGBucketList.sqlite"];
  NSError *error;
  NSPersistentStore *persistentStore = [managedObjectStore
      addSQLitePersistentStoreAtPath:storePath
              fromSeedDatabaseAtPath:nil
                   withConfiguration:nil
                             options:@{
                               NSMigratePersistentStoresAutomaticallyOption :
                                   @YES,
                               NSInferMappingModelAutomaticallyOption : @YES
                             } error:&error];
  NSAssert(persistentStore, @"Failed to add persistent store with error: %@",
           error);

  // Create the managed object contexts
  [managedObjectStore createManagedObjectContexts];
  // Configure a managed object cache to ensure we do not create duplicate
  // objects
  managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc]
      initWithManagedObjectContext:managedObjectStore
                                       .persistentStoreManagedObjectContext];
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state.
  // This can occur for certain types of temporary interruptions (such as an
  // incoming phone call or SMS message) or when the user quits the application
  // and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down
  // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate
  // timers, and store enough application state information to restore your
  // application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called
  // instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state;
  // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the
  // application was inactive. If the application was previously in the
  // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Saves changes in the application's managed object context before the
  // application terminates.
}

// this method is responsible for saving the contents of our in memory store to
// the persistent store sqllite database on disk
@end
