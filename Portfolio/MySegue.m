#import "MySegue.h"


@implementation MySegue

- (void) perform
{
    UIViewController *source = self.sourceViewController;
    UIViewController *destination = self.destinationViewController;
    [UIView transitionFromView:source.view
                        toView:destination.view
                      duration:0.50f
                       options:UIViewAnimationOptionTransitionFlipFromTop
                    completion:^(BOOL finished)
     {
         NSLog(@"Transitioning is finished");
         
     }];
}

@end
