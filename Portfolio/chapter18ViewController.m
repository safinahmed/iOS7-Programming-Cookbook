//
//  chapter18ViewController.m
//  Portfolio
//
//  Created by Safin Ahmed on 29/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "chapter18ViewController.h"
#import <CoreData/CoreData.h>
#import "CoreData/Person.h"
#import "safAppDelegate.h"

@interface chapter18ViewController ()


@end

@implementation chapter18ViewController

NSManagedObjectContext *managedObjectContext;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL) createNewPersonWithFirstName:(NSString *)paramFirstName lastName:(NSString *)paramLastName
                                  age:(NSUInteger)paramAge
{
    BOOL result = NO;
    
    if ([paramFirstName length] == 0 || [paramLastName length] == 0)
    {
        NSLog(@"First and Last names are mandatory.");
        return NO;
    }
    
    Person *newPerson = [NSEntityDescription
                         insertNewObjectForEntityForName:@"Person"
                         inManagedObjectContext:managedObjectContext];
    if (newPerson == nil)
    {
        NSLog(@"Failed to create the new person.");
        return NO;
    }
    
    newPerson.firstName = paramFirstName;
    newPerson.lastName = paramLastName;
    newPerson.age = @(paramAge);
    
    NSError *savingError = nil;
    if ([managedObjectContext save:&savingError])
    {
        return YES;
    }
    else
    {
        NSLog(@"Failed to save the new person. Error = %@", savingError);
    }
    return result;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    safAppDelegate *appDelegate = (safAppDelegate*)[[UIApplication sharedApplication] delegate];
     
    managedObjectContext = [appDelegate managedObjectContext];
    
    
    [self createNewPersonWithFirstName:@"Anthony"
                              lastName:@"Robbins"
                                   age:51];
    [self createNewPersonWithFirstName:@"Richard"
                              lastName:@"Branson"
                                   age:61];
    /* Tell the request that we want to read the
     contents of the Person entity */
    /* Create the fetch request first */
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]
                                    initWithEntityName:@"Person"];
    NSSortDescriptor *ageSort =
    [[NSSortDescriptor alloc] initWithKey:@"age"
                                ascending:YES];
    NSSortDescriptor *firstNameSort =
    [[NSSortDescriptor alloc] initWithKey:@"firstName"
                                ascending:YES];
    fetchRequest.sortDescriptors = @[ageSort, firstNameSort];
   
    
    NSError *requestError = nil;
    /* And execute the fetch request on the context */
    NSArray *persons = [managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    /* Make sure we get the array */
     if ([persons count] > 0)   {
         /* Go through the persons array one by one */
         NSUInteger counter = 1;
         for (Person *thisPerson in persons)
         {
             //DELETE PERSON
//             [managedObjectContext deleteObject:thisPerson];
//             NSError *savingError = nil;
//             if ([thisPerson isDeleted])
//             {
//                 NSLog(@"Successfully deleted the last person...");
//                 NSError *savingError = nil;
//                 if ([managedObjectContext save:&savingError])
//                 {
//                     NSLog(@"Successfully saved the context.");
//                 }
//                 else
//                 {
//                         NSLog(@"Failed to save the context.");
//                 }
//             }
//             else
//             {
//                 NSLog(@"Failed to delete the last person.");
//             }
             
             NSLog(@"Person %lu First Name = %@", (unsigned long)counter,
                   thisPerson.firstName);
             NSLog(@"Person %lu Last Name = %@", (unsigned long)counter,
                   thisPerson.lastName);
             NSLog(@"Person %lu Age = %ld", (unsigned long)counter,
                   (unsigned long)[thisPerson.age unsignedIntegerValue]); counter++;
         }
     }
    else
     {
         NSLog(@"Could not find any Person entities in the context.");
     }
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
