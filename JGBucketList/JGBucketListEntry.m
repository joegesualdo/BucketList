//
//  JGBucketListEntry.m
//  JGBucketList
//
//  Created by Joe Gesualdo on 8/29/14.
//  Copyright (c) 2014 Joe Gesualdo. All rights reserved.
//

#import "JGBucketListEntry.h"

@implementation JGBucketListEntry

// dynamic because CoreData will add getters and setters at runtime
@dynamic title;
@dynamic isCompleted;
@dynamic bucketListItemId;

// A computed property of our model instance that is computed everytime it is
// called
- (NSString *)sectionName {
  return self.isCompleted ? @"Completed" : @"Not Complete";
}

@end
