//
//  chapter14ViewController.m
//  Portfolio
//
//  Created by Safin Ahmed on 26/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "chapter14ViewController.h"
#import "Person.h"

@interface chapter14ViewController ()

@end

@implementation chapter14ViewController

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
    
    /* Define the name and the last name we are going to set in the object */
    NSString *const kFirstName = @"Steven";
    NSString *const kLastName = @"Jobs";
    
    /* Determine where we want to archive the object */
    NSString *filePath = [NSTemporaryDirectory()
                          stringByAppendingPathComponent:@"steveJobs.txt"];
    
    /* Instantiate the object */
    Person *steveJobs = [[Person alloc] init];
    steveJobs.firstName = kFirstName;
    steveJobs.lastName = kLastName;
    
    /* Archive the object to the file */
    [NSKeyedArchiver archiveRootObject:steveJobs toFile:filePath];
    
    /* Now unarchive the same class into another object */
    Person *cloneOfSteveJobs =
    [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    /* Check if the unarchived object has the same first name and last name
     as the previously-archived object */
    if ([cloneOfSteveJobs.firstName isEqualToString:kFirstName] && [cloneOfSteveJobs.lastName isEqualToString:kLastName]){ NSLog(@"Unarchiving worked");
    }else{
        NSLog(@"Could not read the same values back. Oh no!");
    }
    
    /* We no longer need the temp file, delete it */
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    [fileManager removeItemAtPath:filePath error:nil];
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

@end
