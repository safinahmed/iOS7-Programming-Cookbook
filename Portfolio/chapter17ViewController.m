//
//  chapter17ViewController.m
//  Portfolio
//
//  Created by Safin Ahmed on 27/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "chapter17ViewController.h"

@interface chapter17ViewController ()


@property (nonatomic, strong) UIButton *button;

@end

@implementation chapter17ViewController

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
    NSLog(@"Notifications Did Load");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.button
     setTitle:@"Local Notification"
     forState:UIControlStateNormal];
    [self.button sizeToFit];
    self.button.center = CGPointMake(self.view.center.x,370);
    [self.button
     addTarget:self action:@selector(performNotification:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];

    
}

-(void)performNotification:(id)sender
{
    [self scheduleLocalNotification];
    
}

- (void) scheduleLocalNotification{
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
    notification.userInfo = @{@"Key 1" : @"Value 1",
                              @"Key 2" : @"Value 2"};
    /* Schedule the notification */
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
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
