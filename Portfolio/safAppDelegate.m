//
//  safAppDelegate.m
//  Portfolio
//
//  Created by Safin Ahmed on 12/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "safAppDelegate.h"
#import "safViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface safAppDelegate () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *myLocationManager;
@property (nonatomic, unsafe_unretained, getter=isExecutingInBackground) BOOL executingInBackground;


@end


@implementation safAppDelegate

UIBackgroundTaskIdentifier backgroundTaskIdentifier;
NSTimer *myTimer;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"mymodel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ProjectName.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



- (void) timerMethod:(NSTimer *)paramSender
{
    NSTimeInterval backgroundTimeRemaining =
    [[UIApplication sharedApplication] backgroundTimeRemaining];
    if (backgroundTimeRemaining == DBL_MAX)
    {
        NSLog(@"Background Time Remaining = Undetermined");
    }
    else{
        NSLog(@"Background Time Remaining = %.02f Seconds",
              backgroundTimeRemaining);
    }
}

- (BOOL) isMultitaskingSupported{
    BOOL result = NO;
    if ([[UIDevice currentDevice]
         respondsToSelector:@selector(isMultitaskingSupported)]){ result = [[UIDevice currentDevice] isMultitaskingSupported];
    }
    return result;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"applicationDidEnterBackground");
    
//    if ([self isMultitaskingSupported] == NO)
//    {
//        return;
//    }
//    
//    myTimer =
//    [NSTimer scheduledTimerWithTimeInterval:1.0f
//                                     target:self selector:@selector(timerMethod:) userInfo:nil
//                                    repeats:YES];
//    backgroundTaskIdentifier =
//    [application beginBackgroundTaskWithExpirationHandler:^(void) {
//        [self endBackgroundTask];
//    }];
    
    self.executingInBackground = YES;
    /* Reduce the accuracy to ease the strain on
     iOS while we are in the background */
//    self.myLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
}

- (void) endBackgroundTask
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    __weak safAppDelegate *weakSelf = self;
    dispatch_async(mainQueue, ^(void)
    {
        safAppDelegate *strongSelf = weakSelf;
        if (strongSelf != nil)
        {
        [myTimer invalidate];
        [[UIApplication sharedApplication]
         endBackgroundTask:backgroundTaskIdentifier];
        backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    }
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        NSLog(@"applicationWillEnterForeground");
//    if (backgroundTaskIdentifier != UIBackgroundTaskInvalid)
//    {
//        [self endBackgroundTask];
//    }
    
    self.executingInBackground = NO;
    /* Now that our app is in the foreground again, let's increase the location
     detection accuracy */
    self.myLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    //NSLog(@"Updated Location %@",newLocation);
    if ([self isExecutingInBackground]){
        /* We are in the background. Do not do any heavy processing */
    }else
    {
        /* We are in the foreground. Do any processing that you wish */
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        NSLog(@"applicationDidBecomeActive");
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        NSLog(@"applicationWillTerminate");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) handleSettingsChanged:(NSNotification *)paramNotification{
    NSLog(@"Settings changed");
    NSLog(@"Notification Object = %@", paramNotification.object);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //    [application setMinimumBackgroundFetchInterval:
    //     UIApplicationBackgroundFetchIntervalMinimum];
    
    self.myLocationManager = [[CLLocationManager alloc] init];
    self.myLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.myLocationManager.delegate = self;
    [self.myLocationManager startUpdatingLocation];
    
    NSLog(@"didFinishLaunchingWithOptions");
    if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey] != nil)
    {
        NSLog(@"WAS LOCAL");
        UILocalNotification *notification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
        [self application:application didReceiveLocalNotification:notification];
    }
    else
        [self scheduleLocalNotification];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(handleSettingsChanged:)
     name:NSUserDefaultsDidChangeNotification
     object:nil];
    
    return YES;
}

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"Did Receive Local Notification");
    NSString *key1Value = notification.userInfo[@"Key 1"];
    NSString *key2Value = notification.userInfo[@"Key 2"];
    if ([key1Value length] > 0 && [key2Value length] > 0)
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:nil
                                   message:@"Handling the local notification"
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [alert show];
    }
}

- (void) scheduleLocalNotification
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    /* Time and timezone settings */
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:8.0];
    notification.timeZone = [[NSCalendar currentCalendar] timeZone];
    notification.alertBody =
    NSLocalizedString(@"A new item is downloaded.", nil);
    /* Action settings */
    notification.hasAction = YES;
    notification.alertAction = NSLocalizedString(@"View", nil);
    /* Badge settings */
    notification.applicationIconBadgeNumber =
        [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    /* Additional information, user info */
    notification.userInfo = @{
                                @"Key 1" : @"Value 1",
                                @"Key 2" : @"Value 2"};
    /* Schedule the notification */
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
