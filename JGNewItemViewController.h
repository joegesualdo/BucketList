//
//  JGNewItemViewController.h
//  JGBucketList
//
//  Created by Joe Gesualdo on 8/29/14.
//  Copyright (c) 2014 Joe Gesualdo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGNewItemViewController : UIViewController
- (IBAction)doneWasPressed:(UIBarButtonItem *)sender;
- (IBAction)cancelWasPressed:(UIBarButtonItem *)sender;

-(void)dismissSelf;
@end
