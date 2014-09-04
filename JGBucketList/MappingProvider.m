//
//  MappingProvider.m
//  JGBucketList
//
//  Created by Joe Gesualdo on 9/3/14.
//  Copyright (c) 2014 Joe Gesualdo. All rights reserved.
//

#import "MappingProvider.h"
#import "JGBucketListItemManager.h"

@implementation MappingProvider

+ (RKObjectMapping *)bucketListItemMapping;
{
  RKEntityMapping *itemMapping = [RKEntityMapping
      mappingForEntityForName:@"JGBucketListEntry"
         inManagedObjectStore:[RKManagedObjectStore defaultStore]];

  NSDictionary *mappingDictionary = @{
    @"uuid" : @"uuid",
    @"id" : @"bucketListItemId",
    @"title" : @"title",
    @"is_completed" : @"isCompleted",
  };

  itemMapping.identificationAttributes = @[ @"uuid" ];

  [itemMapping addAttributeMappingsFromDictionary:mappingDictionary];

  return itemMapping;
}

@end
