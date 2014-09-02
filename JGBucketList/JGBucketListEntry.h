//
//  JGBucketListEntry.h
//  JGBucketList
//
//  Created by Joe Gesualdo on 8/29/14.
//  Copyright (c) 2014 Joe Gesualdo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface JGBucketListEntry : NSManagedObject

@property(nonatomic, retain) NSString *title;
@property(nonatomic) BOOL isCompleted;
@property(nonatomic, retain) NSNumber *bucketListItemId;

// A computed property of our model instance that is computed everytime it is
// called
@property(nonatomic, readonly) NSString *sectionName;

@end
