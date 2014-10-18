//
//  mainViewController.m
//  Portfolio
//
//  Created by Safin Ahmed on 17/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "mainViewController.h"
#import "chapter6ViewController.h"

@interface mainViewController ()

@end

@implementation mainViewController

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

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    /* Check if there is some text and if there isn't, display a message
     to the user and prevent her from going to the next screen */
    if ([identifier isEqualToString:@"pushSecondViewController"])
    {
        NSLog(@"ESTOU");
    }
    return YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushSecondViewController"])
    {
        chapter6ViewController *nextController = segue.destinationViewController;
        [nextController setText:@"CONSEGUI"];
    }
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
