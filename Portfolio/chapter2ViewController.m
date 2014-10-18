//
//  chapter2ViewController.m
//  Portfolio
//
//  Created by Safin Ahmed on 13/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "chapter2ViewController.h"

NSString *const kBottomBoundary = @"bottomBoundary";

@interface chapter2ViewController () <UICollisionBehaviorDelegate>

@property (nonatomic, strong) UIView *squareView;
@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic, strong) NSMutableArray *squareViews;


@property (nonatomic, strong) UIPushBehavior *pushBehavior;
@property (nonatomic, strong) UIView *squareViewAnchorView;
@property (nonatomic, strong) UIView *anchorView;
@property (nonatomic, strong) UIAttachmentBehavior *attachmentBehavior;

@property (nonatomic, strong) UISnapBehavior *snapBehavior;

@end

@implementation chapter2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)collisionBehavior:(UICollisionBehavior*)paramBehavior beganContactForItem:(id <UIDynamicItem>)paramItem
   withBoundaryIdentifier:(id <NSCopying>)paramIdentifier atPoint:(CGPoint)paramPoint{
    NSString *identifier = (NSString *)paramIdentifier;
    if ([identifier isEqualToString:kBottomBoundary]){
        [UIView animateWithDuration:2.0f animations:^{
            UIView *view = (UIView *)paramItem;
            view.backgroundColor = [UIColor redColor];
            view.alpha = 0.0f;
            view.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
        } completion:^(BOOL finished) {
            UIView *view = (UIView *)paramItem; [paramBehavior removeItem:paramItem];
            [view removeFromSuperview];
        }];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    [self collisonTest];
//    [self pushTest];
//    [self attachTest];
    [self snapTest];

}

-(void)snapTest
{
    [self createTapGestureRecognizer];
    [self createSmallSnapSquareView];
    [self createSnapAnimatorAndBehaviors];
}


- (void) createSnapAnimatorAndBehaviors
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    /* Create collision detection */
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]
                                      initWithItems:@[self.squareView]];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collision];
    /* For now, snap the square view to its current center */
    self.snapBehavior = [[UISnapBehavior alloc]
                         initWithItem:self.squareView
                         snapToPoint:self.squareView.center];
    self.snapBehavior.damping = 0.5f; /* Medium oscillation */
    [self.animator addBehavior:self.snapBehavior];
}

- (void) createSmallSnapSquareView
{
    self.squareView =
    [[UIView alloc] initWithFrame:
     CGRectMake(0.0f, 0.0f, 80.0f, 80.0f)];
    self.squareView.backgroundColor = [UIColor greenColor];
    self.squareView.center = self.view.center;
    [self.view addSubview:self.squareView];
}


- (void) createTapGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(handleSnapTap:)];
    [self.view addGestureRecognizer:tap];
}

- (void) handleSnapTap:(UITapGestureRecognizer *)paramTap{
    /* Get the angle between the center of the square view
     and the tap point */
    CGPoint tapPoint = [paramTap locationInView:self.view];
    if (self.snapBehavior != nil){
        [self.animator removeBehavior:self.snapBehavior];
    }
    self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self.squareView
                                                 snapToPoint:tapPoint];
    self.snapBehavior.damping = 0.5f; /* Medium oscillation */
    [self.animator addBehavior:self.snapBehavior];
}

-(void)attachTest
{
    [self createPanGestureRecognizer];
    [self createSmallSquareView1];
    [self createAnchorView];
    [self createAnimatorAndBehaviors1];
}

- (void) createSmallSquareView1
{
    self.squareView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 80.0f, 80.0f)];
    self.squareView.backgroundColor = [UIColor greenColor];
    self.squareView.center = self.view.center;
    
    self.squareViewAnchorView = [[UIView alloc] initWithFrame:
                                 CGRectMake(60.0f, 0.0f, 20.0f, 20.0f)];
    self.squareViewAnchorView.backgroundColor = [UIColor brownColor];
    [self.squareView addSubview:self.squareViewAnchorView];
    [self.view addSubview:self.squareView];
}

- (void) createAnchorView{
    self.anchorView = [[UIView alloc] initWithFrame:
                       CGRectMake(120.0f, 120.0f, 20.0f, 20.0f)];
    self.anchorView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.anchorView];
}

