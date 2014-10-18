//
//  scrollViewController.m
//  Portfolio
//
//  Created by Safin Ahmed on 12/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "scrollViewController.h"

@interface scrollViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, strong) UIImageView *myImageView;

@end

@implementation scrollViewController

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
    
    UIImage *iPhone = [UIImage imageNamed:@"MacbookAir"];
    UIImage *iPad = [UIImage imageNamed:@"MacbookAir"];
    UIImage *macBookAir = [UIImage imageNamed:@"MacbookAir"];
    
    CGRect scrollViewRect = self.view.bounds;
    self.myScrollView = [[UIScrollView alloc] initWithFrame:scrollViewRect];
    self.myScrollView.pagingEnabled = YES;
    self.myScrollView.contentSize = CGSizeMake(scrollViewRect.size.width * 3.0f,
                                               scrollViewRect.size.height);
    self.myScrollView.delegate = self;
    
    [self.view addSubview:self.myScrollView];
    CGRect imageViewRect = self.view.bounds;
    UIImageView *iPhoneImageView = [self newImageViewWithImage:iPhone
                                                         frame:imageViewRect];
    [self.myScrollView addSubview:iPhoneImageView];
    
    /* Go to next page by moving the x position of the next image view */
    imageViewRect.origin.x += imageViewRect.size.width;
    UIImageView *iPadImageView = [self newImageViewWithImage:iPad
                                                       frame:imageViewRect];
    [self.myScrollView addSubview:iPadImageView];
    
    /* Go to next page by moving the x position of the next image view */
    imageViewRect.origin.x += imageViewRect.size.width;
    UIImageView *macBookAirImageView =
    [self newImageViewWithImage:macBookAir
                          frame:imageViewRect];
    
    [self.myScrollView addSubview:macBookAirImageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll");
    /* Gets called when user scrolls or drags */
    self.myScrollView.alpha = 0.50f;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");
    /* Gets called only after scrolling */
    self.myScrollView.alpha = 1.0f;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollViewDidEndDragging");
    /* Make sure the alpha is reset even if the user is dragging */
    self.myScrollView.alpha = 1.0f;
}

- (UIImageView *) newImageViewWithImage:(UIImage *)paramImage frame:(CGRect)paramFrame
{
    UIImageView *result = [[UIImageView alloc] initWithFrame:paramFrame];
    result.contentMode = UIViewContentModeScaleAspectFit;
    result.image = paramImage;
    return result;
}


@end
