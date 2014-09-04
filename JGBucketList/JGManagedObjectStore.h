//
//  JGManagedObjectStore.h
//  JGBucketList
//
//  Created by Joe Gesualdo on 9/4/14.
//  Copyright (c) 2014 Joe Gesualdo. All rights reserved.
//

// Encapsulates Core Data configuration including an NSManagedObjectModel, a NSPersistentStoreCoordinator, and a pair of NSManagedObjectContext objects.

#import <Foundation/Foundation.h>

@interface JGManagedObjectStore : RKManagedObjectStore

+(void)setupCoreDataWithRestKit;
+(void)setupManagedObjectContexts;
+(void)setupPersistentStoreCoordinator;
+(void)setupStore;
@end
