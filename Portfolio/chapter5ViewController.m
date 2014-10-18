//
//  chapter5ViewController.m
//  Portfolio
//
//  Created by Safin Ahmed on 16/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "chapter5ViewController.h"
#import "MyCollectionViewCell.h"
#import "Header.h"
#import "Footer.h"

static NSString *kCollectionViewCellIdentifier = @"Cells";
static NSString *kCollectionViewHeaderIdentifier = @"Headers";
static NSString *kCollectionViewFooterIdentifier = @"Footers";


const NSTimeInterval kAnimationDuration = 0.30;

@interface chapter5ViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong,nonatomic) UICollectionView *collectionView;

@end

@implementation chapter5ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSArray *) allSectionColors
{
    static NSArray *allSectionColors = nil;
    if (allSectionColors == nil)
    {
        allSectionColors = @[[UIColor redColor],
                            [UIColor greenColor],
                            [UIColor blueColor],
                            ];
    }
    return allSectionColors;
}

#pragma mark -
#pragma mark Animation Selections
//- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *selectedCell =
//    [collectionView cellForItemAtIndexPath:indexPath];
//    [UIView animateWithDuration:kAnimationDuration animations:^{
//        selectedCell.alpha = 0.0f;
//    }
//        completion:^(BOOL finished) {
//        [UIView animateWithDuration:kAnimationDuration animations:^{
//            selectedCell.alpha = 1.0f;
//        }];
//    }];
//}
//
//-(void) collectionView:(UICollectionView *)collectionView
//didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *selectedCell =
//    [collectionView cellForItemAtIndexPath:indexPath];
//    [UIView animateWithDuration:kAnimationDuration animations:^{
//        selectedCell.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
//    }];
//}
//
//- (void) collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *selectedCell =
//    [collectionView cellForItemAtIndexPath:indexPath];
//    [UIView animateWithDuration:kAnimationDuration animations:^{
//        selectedCell.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
//    }];
//}

#pragma mark -
#pragma mark Datasource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell *cell =
    [collectionView
     dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier
     forIndexPath:indexPath];
    cell.imageViewBackgroundImage.image = [self randomImage];
    cell.imageViewBackgroundImage.contentMode = UIViewContentModeScaleAspectFit;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *reuseIdentifier = kCollectionViewHeaderIdentifier;
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        reuseIdentifier = kCollectionViewFooterIdentifier;
    }
    
    UICollectionReusableView *view =
    [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                       withReuseIdentifier:reuseIdentifier
                                              forIndexPath:indexPath];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        Header *header = (Header *)view;
        header.label.text = [NSString stringWithFormat:@"Section Header %lu",
                             (unsigned long)indexPath.section + 1];
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        Footer *footer = (Footer *)view;
        NSString *title = [NSString stringWithFormat:@"Section Footer %lu", (unsigned long)indexPath.section + 1];
        [footer.button setTitle:title forState:UIControlStateNormal];
    }
    return view;
}


-(void) setupColView
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 20.0f;
    flowLayout.minimumInteritemSpacing = 10.0f;
    flowLayout.itemSize = CGSizeMake(80.0f, 120.0f);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 20.0f, 10.0f, 20.0f);
    /* Set the reference size for the header and the footer views */
    flowLayout.headerReferenceSize = CGSizeMake(300.0f, 50.0f);
    flowLayout.footerReferenceSize = CGSizeMake(300.0f, 50.0f);
    
    _collectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    /* Register the nib with the collection view for easy retrieval */
    UINib *nib = [UINib nibWithNibName:
                  NSStringFromClass([MyCollectionViewCell class])
                                bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib
          forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
    /* Register the header's nib */
    UINib *headerNib = [UINib
                        nibWithNibName:NSStringFromClass([Header class])
                        bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:headerNib
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:kCollectionViewHeaderIdentifier];
    /* Register the footer's nib */
    UINib *footerNib = [UINib
                        nibWithNibName:NSStringFromClass([Footer class])
                        bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:footerNib
          forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                 withReuseIdentifier:kCollectionViewFooterIdentifier];
    
 //   [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:_collectionView];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(handlePinches:)];
    for (UIGestureRecognizer *recognizer in self.collectionView.gestureRecognizers)
    {
        if ([recognizer isKindOfClass:[pinch class]])
        {
            [recognizer requireGestureRecognizerToFail:pinch];
        }
    }
    [self.collectionView addGestureRecognizer:pinch];
}

- (BOOL) collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL) collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action
     forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:))
    {
        return YES;
    }
    return NO;
}

- (void) collectionView:(UICollectionView *)collectionView performAction:(SEL)action
     forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:))
    {
        MyCollectionViewCell *cell = (MyCollectionViewCell *)[collectionView
                                                              cellForItemAtIndexPath:indexPath];
        [[UIPasteboard generalPasteboard]
         setImage:cell.imageViewBackgroundImage.image];
    }
}

- (void) handlePinches:(UIPinchGestureRecognizer *)paramSender
{
    CGSize DefaultLayoutItemSize = CGSizeMake(80.0f, 120.0f);
    UICollectionViewFlowLayout *layout =
    (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize =
    CGSizeMake(DefaultLayoutItemSize.width * paramSender.scale,
               DefaultLayoutItemSize.height * paramSender.scale);
    [layout invalidateLayout];
}

- (NSArray *) allImages{
    static NSArray *AllSectionImages = nil;
    if (AllSectionImages == nil)
    {
        AllSectionImages = @[
                                                       [UIImage imageNamed:@"1"],
                                                       [UIImage imageNamed:@"2"],
                                                       [UIImage imageNamed:@"3"]
                                                       ];
    }
    
    return AllSectionImages;
}

- (UIImage *) randomImage{
        return [self allImages][arc4random_uniform([self allImages].count)];
}


- (NSInteger)numberOfSectionsInCollectionView :(UICollectionView *)collectionView
{
    /* Between 3 to 6 sections */
    return 3 + arc4random_uniform(4);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    /* Each section has between 10 to 15 cells */
    return 10 + arc4random_uniform(6);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupColView];
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
