//
//  JGBucketListItemManager.m
//  JGBucketList
//
//  Created by Joe Gesualdo on 9/3/14.
//  Copyright (c) 2014 Joe Gesualdo. All rights reserved.
//

#import "JGBucketListItemManager.h"
#import "MappingProvider.h"
#import "JGBucketListEntry.h"

// creates a static variable for sharedManager, which means it will only be created once
static JGBucketListItemManager *sharedManager = nil;

@implementation JGBucketListItemManager

+ (instancetype)sharedManager {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedManager = [super sharedManager];
  });

  return sharedManager;
}

- (void)loadItems {
  [self getObjectsAtPath:@"/bucket_list_items"
      parameters:nil
      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSArray *arout = mappingResult.array;
        NSLog(@"items: %@", arout);
      }
      failure:^(RKObjectRequestOperation *operation, NSError *error){
        NSLog(@"Error response': %@", error);
      }];
}

- (void)postItem:(JGBucketListEntry *)item withParams:(NSDictionary *)params {
  [sharedManager postObject:item
      path:@"/bucket_list_items"
      parameters:params
      success:^(RKObjectRequestOperation *operation,
                RKMappingResult *mappingResult) {
          NSLog(@"SUCCESS: %@", mappingResult.array);
      }
      failure:^(RKObjectRequestOperation *operation,
                NSError *error) { NSLog(@"FAILED: %@", error); }];
}

// ============================================
#pragma mark - Response Descriptors 
// ============================================

- (void)setupResponseDescriptors {
  // call setupResponseDescriptors from JGObjectManager
  [super setupResponseDescriptors];
  
  // initialize an array where we will store all oru response descriptors
  NSMutableArray *responseDescriptorsArray = [@[] mutableCopy];

  NSIndexSet *successfulStatusCodes =
      RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);

  // Response Descriptor for all items
  RKResponseDescriptor *itemsResponseDescriptor = [RKResponseDescriptor
      responseDescriptorWithMapping:[MappingProvider bucketListItemMapping]
                             method:RKRequestMethodGET
                        pathPattern:@"/bucket_list_items"
                            keyPath:nil
                        statusCodes:successfulStatusCodes];
  // Add response descriptor to array
  [responseDescriptorsArray addObject:itemsResponseDescriptor];

  // Response Descriptor for a single items
  RKResponseDescriptor *itemResponseDescriptor = [RKResponseDescriptor
      responseDescriptorWithMapping:[MappingProvider bucketListItemMapping]
                             method:RKRequestMethodAny
                        pathPattern:@"/bucket_list_items/:bucketListItemId"
                            keyPath:nil
                        statusCodes:successfulStatusCodes];
  // Add response descriptor to array
  [responseDescriptorsArray addObject:itemResponseDescriptor];
  
  // Register all our response descriptors
  [self addResponseDescriptorsFromArray: responseDescriptorsArray];

}

// ============================================
#pragma mark - Request Descriptors
// ============================================

- (void)setupRequestDescriptors {
  // call setupRequestDescriptors from JGObjectManager
  [super setupRequestDescriptors];

  // initialize an array where we will store all oru request descriptors
  NSMutableArray *requestDescriptorsArray = [@[] mutableCopy];

  // Request Descriptor for an item
  RKRequestDescriptor *itemRequestDescriptor =
  [RKRequestDescriptor requestDescriptorWithMapping:[[MappingProvider bucketListItemMapping] inverseMapping]
                       objectClass:[JGBucketListEntry class]
                       rootKeyPath:nil
                            method:RKRequestMethodAny];
  // Add request descriptor to array
  [requestDescriptorsArray addObject:itemRequestDescriptor];

  // Register all our requests descriptors
  [self addRequestDescriptorsFromArray:requestDescriptorsArray];
}
@end
