//
//  chapter10ViewController.m
//  Portfolio
//
//  Created by Safin Ahmed on 24/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "chapter10ViewController.h"

@interface chapter10ViewController ()

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UIRotationGestureRecognizer *rotationGestureRecognizer;
@property (nonatomic, strong) UILabel *helloWorldLabel;
/* We can remove the nonatomic and the unsafe_unretained marks from this
 property declaration. On a float value, the compiler will generate both
 these for us automatically */
@property (nonatomic, unsafe_unretained) CGFloat rotationAngleInRadians;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, strong) UIButton *dummyButton;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (nonatomic, strong) UILabel *myBlackLabel;
@property (nonatomic, unsafe_unretained) CGFloat currentScale;

@end

@implementation chapter10ViewController

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
    
    /* Instantiate our object */
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(handleSwipes:)];
    /* Swipes that are performed from right to
     left are to be detected */
    self.swipeGestureRecognizer.direction =
    UISwipeGestureRecognizerDirectionLeft;
    /* Just one finger needed */
    self.swipeGestureRecognizer.numberOfTouchesRequired = 1; /* Add it to the view */
    [self.view addGestureRecognizer:self.swipeGestureRecognizer];
    
    self.helloWorldLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.helloWorldLabel.text = @"Hello, World!";
    self.helloWorldLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.helloWorldLabel sizeToFit];
    self.helloWorldLabel.center = self.view.center;
    
    
    [self.view addSubview:self.helloWorldLabel];
    self.rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc]
                                      initWithTarget:self
                                      action:@selector(handleRotations:)]; [self.view addGestureRecognizer:self.rotationGestureRecognizer];
    
    /* Make sure to enable user interaction; otherwise, tap events
     won't be caught on this label */
    self.helloWorldLabel.userInteractionEnabled = YES;
    
    /* Create the Pan Gesture Recognizer */
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(handlePanGestures:)];
    /* At least and at most we need only one finger to activate
     the pan gesture recognizer */
    self.panGestureRecognizer.minimumNumberOfTouches = 1;
    self.panGestureRecognizer.maximumNumberOfTouches = 1;
    /* Add it to our view */
    [self.helloWorldLabel addGestureRecognizer:self.panGestureRecognizer];
    
    self.dummyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.dummyButton.frame = CGRectMake(0.0f,
                                        0.0f,
                                        72.0f,
                                        37.0f);
    [self.dummyButton setTitle:@"My button" forState:UIControlStateNormal];
    self.dummyButton.center = CGPointMake(self.view.bounds.size.width/2, 150.0f);
    [self.view addSubview:self.dummyButton];
    /* First create the gesture recognizer */
    self.longPressGestureRecognizer =
    [[UILongPressGestureRecognizer alloc]
     initWithTarget:self action:@selector(handleLongPressGestures:)];
    //self.longPressGestureRecognizer.numberOfTapsRequired = 2;
    /* The number of fingers that must be present on the screen */
    self.longPressGestureRecognizer.numberOfTouchesRequired = 2;
    /* Maximum 100 points of movement allowed before the gesture
     is recognized */
    self.longPressGestureRecognizer.allowableMovement = 100.0f;
    /* The user must press 2 fingers (numberOfTouchesRequired) for
     at least 1 second for the gesture to be recognized */
    self.longPressGestureRecognizer.minimumPressDuration = 1.0; /* Add this gesture recognizer to our view */
    [self.view addGestureRecognizer:self.longPressGestureRecognizer];
    
    /* Create the Tap Gesture Recognizer */
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(handleTaps:)]; /* The number of fingers that must be on the screen */
    self.tapGestureRecognizer.numberOfTouchesRequired = 2;
    /* The total number of taps to be performed before the
     gesture is recognized */
    self.tapGestureRecognizer.numberOfTapsRequired = 3;
    /* Add this gesture recognizer to our view */
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
    CGRect labelRect = CGRectMake(0.0f,
                                  0.0f,
                                  200.0f,
                                  200.0f); /* Height */
    
                                  self.myBlackLabel = [[UILabel alloc] initWithFrame:labelRect];
                                  self.myBlackLabel.center = CGPointMake(self.view.bounds.size.width/2, 400.0f);
                                  self.myBlackLabel.backgroundColor = [UIColor blackColor];
                                  /* Without this line, our pinch gesture recognizer
                                   will not work */
                                  self.myBlackLabel.userInteractionEnabled = YES;
                                  [self.view addSubview:self.myBlackLabel];
                                  /* Create the Pinch Gesture Recognizer */
                                  self.pinchGestureRecognizer =  [[UIPinchGestureRecognizer alloc]
                                                                  initWithTarget:self
                                                                  action:@selector(handlePinches:)];
                                  /* Add this gesture recognizer to our view */
                                  [self.myBlackLabel
                                   addGestureRecognizer:self.pinchGestureRecognizer];
}


