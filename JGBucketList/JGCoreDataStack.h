//
//  JGCoreDataStack.h
//  JGBucketList
//
//  Created by Joe Gesualdo on 8/29/14.
//  Copyright (c) 2014 Joe Gesualdo. All rights reserved.
//
// ================================
// This class will encapsulate everything we need in order to access core data. This creates a reuasable object that you can resuse throughout other applications you build.
// This object is a sigleton - it is an object that exists only one in an application
// ================================

#import <Foundation/Foundation.h>

@interface JGCoreDataStack : NSObject

// Returns a type of whatever instance it is (i.e. instance of JGCoreDataStack)
+(instancetype)defaultStack;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
