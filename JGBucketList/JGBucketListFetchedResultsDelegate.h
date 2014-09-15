//
//  JGBucketListFetchedResultsDelegate.h
//  JGBucketList
//
//  Created by Joe Gesualdo on 9/15/14.
//  Copyright (c) 2014 Joe Gesualdo. All rights reserved.
//

// This is how we sepertate the delegate from the controller to it's own class:
// https://github.com/mdarnall/githubtrending

#import <Foundation/Foundation.h>

@interface JGBucketListFetchedResultsDelegate : NSObject <NSFetchedResultsControllerDelegate>

// We create this property so that we can pass the table view from the controller to this delegate class
@property(strong, nonatomic)UITableView *tableView;

@end
