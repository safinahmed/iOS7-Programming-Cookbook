//
//  chapter20bViewController.m
//  Portfolio
//
//  Created by Safin Ahmed on 31/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "chapter20bViewController.h"

@interface chapter20bViewController ()

@property (nonatomic, strong) UIImageView *xcodeImageView;

@property (nonatomic, strong) UIImageView *xcodeImageView1;
@property (nonatomic, strong) UIImageView *xcodeImageView2;

@end

@implementation chapter20bViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (CGRect) bottomRightRect
{
    CGRect endRect;
    endRect.origin.x = self.view.bounds.size.width - 100;
    endRect.origin.y = self.view.bounds.size.height - 100;
    endRect.size = CGSizeMake(100.0f, 100.0f);
    return endRect;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *xcodeImage = [UIImage imageNamed:@"3.png"];
    self.xcodeImageView = [[UIImageView alloc]
                           initWithImage:xcodeImage];
    /* Just set the size to make the image smaller */
    [self.xcodeImageView setFrame:CGRectMake(0.0f,
                                             30.0f,
                                             100.0f,
                                             100.0f)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.xcodeImageView];
    
    
    self.xcodeImageView1 = [[UIImageView alloc]
                            initWithImage:xcodeImage];
    self.xcodeImageView2 = [[UIImageView alloc]
                            initWithImage:xcodeImage];
    /* Just set the size to make the images smaller */
    [self.xcodeImageView1 setFrame:CGRectMake(0.0f,
                                              0.0f,
                                              100.0f,
                                              100.0f)];
    [self.xcodeImageView2 setFrame:[self bottomRightRect]];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.xcodeImageView1];
    [self.view addSubview:self.xcodeImageView2];
    
}


- (void) viewDidAppear:(BOOL)paramAnimated
{
    [super viewDidAppear:paramAnimated];
    
    /* Capture the screenshot */
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0.0f);
    if ([self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES]) {
        NSLog(@"Successfully draw the screenshot."); }
    else {
            NSLog(@"Failed to draw the screenshot.");
        }
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    /* Save it to disk */
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *documentsFolder = [fileManager URLForDirectory:NSDocumentDirectory
                                                 inDomain:NSUserDomainMask
                                        appropriateForURL:nil
                                                   create:YES
                                                    error:nil];
    
    NSURL *screenshotUrl = [documentsFolder URLByAppendingPathComponent:@"screenshot.png"];
    NSData *screenshotData = UIImagePNGRepresentation(screenshot);
    if ([screenshotData writeToURL:screenshotUrl atomically:YES])
    {
        NSLog(@"Successfully saved screenshot to %@", screenshotUrl);
    }
    else
    {
        NSLog(@"Failed to save screenshot.");
    }
    
    
    [self startTopLeftImageViewAnimation];
    [self startBottomRightViewAnimationAfterDelay:2.0f];
    
    //SCALING
//    /* Place the image view at the center of the view of this view controller */
//    self.xcodeImageView.center = self.view.center;
//    /* Make sure no translation is applied to this image view */
//    self.xcodeImageView.transform = CGAffineTransformIdentity;
//    /* Begin the animation */
//    [UIView beginAnimations:nil
//                    context:NULL];
//    /* Make the animation 5 seconds long */
//    [UIView setAnimationDuration:5.0f];
//    
//    /* Make the image view twice as large in
//     width and height */
//    self.xcodeImageView.transform = CGAffineTransformMakeScale(2.0f,
//                                                               2.0f);
    
    //ROTATING
    self.xcodeImageView.center = self.view.center;
    /* Begin the animation */
    [UIView beginAnimations:@"clockwiseAnimation"
                    context:NULL];
    /* Make the animation 5 seconds long */
    [UIView setAnimationDuration:5.0f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector: @selector(clockwiseRotationStopped:finished:context:)];
    /* Rotate the image view 90 degrees */
    self.xcodeImageView.transform =
    CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
    /* Commit the animation */
    [UIView commitAnimations];
    

    //CHANGING POSITION
//    [UIView beginAnimations:@"xcodeImageViewAnimation" context:(__bridge void *)self.xcodeImageView];
//    /* 5 seconds animation */
//    [UIView setAnimationDuration:5.0f]; /* Receive animation delegates */
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:
//     @selector(imageViewDidStop:finished:context:)];
//    CGRect endRect;
//    endRect.origin.x = self.view.bounds.size.width - 100;
//    endRect.origin.y = self.view.bounds.size.height - 100;
//    endRect.size = CGSizeMake(100.0f, 100.0f);
//    /* End at the bottom right corner */
//    [self.xcodeImageView setFrame:endRect];
//    [UIView commitAnimations];
}

- (void)clockwiseRotationStopped:(NSString *)paramAnimationID finished:(NSNumber *)paramFinished
                         context:(void *)paramContext{
    [UIView beginAnimations:@"counterclockwiseAnimation"
context:NULL];
    /* 5 seconds long */
    [UIView setAnimationDuration:5.0f];
    /* Back to original rotation */
    self.xcodeImageView.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

- (void) startTopLeftImageViewAnimation
{
    /* Start from top left corner */
    [self.xcodeImageView1 setFrame:CGRectMake(0.0f,
                                              0.0f,
                                              100.0f,
                                              100.0f)];
    [self.xcodeImageView1 setAlpha:1.0f];
    [UIView beginAnimations:@"xcodeImageView1Animation"
                    context:(__bridge void *)self.xcodeImageView1];
    /* 3 seconds animation */
    [UIView setAnimationDuration:3.0f];
    /* Receive animation delegates */
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:
     @selector(imageViewDidStop:finished:context:)]; /* End at the bottom right corner */
    [self.xcodeImageView1 setFrame:[self bottomRightRect]];
    [self.xcodeImageView1 setAlpha:0.0f];
    [UIView commitAnimations];
}

- (void) startBottomRightViewAnimationAfterDelay:(CGFloat)paramDelay
{
    /* Start from bottom right corner */
    [self.xcodeImageView2 setFrame:[self bottomRightRect]];
    [self.xcodeImageView2 setAlpha:1.0f];
    [UIView beginAnimations:@"xcodeImageView2Animation" context:(__bridge void *)self.xcodeImageView2];
    /* 3 seconds animation */
    [UIView setAnimationDuration:3.0f];
    [UIView setAnimationDelay:paramDelay];
    /* Receive animation delegates */
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:
     @selector(imageViewDidStop:finished:context:)];
    /* End at the top left corner */
    [self.xcodeImageView2 setFrame:CGRectMake(0.0f,
                                              0.0f,
                                              100.0f,
                                              100.0f)];
    [self.xcodeImageView2 setAlpha:0.0f];
    [UIView commitAnimations];
}

- (void)imageViewDidStop:(NSString *)paramAnimationID finished:(NSNumber *)paramFinished
                 context:(void *)paramContext
{
    UIImageView *contextImageView = (__bridge UIImageView *)paramContext;
    [contextImageView removeFromSuperview];
}

//
//- (void)imageViewDidStop:(NSString *)paramAnimationID finished:(NSNumber *)paramFinished
//                 context:(void *)paramContext
//{
//    NSLog(@"Animation finished.");
//    NSLog(@"Animation ID = %@", paramAnimationID);
//    UIImageView *contextImageView = (__bridge UIImageView *)paramContext;
//    NSLog(@"Image View = %@", contextImageView);
//}

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
