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

static JGBucketListItemManager *sharedManager = nil;

@implementation JGBucketListItemManager

+ (instancetype)sharedManager {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{ sharedManager = [super sharedManager]; });

  return sharedManager;
}

- (void)loadItems {
  [self getObjectsAtPath:@"/bucket_list_items"
      parameters:nil
      success:^(RKObjectRequestOperation *operation,
                RKMappingResult *mappingResult) {
          NSArray *arout = mappingResult.array;
          NSLog(@"items: %@", arout);
      }
      failure:^(RKObjectRequestOperation *operation,
                NSError *error) { NSLog(@"Error response': %@", error); }];
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
- (void)setupResponseDescriptors {
  [super setupResponseDescriptors];

  NSIndexSet *statusCodes =
      RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);

  RKResponseDescriptor *responseDescriptor1 = [RKResponseDescriptor
      responseDescriptorWithMapping:[MappingProvider bucketListItemMapping]
                             method:RKRequestMethodGET
                        pathPattern:@"/bucket_list_items"
                            keyPath:nil
                        statusCodes:statusCodes];

  [self addResponseDescriptor:responseDescriptor1];

  RKResponseDescriptor *responseDescriptor2 = [RKResponseDescriptor
      responseDescriptorWithMapping:[MappingProvider bucketListItemMapping]
                             method:RKRequestMethodAny
                        pathPattern:@"/bucket_list_items/:bucketListItemId"
                            keyPath:nil
                        statusCodes:[NSIndexSet indexSetWithIndex:201]];
  [self addResponseDescriptor:responseDescriptor2];

  RKResponseDescriptor *responseDescriptor3 = [RKResponseDescriptor
      responseDescriptorWithMapping:[MappingProvider bucketListItemMapping]
                             method:RKRequestMethodAny
                        pathPattern:@"/bucket_list_items/:bucketListItemId"
                            keyPath:nil
                        statusCodes:[NSIndexSet indexSetWithIndex:200]];
  [self addResponseDescriptor:responseDescriptor3];
}
- (void)setupRequestDescriptors {
  [super setupRequestDescriptors];

  //  NSIndexSet *statusCodes =
  //      RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
  //  RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
  //      responseDescriptorWithMapping:
  //          [[MappingProvider bucketListItemMapping] inverseMapping]
  //                             method:RKRequestMethodAny
  //                        pathPattern:@"/bucket_list_items.json"
  //                            keyPath:nil
  //                        statusCodes:statusCodes];

  RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor
      requestDescriptorWithMapping:
          [[MappingProvider bucketListItemMapping] inverseMapping]
                       objectClass:[JGBucketListEntry class]
                       rootKeyPath:nil
                            method:RKRequestMethodAny];

  [self addRequestDescriptor:requestDescriptor];
}
@end
