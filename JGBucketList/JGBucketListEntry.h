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

@property (nonatomic, retain) NSString * title;
@property (nonatomic) BOOL isCompleted;

@end
