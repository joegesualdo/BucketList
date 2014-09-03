//
//  MappingProvider.m
//  JGBucketList
//
//  Created by Joe Gesualdo on 9/3/14.
//  Copyright (c) 2014 Joe Gesualdo. All rights reserved.
//

#import "MappingProvider.h"

@implementation MappingProvider

+ (RKObjectMapping *)bucketListItemMapping;
{
  RKEntityMapping *itemMapping =
      [RKEntityMapping mappingForEntityForName:@"JGBucketListEntry"
                          inManagedObjectStore:manager.managedObjectStore];
  NSDictionary *mappingDictionary = @{
    @"id" : @"bucketListItemId",
    @"title" : @"title",
    @"is_completed" : @"isCompleted",
  };
  [itemMapping addAttributeMappingsFromDictionary:mappingDictionary];

  itemMapping.identificationAttributes = @[ @"bucketListItemId" ];

  return itemMapping;
}
@end