- (void) handlePinches:(UIPinchGestureRecognizer*)paramSender
{
    NSLog(@"%fu",paramSender.velocity);
    if (paramSender.state == UIGestureRecognizerStateEnded)
    {
        self.currentScale = paramSender.scale;
    }
    else if (paramSender.state == UIGestureRecognizerStateBegan && self.currentScale != 0.0f)
    {
        paramSender.scale = self.currentScale;
    }
    if (paramSender.scale != NAN && paramSender.scale != 0.0)
    {
        paramSender.view.transform = CGAffineTransformMakeScale(paramSender.scale,paramSender.scale);
    }
}

- (void) handleTaps:(UITapGestureRecognizer*)paramSender
{
    NSUInteger touchCounter = 0;
    for (touchCounter = 0;touchCounter < paramSender.numberOfTouchesRequired;touchCounter++)
    {
        CGPoint touchPoint =
        [paramSender locationOfTouch:touchCounter
                              inView:paramSender.view];
        NSLog(@"Touch #%lu: %@",
              (unsigned long)touchCounter+1, NSStringFromCGPoint(touchPoint));
    }
}

- (void) handleLongPressGestures:(UILongPressGestureRecognizer *)paramSender
{
    /* Here we want to find the mid point of the two fingers
     that caused the long press gesture to be recognized. We configured
     this number using the numberOfTouchesRequired property of the
     UILongPressGestureRecognizer that we instantiated in the
     viewDidLoad instance method of this View Controller. If we
     find that another long press gesture recognizer is using this
     method as its target, we will ignore it */
    if ([paramSender isEqual:self.longPressGestureRecognizer])
    {
        if (paramSender.numberOfTouchesRequired == 2)
        {
        CGPoint touchPoint1 = [paramSender locationOfTouch:0
                              inView:paramSender.view];
        CGPoint touchPoint2 = [paramSender locationOfTouch:1
                              inView:paramSender.view];
        CGFloat midPointX = (touchPoint1.x + touchPoint2.x) / 2.0f;
        CGFloat midPointY = (touchPoint1.y + touchPoint2.y) / 2.0f;
        CGPoint midPoint = CGPointMake(midPointX, midPointY);
        self.dummyButton.center = midPoint;
        }
        else
        {
        /* This is a long press gesture recognizer with more
         CGPoint touchPoint2 =
         or less than 2 fingers */
            NSLog(@"OTHER LONG PRESS");
         }
    }
}

- (void) handleRotations:(UIRotationGestureRecognizer *)paramSender{
    if (self.helloWorldLabel == nil)
    {
        return;
    }
    /* Take the previous rotation and add the current rotation to it */
    self.helloWorldLabel.transform =
    CGAffineTransformMakeRotation(self.rotationAngleInRadians +
                                  paramSender.rotation);
    /* At the end of the rotation, keep the angle for later use */
    if (paramSender.state == UIGestureRecognizerStateEnded)
    {
        self.rotationAngleInRadians += paramSender.rotation;
    }
}

- (void) handlePanGestures:(UIPanGestureRecognizer*)paramSender
{
    if (paramSender.state != UIGestureRecognizerStateEnded && paramSender.state != UIGestureRecognizerStateFailed)
    {
        CGPoint location = [paramSender
                        locationInView:paramSender.view.superview];
        paramSender.view.center = location;
    }
}

- (void) handleSwipes:(UISwipeGestureRecognizer *)paramSender
{
    NSLog(@"%d",paramSender.direction);
    if (paramSender.direction & UISwipeGestureRecognizerDirectionDown)
    
    {
        NSLog(@"Swiped Down.");
    }
    if (paramSender.direction & UISwipeGestureRecognizerDirectionLeft)
    {
        NSLog(@"Swiped Left.");
    }
    if (paramSender.direction & UISwipeGestureRecognizerDirectionRight)
    {
        NSLog(@"Swiped Right.");
    }
    if (paramSender.direction & UISwipeGestureRecognizerDirectionUp)
    {
        NSLog(@"Swiped Up.");
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
