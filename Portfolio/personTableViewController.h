//
//  personTableViewController.h
//  Portfolio
//
//  Created by Safin Ahmed on 29/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "safAppDelegate.h"
#import <CoreData/CoreData.h>

static NSString *PersonTableViewCell = @"PersonTableViewCell";

@interface personTableViewController :UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) UIBarButtonItem *barButtonAddPerson;
@property (nonatomic, strong) NSFetchedResultsController *frc;
@end
