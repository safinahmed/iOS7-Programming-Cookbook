//
//  safViewController.m
//  Portfolio
//
//  Created by Safin Ahmed on 12/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "safViewController.h"
#import "StringReverserActivity.h"
#import "saf2ViewController.h"
#import "tabbedViewController.h"
#import "scrollViewController.h"

@interface safViewController () <UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIWebViewDelegate>

@property (nonatomic,strong) UISwitch *mainSwitch;
@property (nonatomic, strong) UIPickerView *myPicker;
@property (nonatomic, strong) UIDatePicker *myDatePicker;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UISegmentedControl *mySegmentedControl;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *buttonShare;
@property (nonatomic, strong) UIActivityViewController *activityViewController;
@property(nonatomic, strong) UIWebView *myWebView;

@property (nonatomic, strong) UIButton *displaySecondViewController;
@property (nonatomic, strong) UIButton *displayAlertView;
@property (nonatomic, strong) UIButton *displayDatePickerView;
@property (nonatomic, strong) UIButton *displayPickerView;
@property (nonatomic, strong) UIButton *tabbedViewController;
@property (nonatomic, strong) UIButton *scrolledViewController;
@property (nonatomic, strong) UIButton *displayWebView;

@end

@implementation safViewController

bool hasDatePicker, hasViewPicker = false;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.displayAlertView = [UIButton
                              buttonWithType:UIButtonTypeSystem];
    [self.displayAlertView
     setTitle:@"Alert"
     forState:UIControlStateNormal];
    [self.displayAlertView sizeToFit];
    self.displayAlertView.center = CGPointMake(self.view.center.x,80);
    [self.displayAlertView
     addTarget:self action:@selector(alertView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.displayAlertView];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self setupSwitch];
    [self setupPicker];
    [self setupDatePicker];
    [self setupRangePicker];
    [self setupSegmentedControl];
    [self createTextField];
    [self createButton];
    [self setupSecondControllerButton];
    [self setupTabbedControllerButton];
    [self setupScrolledControllerButton];
    [self setupWebViewButton];
    
    self.title = @"FIRST CONTROLLER";
    
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
        NSLog(@"webViewDidFinishLoad");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
        NSLog(@"didFailLoadWithError");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (IBAction)performWebView:(id)sender
{
    self.myWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.myWebView.scalesPageToFit = YES;
    self.myWebView.delegate = self;
    [self.view addSubview:self.myWebView];
    NSURL *url = [NSURL URLWithString:@"http://www.apple.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.myWebView loadRequest:request];
}

-(void) setupWebViewButton
{
    self.displayWebView = [UIButton
                                   buttonWithType:UIButtonTypeSystem];
    [self.displayWebView
     setTitle:@"Web View"
     forState:UIControlStateNormal];
    [self.displayWebView sizeToFit];
    self.displayWebView.center = CGPointMake(self.view.center.x,430);
    [self.displayWebView
     addTarget:self action:@selector(performWebView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.displayWebView];
}

- (IBAction)performDisplayScrollediewController:(id)sender
{
    scrollViewController *secondController = [[scrollViewController alloc] initWithNibName:nil bundle:NULL];
    [self.navigationController pushViewController:secondController animated:YES];
}

-(void) setupScrolledControllerButton
{
    self.scrolledViewController = [UIButton
                                        buttonWithType:UIButtonTypeSystem];
    [self.scrolledViewController
     setTitle:@"Scrolled View"
     forState:UIControlStateNormal];
    [self.scrolledViewController sizeToFit];
    self.scrolledViewController.center = CGPointMake(self.view.center.x,400);
    [self.scrolledViewController
     addTarget:self action:@selector(performDisplayScrollediewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.scrolledViewController];
}

- (IBAction)performDisplayTabViewController:(id)sender
{
    saf2ViewController *secondController = [[saf2ViewController alloc] initWithNibName:nil bundle:NULL];
    tabbedViewController *tabVC = [[tabbedViewController alloc] initWithNibName:nil bundle:nil];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[tabVC,
                                           secondController
                                           ]];
    
    [self.navigationController pushViewController:tabBarController animated:YES];
}

-(void) setupTabbedControllerButton
{
    self.tabbedViewController = [UIButton
                                        buttonWithType:UIButtonTypeSystem];
    [self.tabbedViewController
     setTitle:@"TabbedController"
     forState:UIControlStateNormal];
    [self.tabbedViewController sizeToFit];
    self.tabbedViewController.center = CGPointMake(self.view.center.x,370);
    [self.tabbedViewController
     addTarget:self action:@selector(performDisplayTabViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tabbedViewController];
}

-(void) setupSecondControllerButton
{
    self.displaySecondViewController = [UIButton
                                    buttonWithType:UIButtonTypeSystem];
    [self.displaySecondViewController
        setTitle:@"Custom Title Bar"
        forState:UIControlStateNormal];
    [self.displaySecondViewController sizeToFit];
    self.displaySecondViewController.center = CGPointMake(self.view.center.x,340);
    [self.displaySecondViewController
        addTarget:self action:@selector(performDisplaySecondViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.displaySecondViewController];
}

- (IBAction)performDisplaySecondViewController:(id)sender
{
    saf2ViewController *secondController = [[saf2ViewController alloc] initWithNibName:nil bundle:NULL];
    [self.navigationController pushViewController:secondController animated:YES];
}


- (void) handleShare:(id)paramSender
{
    if ([self.textField.text length] == 0)
    {
        NSString *message = @"Please enter a text and then press Share";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
            message:message
            delegate:nil
            cancelButtonTitle:@"OK"
            otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    NSArray *itemsToShare = @[
                              @"Item 1",
                              @"Item 2",
                              @"Item 3",
                              ];
    
    self.activityViewController = [[UIActivityViewController alloc]
                                   initWithActivityItems:itemsToShare
                                   applicationActivities:@[[StringReverserActivity new]]];
    
    [self presentViewController:self.activityViewController
                       animated:YES
                     completion:^{
                         /* Nothing for now */
                     }];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) createTextField{
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(20.0f,
                                                                   260.0f,
                                                                   280.0f,
                                                                   30.0f)];
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.placeholder = @"Enter text to share...";
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
}
    - (void) createButton{
        self.buttonShare = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.buttonShare.translatesAutoresizingMaskIntoConstraints = NO;
        self.buttonShare.frame = CGRectMake(20.0f, 290.0f, 280.0f, 44.0f);
        [self.buttonShare setTitle:@"Share" forState:UIControlStateNormal];
        [self.buttonShare addTarget:self action:@selector(handleShare:)
                   forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.buttonShare];
    }

-(void) setupSegmentedControl
{
    NSArray *segments = [[NSArray alloc] initWithObjects:
                     @"iPhone",
                     @"iPad", //takes images [UIImage imageNamed:@"iPad"]
                     @"iPod",
                     @"iMac", nil];
    self.mySegmentedControl = [[UISegmentedControl alloc]
                           initWithItems:segments];
    self.mySegmentedControl.center =  CGPointMake(self.view.center.x,150);
    
    
    [self.mySegmentedControl addTarget:self action:@selector(segmentChanged:)
                      forControlEvents:UIControlEventValueChanged];
    
    self.mySegmentedControl.momentary = YES; //Doesnt remain selected
    
    [self.view addSubview:self.mySegmentedControl];
}

- (void) segmentChanged:(UISegmentedControl *)paramSender
{
    if ([paramSender isEqual:self.mySegmentedControl])
    {
        NSInteger selectedSegmentIndex = [paramSender selectedSegmentIndex];
        NSString  *selectedSegmentText = [paramSender titleForSegmentAtIndex:selectedSegmentIndex];
        NSLog(@"Segment %ld with %@ text is selected", (long)selectedSegmentIndex, selectedSegmentText);
    }
}

- (void) sliderValueChanged:(UISlider *)paramSender{
    if ([paramSender isEqual:self.slider])
    {
        NSLog(@"New value = %f", paramSender.value);
    }
}

-(void) setupRangePicker
{
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(0.0f,
                                                         0.0f,
                                                         200.0f,
                                                         23.0f)];
    self.slider.center =  CGPointMake(self.view.center.x,200);
    self.slider.minimumValue = 0.0f;
    self.slider.maximumValue = 100.0f;
    self.slider.value = self.slider.maximumValue / 2.0;
    self.slider.continuous = NO; //Only trigger action when thumb stops moving
    
    /* Set the tint color of the minimum value 
       Images are possible but don't work very well in iOS 7
     */
    self.slider.minimumTrackTintColor = [UIColor redColor]; /* Set the tint color of the thumb */
    self.slider.maximumTrackTintColor = [UIColor greenColor]; /* Set the tint color of the maximum value */
    self.slider.thumbTintColor = [UIColor blackColor];
    
    [self.slider addTarget:self action:@selector(sliderValueChanged:)
          forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.slider];
}

- (void) datePickerDateChanged:(UIDatePicker *)paramDatePicker{
    if ([paramDatePicker isEqual:self.myDatePicker])
    {
        NSLog(@"Selected date = %@", paramDatePicker.date);
    }
}

-(void) setupDatePicker
{
    self.myDatePicker = [[UIDatePicker alloc] init];
    self.myDatePicker.center = self.view.center;
    self.myDatePicker.datePickerMode = UIDatePickerModeDate;
    [self.myDatePicker addTarget:self action:@selector(datePickerDateChanged:)
                forControlEvents:UIControlEventValueChanged];
    
    NSTimeInterval oneYearTime = 365 * 24 * 60 * 60;
    NSDate *todayDate = [NSDate date];
    NSDate *oneYearFromToday = [todayDate
                                dateByAddingTimeInterval:oneYearTime];
    
    NSDate *twoYearsFromToday = [todayDate
                                 dateByAddingTimeInterval:2 * oneYearTime];
    self.myDatePicker.minimumDate = oneYearFromToday;
    self.myDatePicker.maximumDate = twoYearsFromToday;
    
    self.displayDatePickerView = [UIButton
                                        buttonWithType:UIButtonTypeSystem];
    [self.displayDatePickerView
     setTitle:@"Date Picker"
     forState:UIControlStateNormal];
    [self.displayDatePickerView sizeToFit];
    self.displayDatePickerView.center = CGPointMake(self.view.center.x,120);
    [self.displayDatePickerView
     addTarget:self action:@selector(datePickerView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.displayDatePickerView];
}

- (IBAction) datePickerView:(id)sender {
    NSLog(@"%lu",(unsigned long)[[self.view subviews] count]);
    [self.view addSubview:self.myDatePicker];
}

- (void) setupPicker {
    self.myPicker = [[UIPickerView alloc] init];
    self.myPicker.center = self.view.center;
    self.myPicker.dataSource = self;
    self.myPicker.delegate = self;
    
    //doesn't work on iOS 7
    self.myPicker.showsSelectionIndicator = YES;
    
    self.displayPickerView = [UIButton
                                  buttonWithType:UIButtonTypeSystem];
    [self.displayPickerView
     setTitle:@"Picker"
     forState:UIControlStateNormal];
    [self.displayPickerView sizeToFit];
    self.displayPickerView.center = CGPointMake(self.view.center.x,100);
    [self.displayPickerView
     addTarget:self action:@selector(pickerView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.displayPickerView];
}

- (IBAction) pickerView:(id)sender {
    [self.view addSubview:self.myPicker];

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if ([pickerView isEqual:self.myPicker])
    {
        return 1;
    }
    return 0;
}
-(NSInteger) pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component{
    if ([pickerView isEqual:self.myPicker])
    {
        return 10;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.myPicker])
    {
    /* Row is zero-based and we want the first row (with index 0) to be rendered as Row 1, so we have to +1 every row index */ return [NSString stringWithFormat:@"Row %ld", (long)row + 1];
    }
    return nil;
}


- (void) setupSwitch {
    
    /* Create the switch */
    self.mainSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    self.mainSwitch.center = self.view.center;
    
    /* Customize the switch */
    
    /* Adjust the off-mode tint color */
    self.mainSwitch.tintColor = [UIColor redColor];
    /* Adjust the on-mode tint color */
    self.mainSwitch.onTintColor = [UIColor brownColor];
    /* Also change the knob's tint color */
    self.mainSwitch.thumbTintColor = [UIColor greenColor];
    
    /* Customize doesn't work for iOS 7
    self.mainSwitch.onImage = [UIImage imageNamed:@"On"];
    self.mainSwitch.offImage = [UIImage imageNamed:@"Off"];
    */
    
    //Animated doesn't seem to work
    [self.mainSwitch setOn:YES animated:TRUE];
    
    [self.mainSwitch addTarget:self action:@selector(switchIsChanged:)
              forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.mainSwitch];
    
}

- (void) switchIsChanged:(UISwitch *)paramSender{
    NSLog(@"Sender is = %@", paramSender);
    if ([paramSender isOn]){
        NSLog(@"The switch is turned on.");
    }
    else{
        NSLog(@"The switch is turned off.");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)alertView:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Alert"
                              message:@"You've been delivered an alert"
                              delegate:self
                              cancelButtonTitle:@"Cancel" //can be nil
                              otherButtonTitles:@"Ok", nil]; //expands vertically automatically
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSLog(@"%ld - %@",(long)buttonIndex, [[alertView textFieldAtIndex:0] text]);
    if (buttonIndex == 0) {
        NSLog(@"User pressed the Cancel button.");
    }
    else if (buttonIndex == 1) {
        NSLog(@"User pressed the OK button.");
    }
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"willDissmiss");
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"didDissmiss");
}



@end
