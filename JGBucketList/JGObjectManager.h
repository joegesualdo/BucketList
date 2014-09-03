//
//  JGObjectManager.h
//  JGBucketList
//
//  Created by Joe Gesualdo on 9/3/14.
//  Copyright (c) 2014 Joe Gesualdo. All rights reserved.
//

#import "RKObjectManager.h"

@interface JGObjectManager : RKObjectManager

+ (instancetype)sharedManager;

- (void)setupRequestDescriptors;
- (void)setupResponseDescriptors;

@end
