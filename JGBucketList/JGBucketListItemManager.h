//
//  JGBucketListItemManager.h
//  JGBucketList
//
//  Created by Joe Gesualdo on 9/3/14.
//  Copyright (c) 2014 Joe Gesualdo. All rights reserved.
//

#import "JGObjectManager.h"
#import "JGBucketListEntry.h"

@interface JGBucketListItemManager : JGObjectManager

+ (instancetype)sharedManager;
- (void)loadItems;
- (void)postItem:(JGBucketListEntry *)item withParams:(NSDictionary *)params;
- (void)setupResponseDescriptors;
- (void)setupRequestDescriptors;

@end
