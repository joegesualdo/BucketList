//
//  JGNewItemViewController.h
//  JGBucketList
//
//  Created by Joe Gesualdo on 8/29/14.
//  Copyright (c) 2014 Joe Gesualdo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGBucketListEntry;

@interface JGItemViewController : UIViewController

- (IBAction)doneWasPressed:(UIBarButtonItem *)sender;
- (IBAction)cancelWasPressed:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property(strong, nonatomic)JGBucketListEntry *entry;

-(void)dismissSelf;
@end
