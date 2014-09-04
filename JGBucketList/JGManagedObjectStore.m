//
//  JGManagedObjectStore.m
//  JGBucketList
//
//  Created by Joe Gesualdo on 9/4/14.
//  Copyright (c) 2014 Joe Gesualdo. All rights reserved.
//

// RKManagedObjectStrore Encapsulates Core Data configuration including an NSManagedObjectModel, a NSPersistentStoreCoordinator, and a pair of NSManagedObjectContext objects.
// We created JGManagedObjectStore to control the setup of the RKManagedOBjectStore

#import "JGManagedObjectStore.h"

@implementation JGManagedObjectStore

+ (void)setupCoreDataWithRestKit {
  [self setupStore];
  [self setupPersistentStoreCoordinator];
  [self setupManagedObjectContexts];
}

+(void)setupStore{
  
  // This initializes an instance of RKManagedObjectStore
  // For all future references to this store use '[RKManagedObjectStore defaultStore]'
  NSManagedObjectModel *managedObjectModel =
      [NSManagedObjectModel mergedModelFromBundles:nil];
  RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc]
      initWithManagedObjectModel:managedObjectModel];
  // Configure a managed object cache to ensure we do not create duplicate
  // objects
  // Uncommenting because it isn't workng
  //  managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache
  //  alloc]
  //      initWithManagedObjectContext:managedObjectStore
  //                                       .persistentStoreManagedObjectContext];
}

+(void)setupPersistentStoreCoordinator{
  [[RKManagedObjectStore defaultStore] createPersistentStoreCoordinator];
  NSString *storePath = [RKApplicationDataDirectory()
      stringByAppendingPathComponent:@"JGBucketList.sqlite"];
  NSError *error;
  NSPersistentStore *persistentStore = [[RKManagedObjectStore defaultStore]
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
}

+(void)setupManagedObjectContexts{
  // Create the managed object contexts
  [[RKManagedObjectStore defaultStore] createManagedObjectContexts];
}

@end