- (void) createPanGestureRecognizer
{
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handlePan:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (void) handlePan:(UIPanGestureRecognizer *)paramPan{
    CGPoint tapPoint = [paramPan locationInView:self.view];
    [self.attachmentBehavior setAnchorPoint:tapPoint];
    self.anchorView.center = tapPoint;
}

- (void) createAnimatorAndBehaviors1
{
    self.animator = [[UIDynamicAnimator alloc]
                     initWithReferenceView:self.view];
    
    /* Create collision detection */
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]
                                      initWithItems:@[self.squareView]];

    collision.translatesReferenceBoundsIntoBoundary = YES;
    self.attachmentBehavior = [[UIAttachmentBehavior alloc]
                               initWithItem:self.squareView
                               offsetFromCenter: UIOffsetMake(10.0f, 10.0f)
                               attachedToAnchor:self.anchorView.center];
    [self.animator addBehavior:collision];
    [self.animator addBehavior:self.attachmentBehavior];
}

-(void)pushTest
{
    [self createGestureRecognizer];
    [self createSmallSquareView];
    [self createAnimatorAndBehaviors];
}

- (void) createSmallSquareView{ self.squareView =
    [[UIView alloc] initWithFrame:
     CGRectMake(0.0f, 0.0f, 80.0f, 80.0f)];
    self.squareView.backgroundColor = [UIColor greenColor];
    self.squareView.center = self.view.center;
    [self.view addSubview:self.squareView];
}

- (void) createGestureRecognizer
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void) createAnimatorAndBehaviors
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    /* Create collision detection */
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]
                                      initWithItems:@[self.squareView]];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    self.pushBehavior = [[UIPushBehavior alloc]
                         initWithItems:@[self.squareView]
                         mode:UIPushBehaviorModeContinuous];
    [self.animator addBehavior:collision];
    [self.animator addBehavior:self.pushBehavior];
}

- (void) handleTap:(UITapGestureRecognizer *)paramTap
{
    /* Get the angle between the center of the square view
     and the tap point */
    CGPoint tapPoint = [paramTap locationInView:self.view];
    CGPoint squareViewCenterPoint = self.squareView.center;
    /* Calculate the angle between the center point of the square view and
     the tap point to find out the angle of the push
     Formula for detecting the angle between two points is:
     arc tangent 2((p1.x - p2.x), (p1.y - p2.y)) */
    CGFloat deltaX = tapPoint.x - squareViewCenterPoint.x;
    CGFloat deltaY = tapPoint.y - squareViewCenterPoint.y;
    CGFloat angle = atan2(deltaY, deltaX);

    [self.pushBehavior setAngle:angle];
    /* Use the distance between the tap point and the center of our square
     view to calculate the magnitude of the push
     Distance formula is:
     square root of ((p1.x - p2.x)^2 + (p1.y - p2.y)^2) */
    CGFloat distanceBetweenPoints =
        sqrt(pow(tapPoint.x - squareViewCenterPoint.x, 2.0) +
             pow(tapPoint.y - squareViewCenterPoint.y, 2.0));
    [self.pushBehavior setMagnitude:distanceBetweenPoints / 200.0f];
}

-(void)collisonTest
{
    /* Create the views */
    NSUInteger const NumberOfViews = 2;
    self.squareViews = [[NSMutableArray alloc] initWithCapacity:NumberOfViews];
    NSArray *colors = @[[UIColor redColor], [UIColor greenColor]];
    CGPoint currentCenterPoint = self.view.center;
    CGSize eachViewSize = CGSizeMake(50.0f, 50.0f);
    for (NSUInteger counter = 0; counter < NumberOfViews; counter++){
        UIView *newView =
        [[UIView alloc] initWithFrame:
            CGRectMake(0.0f, 0.0f, eachViewSize.width, eachViewSize.height)];
        newView.backgroundColor = colors[counter];
        newView.center = currentCenterPoint;
        currentCenterPoint.y += eachViewSize.height + 10.0f;
        [self.view addSubview:newView];
        [self.squareViews addObject:newView];
    }
    self.animator = [[UIDynamicAnimator alloc]
                     initWithReferenceView:self.view];

    /* Create gravity */
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]
                                  initWithItems:self.squareViews];
    [self.animator addBehavior:gravity];

    //    /* Create collision detection */
    //    UICollisionBehavior *collision = [[UICollisionBehavior alloc]
    //                                      initWithItems:self.squareViews];
    //    collision.translatesReferenceBoundsIntoBoundary = YES;
    //    [self.animator addBehavior:collision];

    /* Create collision detection */
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]
                                      initWithItems:self.squareViews];

    [collision
        addBoundaryWithIdentifier:kBottomBoundary
        fromPoint:CGPointMake(0.0f, self.view.bounds.size.height - 100.0f)
        toPoint:CGPointMake(self.view.bounds.size.width,self.view.bounds.size.height - 100.0f)];
    collision.collisionDelegate = self;
    
    [self.animator addBehavior:collision];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
