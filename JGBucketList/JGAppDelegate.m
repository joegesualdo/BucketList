//
//  JGAppDelegate.m
//  JGBucketList
//
//  Created by Joe Gesualdo on 8/29/14.
//  Copyright (c) 2014 Joe Gesualdo. All rights reserved.
//

#import "JGAppDelegate.h"

@implementation JGAppDelegate

//Manually synthesizeing properties so they are readonly publically but read write privately
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

// this method is responsible for saving the contents of our in memory store to the persistent store sqllite database on disk
- (void)saveContext
{
    // create an NSError pointer. If something goes wrong, we can inspect this pointer to see what went wrong
    NSError *error = nil;
    // Grab our managed object context
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    // make sure our managed object context isn't nil
    if (managedObjectContext != nil) {
        // Checks to see if it has changes. If it doesn't have changes, there is no point in saving it because there were no changes and we can avoid unessesary disk access
        // Then save the context and pass in the 'out paramenter' (the error we created earlier)
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.

- (NSManagedObjectContext *)managedObjectContext
{
    //lazy load property
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    // Grab the persistent store coordinator
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    // if coordinator is nil, our app would crash when we try pass this to setPersistentStoreCoordinator below
    if (coordinator != nil) {
        //Create the managed object context
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        // set our persistent store coordinator
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    // return the managed object context
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    // grab the model url
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"JGBucketList" withExtension:@"momd"];
    // create our managed object model
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // grab the store url where our apps sqllite database it.
    //   1) applicationDocumentsDirectory - grabs the Documents directory in our sandbox
    //   2) URLByAppendingPathComponent - adds our the name of our sqllite db to the path so we have the path to the db
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"JGBucketList.sqlite"];
    
    // Create an error pointer - because when we add our persistent store to our persistent store coordinator if something goes wrong we can inspect the error if something goes wrong
    NSError *error = nil;
    // Create the persistent Store Coordinator
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    // Add the persistent store with the sqllite store type with no configuration. If this returns no, then something went wront
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        //if somehting went wrong we log the error
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        // aborting is only userful with debugging. YOU SHOULD NOT SHIP IN PRODUCTION CODE
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
