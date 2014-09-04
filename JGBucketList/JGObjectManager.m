//
//  JGObjectManager.m
//  JGBucketList
//
//  Created by Joe Gesualdo on 9/3/14.
//  Copyright (c) 2014 Joe Gesualdo. All rights reserved.
//

// How to get our CoreData context using restkit?
// NSManagedObjectContext *context =[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext

// How to insert a new item into our context?
// JGBucketListEntry *entry = [context insertNewObjectForEntityForName:@"JGBucketListEntry"];

// How to save a cotext after we add something to it?
// [context saveToPersistentStore:&error];


#import "JGObjectManager.h"
#import "MappingProvider.h"

@implementation JGObjectManager

+ (instancetype)sharedManager {

  // Enable Activity Indicator Spinner
  [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

  NSURL *url = [NSURL URLWithString:@"http://localhost:3000"];
  JGObjectManager *sharedManager = [self managerWithBaseURL:url];

  sharedManager.requestSerializationMIMEType = RKMIMETypeJSON;
  sharedManager.managedObjectStore = [RKManagedObjectStore defaultStore];
  /*
   THIS CLASS IS MAIN POINT FOR CUSTOMIZATION:
   - setup HTTP headers that should exist on all HTTP Requests
   - override methods in this class to change default behavior for all HTTP
   Requests
   - define methods that should be available across all object managers
   */

  [sharedManager setupRequestDescriptors];
  [sharedManager setupResponseDescriptors];

  //  [sharedManager.HTTPClient
  //      setDefaultHeader:@"Authorization"
  //                 value:[NSString stringWithFormat:@"token %@",
  //                                                  PERSONAL_ACCESS_TOKEN]];

  return sharedManager;
}

- (void)setupRequestDescriptors {
}

- (void)setupResponseDescriptors {
}

@end
