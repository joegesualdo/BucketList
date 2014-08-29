//
//  JGNewItemViewController.m
//  JGBucketList
//
//  Created by Joe Gesualdo on 8/29/14.
//  Copyright (c) 2014 Joe Gesualdo. All rights reserved.
//

#import "JGNewItemViewController.h"
#import "JGBucketListEntry.h"
#import "JGCoreDataStack.h"

@interface JGNewItemViewController ()

@end

@implementation JGNewItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneWasPressed:(UIBarButtonItem *)sender {
    [self dismissSelf];
    [self insertBucketListItem];
}

- (IBAction)cancelWasPressed:(UIBarButtonItem *)sender {
    [self dismissSelf];
}

-(void)dismissSelf
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

// Create a new BucketListEmtry instance and insert it into our managed object context. Then save the context.
-(void)insertBucketListItem{
    // Grab the applications core data stack
    JGCoreDataStack *coreDataStack =[JGCoreDataStack defaultStack];
    // define bucket list entry
    // inserts a new entity into our core data stack environment
    JGBucketListEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"JGBucketListEntry" inManagedObjectContext:coreDataStack.managedObjectContext];
    // configure that entry
    entry.title = self.textField.text;
    entry.isCompleted = NO;
    //save core data stack because a new entity we want to save
    [coreDataStack saveContext];
    
}
@end
