//
//  saf2ViewController.m
//  Portfolio
//
//  Created by Safin Ahmed on 12/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "saf2ViewController.h"

@interface saf2ViewController ()
@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation saf2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Second Controller";
        self.tabBarItem.image = [UIImage imageNamed:@"tab2.png"];
    }
    return self;
}

- (void) segmentedControlTapped:(UISegmentedControl *)paramSender
{
    switch (paramSender.selectedSegmentIndex)
    {
        case 0:{
        NSLog(@"Up");
        break;
    }
        case 1:{ NSLog(@"Down");
            break;
        }
    }
}

- (void) performAdd:(id)paramSender
{
    NSLog(@"Action method got called.");
}

- (void) switchIsChanged:(UISwitch *)paramSender
{
    if ([paramSender isOn])
    {
        NSLog(@"Switch is on.");
    }
    else
    {
        NSLog(@"Switch is off.");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad %@",self.navigationItem);
	// Do any additional setup after loading the view.
    
    //   self.title = @"SECOND CONTROLLER";
    
    /* Create an Image View to replace the Title View */
    UIImageView *imageView =
    [[UIImageView alloc]
     initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 40.0f)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    /* Load an image. Be careful, this image will be cached */
    UIImage *image = [UIImage imageNamed:@"logo"]; /* Set the image of the Image View */
    [imageView setImage:image]; /* Set the Title View */
    self.navigationItem.titleView = imageView;
    
//    self.navigationItem.rightBarButtonItem =
//    [[UIBarButtonItem alloc]
//     initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
//     action:@selector(performAdd:)];
    
    UISwitch *simpleSwitch = [[UISwitch alloc] init];
    simpleSwitch.on = YES;
    [simpleSwitch addTarget:self
                     action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithCustomView:simpleSwitch];
    
    NSArray *items = @[
                       @"Up",
                       @"Down"
                       ];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]
                                            initWithItems:items];
    segmentedControl.momentary = YES;
    [segmentedControl addTarget:self action:@selector(segmentedControlTapped:)
               forControlEvents:UIControlEventValueChanged];

    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
        
    [self.navigationItem setRightBarButtonItem:rightBarButton
                                      animated:YES];
    
    UIImage *macBookAir = [UIImage imageNamed:@"MacbookAir"];
    self.myImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.myImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.myImageView.image = macBookAir;
    self.myImageView.center = self.view.center;
    [self.view addSubview:self.myImageView];
    

    self.progressView = [[UIProgressView alloc]
                         initWithProgressViewStyle:UIProgressViewStyleBar];
    self.progressView.center = CGPointMake(self.view.center.x,450);
    self.progressView.progress = 0.5f;
    [self.view addSubview:self.progressView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) updateProg {
    NSLog(@"prog");
    self.progressView.progress += 0.1f;
}

- (void) viewDidAppear:(BOOL)paramAnimated
{
    [super viewDidAppear:paramAnimated];
    [self performSelector:@selector(goBack) withObject:nil afterDelay:5.0f];
    [self performSelector:@selector(updateProg) withObject:nil afterDelay:1.0f];
}

@end
