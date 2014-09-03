//
//  JGBucketListItemManager.m
//  JGBucketList
//
//  Created by Joe Gesualdo on 9/3/14.
//  Copyright (c) 2014 Joe Gesualdo. All rights reserved.
//

#import "JGBucketListItemManager.h"
#import "MappingProvider.h"

static JGBucketListItemManager *sharedManager = nil;

@implementation JGBucketListItemManager

+ (instancetype)sharedManager {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{ sharedManager = [super sharedManager]; });

  return sharedManager;
}

- (void)loadItems {
  [self getObjectsAtPath:@"/bucket_list_items.json"
      parameters:nil
      success:^(RKObjectRequestOperation *operation,
                RKMappingResult *mappingResult) {
          NSArray *arout = mappingResult.array;
          NSLog(@"items: %@", arout);
      }
      failure:^(RKObjectRequestOperation *operation,
                NSError *error) { NSLog(@"Error response': %@", error); }];
}
- (void)setupResponseDescriptors {
  [super setupResponseDescriptors];

  RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
      responseDescriptorWithMapping:[MappingProvider bucketListItemMapping]
                             method:RKRequestMethodGET
                        pathPattern:@"/bucket_list_items.json"
                            keyPath:nil
                        statusCodes:[NSIndexSet indexSetWithIndex:200]];

  [self addResponseDescriptor:responseDescriptor];
}
@end
