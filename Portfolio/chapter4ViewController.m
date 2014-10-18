//
//  chapter4ViewController.m
//  Portfolio
//
//  Created by Safin Ahmed on 16/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "chapter4ViewController.h"

static NSString *CellIdentifier = @"MyCells";

static NSString *SectionOddNumbers = @"Odd Numbers";
static NSString *SectionEvenNumbers = @"Even Numbers";

__unused static int i = 10;

@interface chapter4ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) NSMutableArray *arrayOfSections;

@property (nonatomic, strong) UITableView *tableViewNumbers;
@property (nonatomic, strong) NSMutableDictionary *dictionaryOfNumbers;
@property (nonatomic, strong) UIBarButtonItem *barButtonAction;

@end

@implementation chapter4ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setupTable];
//    [self setupTable2];
//    [self setupTable3];
    [self setupTable4];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dictionaryOfNumbers.allKeys.count;
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section{
    NSString *sectionNameInDictionary =
    self.dictionaryOfNumbers.allKeys[section];
    NSArray *sectionArray = self.dictionaryOfNumbers[sectionNameInDictionary];
    return sectionArray.count;
}

-(void) deleteOddNumbersSection:(id)paramSender{
//    /* First remove the section from our data source */
//    NSString *key = SectionOddNumbers;
//    NSInteger indexForKey = [[self.dictionaryOfNumbers allKeys]
//                             indexOfObject:key];
//    if (indexForKey == NSNotFound){
//        NSLog(@"Could not find the section in the data source."); return;
//    }
//    [self.dictionaryOfNumbers removeObjectForKey:key];
//    /* Then delete the section from the table view */
//    NSIndexSet *sectionToDelete = [NSIndexSet indexSetWithIndex:indexForKey];
//    [self.tableViewNumbers deleteSections:sectionToDelete
//                         withRowAnimation:UITableViewRowAnimationAutomatic];
//    /* Finally, remove the button from the navigation bar
//     as it is not useful any longer */
//    [self.navigationItem setRightBarButtonItem:nil animated:YES];
    
    NSMutableArray *arrayOfIndexPathsToDelete =
    [[NSMutableArray alloc] init];
    NSMutableArray *arrayOfNumberObjectsToDelete =
    [[NSMutableArray alloc] init];
    
    /* Step 1: gather the objects we have to delete from our data source
     and their index paths */
    
    __block NSUInteger keyIndex = 0;
    
    [self.dictionaryOfNumbers enumerateKeysAndObjectsUsingBlock: ^(NSString *key, NSMutableArray *object, BOOL *stop) {
        [object enumerateObjectsUsingBlock:
         ^(NSNumber *number, NSUInteger numberIndex, BOOL *stop) {
             if ([number unsignedIntegerValue] > 2){
                 NSIndexPath *indexPath =
                 [NSIndexPath indexPathForRow:numberIndex
                                    inSection:keyIndex];
                 [arrayOfIndexPathsToDelete addObject:indexPath];
                 [arrayOfNumberObjectsToDelete addObject:number];
             }
         }];
        keyIndex++;
    }];
    
    /* Step 2: delete the objects from the data source */
    if ([arrayOfNumberObjectsToDelete count] > 0)
    {
        NSMutableArray *arrayOfOddNumbers =
        self.dictionaryOfNumbers[SectionOddNumbers];
        NSMutableArray *arrayOfEvenNumbers =
        self.dictionaryOfNumbers[SectionEvenNumbers];
        [arrayOfNumberObjectsToDelete enumerateObjectsUsingBlock: ^(NSNumber *numberToDelete, NSUInteger idx, BOOL *stop) {
            if ([arrayOfOddNumbers indexOfObject:numberToDelete] != NSNotFound){
                [arrayOfOddNumbers removeObject:numberToDelete];
            }
            if ([arrayOfEvenNumbers indexOfObject:numberToDelete] != NSNotFound){
                [arrayOfEvenNumbers removeObject:numberToDelete];
            }
        }];
    }
    
    /* Step 3: delete the cells that correspond to the objects */
    [self.tableViewNumbers
     deleteRowsAtIndexPaths:arrayOfIndexPathsToDelete
     withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.navigationItem setRightBarButtonItem:nil animated:YES];

}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                           forIndexPath:indexPath];
    NSString *sectionNameInDictionary =
    self.dictionaryOfNumbers.allKeys[indexPath.section];
    NSArray *sectionArray = self.dictionaryOfNumbers[sectionNameInDictionary];
    NSNumber *number = sectionArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%lu",
                           (unsigned long)[number unsignedIntegerValue]];
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.dictionaryOfNumbers.allKeys[section];
}

-(void) setupTable4
{
    self.barButtonAction =
    [[UIBarButtonItem alloc]
     initWithTitle:@"Delete Odd Numbers" style:UIBarButtonItemStylePlain
     target:self action:@selector(deleteOddNumbersSection:)];
    [self.navigationItem setRightBarButtonItem:self.barButtonAction
                                      animated:NO];
    self.tableViewNumbers = [[UITableView alloc]
                             initWithFrame:self.view.frame
                             style:UITableViewStyleGrouped];
    [self.tableViewNumbers registerClass:[UITableViewCell class]
                  forCellReuseIdentifier:CellIdentifier];
    self.tableViewNumbers.autoresizingMask =
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;

    self.tableViewNumbers.delegate = self;
    self.tableViewNumbers.dataSource = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableViewNumbers addSubview:refreshControl];
    
    [self.view addSubview:self.tableViewNumbers];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    /* Put a bit of delay between when the refresh control is released
     and when we actually do the refreshing to make the UI look a bit
     smoother than just doing the update without the animation */
    int64_t delayInSeconds = 1.0f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"ADICIONAR");
        [refreshControl endRefreshing];

    });
    
}

- (NSMutableDictionary *) dictionaryOfNumbers
{
    if (_dictionaryOfNumbers == nil)
    {
        NSMutableArray *arrayOfEvenNumbers = [[NSMutableArray alloc] initWithArray:@[@0,@2,@4,@6,]];
        NSMutableArray *arrayOfOddNumbers =
        [[NSMutableArray alloc] initWithArray:@[
                                                @1,
                                                @3,
                                                @5,
                                                @7,
                                                ]];
        _dictionaryOfNumbers =
        [[NSMutableDictionary alloc]
         initWithDictionary:@{
                              SectionEvenNumbers : arrayOfEvenNumbers,
                              SectionOddNumbers : arrayOfOddNumbers,
                              }];
    }
    return _dictionaryOfNumbers;
}

//TABLE WITH REORGANIZATION
//- (void) moveCell2InSection1ToCell1InSection2:(UITapGestureRecognizer *)paramTap
//{
//    NSLog(@"ESTOU");
//    NSMutableArray *section1 = self.arrayOfSections[0];
//    NSMutableArray *section2 = self.arrayOfSections[1];
//    NSString *cell2InSection1 = section1[1];
//    [section1 removeObject:cell2InSection1];
//    [section2 insertObject:cell2InSection1
//                   atIndex:0];
//    NSIndexPath *sourceIndexPath = [NSIndexPath indexPathForRow:1
//                                                      inSection:0];
//    NSIndexPath *destinationIndexPath = [NSIndexPath indexPathForRow:0
//                                                           inSection:1];
//    [self.myTableView moveRowAtIndexPath:sourceIndexPath
//                             toIndexPath:destinationIndexPath];
//}
//
//- (void) moveSection1ToSection3:(UITapGestureRecognizer *)paramTap
//{
//    NSMutableArray *section1 = self.arrayOfSections[0];
//    [self.arrayOfSections removeObject:section1];
//    [self.arrayOfSections addObject:section1];
//    [self.myTableView moveSection:0
//                        toSection:2];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = nil;
//    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
//                                           forIndexPath:indexPath];
//    NSMutableArray *sectionArray = self.arrayOfSections[indexPath.section]; cell.textLabel.text = sectionArray[indexPath.row];
//    return cell;
//}
//
//- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return self.arrayOfSections.count;
//}
//
//- (NSInteger) tableView:(UITableView *)tableView
//  numberOfRowsInSection:(NSInteger)section
//{
//    NSMutableArray *sectionArray = self.arrayOfSections[section];
//    return sectionArray.count;
//}
//
//
//- (NSMutableArray *) newSectionWithIndex:(NSUInteger)paramIndex cellCount:(NSUInteger)paramCellCount
//{
//    NSMutableArray *result = [[NSMutableArray alloc] init];
//    NSUInteger counter = 0;
//    for (counter = 0; counter < paramCellCount; counter++){
//        [result addObject:[[NSString alloc] initWithFormat:@"Section %lu Cell %lu",
//                           (unsigned long)paramIndex,(unsigned long)counter+1]];
//        }
//    return result;
//}
//
//                           
//- (NSMutableArray *) arrayOfSections{
//    
//    if (_arrayOfSections == nil)
//    {
//    
//    NSMutableArray *section1 = [self newSectionWithIndex:1
//                                                       cellCount:3];
//    NSMutableArray *section2 = [self newSectionWithIndex:2
//                                                       cellCount:3];
//    NSMutableArray *section3 = [self newSectionWithIndex:3
//                                                       cellCount:3];
//    _arrayOfSections = [[NSMutableArray alloc] initWithArray:@[section1,
//                                                               section2,
//                                                               section3 ] ];
//    }
//    return _arrayOfSections;
//}
//
//-(void)setupTable3
//{
//    self.myTableView =
//    [[UITableView alloc] initWithFrame:self.view.bounds
//                                 style:UITableViewStyleGrouped];
//    [self.myTableView registerClass:[UITableViewCell class]
//             forCellReuseIdentifier:CellIdentifier];
//    self.myTableView.autoresizingMask =
//    UIViewAutoresizingFlexibleWidth |
//    UIViewAutoresizingFlexibleHeight;
//    self.myTableView.delegate = self;
//    self.myTableView.dataSource = self;
//    [self.view addSubview:self.myTableView];
//    [self createTapGestureRecognizer];
//}
//
//- (void) createTapGestureRecognizer
//{
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//                                   initWithTarget:self
//                                   action:@selector(moveSection1ToSection3:)];
//    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moveCell2InSection1ToCell1InSection2:)];
//    
//    doubleTapRecognizer.numberOfTapsRequired = 2;
//    tap.numberOfTapsRequired = 1;
//    
//    [tap requireGestureRecognizerToFail:doubleTapRecognizer];
//    
//    [self.view addGestureRecognizer:doubleTapRecognizer];
//    [self.view addGestureRecognizer:tap];
//
//}

// TABLE WITH VIEW AS FOOTER AND HEADER, WITH COPY

//- (BOOL) tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    /* Allow the context menu to be displayed on every cell */
//    return YES;
//}
//
//- (BOOL) tableView:(UITableView *)tableView canPerformAction:(SEL)action
// forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
//{
//    if (action == @selector(copy:))
//    {
//        return YES;
//    }
//    return NO;
//}
//
//- (void) tableView:(UITableView *)tableView performAction:(SEL)action
// forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
//{
//    if (action == @selector(copy:))
//    {
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
//        [pasteBoard setString:cell.textLabel.text];
//    }
//}
//
//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0)
//    {
//        return 30.0f;
//    }
//    return 0.0f;
//}
//
//- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (section == 0)
//    {
//        return 30.0f;
//    }
//    return 0.0f;
//}
//    
//- (UILabel *) newLabelWithTitle:(NSString *)paramTitle
//{
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero]; label.text = paramTitle;
//    label.backgroundColor = [UIColor clearColor];
//    [label sizeToFit];
//    return label;
//}
//
//
//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *header = nil;
//    if (section == 0)
//    {
//        UILabel *label = [self newLabelWithTitle:@"Section 1 Header"];
//        /* Move the label 10 points to the right */
//        label.frame = CGRectMake(label.frame.origin.x + 10.0f,
//                                 5.0f, /* Go 5 points down in y axis */
//                                 label.frame.size.width,
//                                 label.frame.size.height);
//        /* Give the container view 10 points more in width than our label
//         because the label needs a 10 extra points left-margin */
//        CGRect resultFrame = CGRectMake(0.0f,
//                                        0.0f,
//                                        label.frame.size.width + 10.0f,
//                                        label.frame.size.height);
//        header = [[UIView alloc] initWithFrame:resultFrame];
//        [header addSubview:label];
//    }
//    return header;
//}
//
//- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footer = nil; if (section == 0)
//    {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
//        /* Move the label 10 points to the right */
//        label.frame = CGRectMake(label.frame.origin.x + 10.0f,
//                                 5.0f, /* Go 5 points down in y axis */
//                                 label.frame.size.width,
//                                 label.frame.size.height);
//        /* Give the container view 10 points more in width than our label
//         because the label needs a 10 extra points left-margin */
//        CGRect resultFrame = CGRectMake(0.0f,
//                                        0.0f,
//                                        label.frame.size.width + 10.0f,
//                                        label.frame.size.height);
//        footer = [[UIView alloc] initWithFrame:resultFrame];
//        [footer addSubview:label];
//    }
//    return footer;
//}
//
//
//-(void)setupTable2
//{
//    self.myTableView =
//    [[UITableView alloc] initWithFrame:self.view.bounds
//                             style:UITableViewStyleGrouped];
//    [self.myTableView registerClass:[UITableViewCell class]
//         forCellReuseIdentifier:CellIdentifier];
//    self.myTableView.dataSource = self;
//    self.myTableView.delegate = self;
//    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
//    UIViewAutoresizingFlexibleHeight;
//    [self.view addSubview:self.myTableView];
//}
//
//- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = nil;
//    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
//                                           forIndexPath:indexPath];
//    cell.textLabel.text = [[NSString alloc] initWithFormat:@"Cell %ld",
//                           (long)indexPath.row];
//    return cell;
//}
//
//- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 3;
//}


//SIMPLE LIST WITH EDITING
//
//-(void)setupTable
//{
//    self.myTableView =
//    [[UITableView alloc] initWithFrame:self.view.bounds
//                                 style:UITableViewStylePlain];
//    [self.myTableView registerClass:[UITableViewCell class]
//             forCellReuseIdentifier:CellIdentifier];
//    self.myTableView.dataSource = self;
//    
//    /* Make sure our table view resizes correctly */
//    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [self.view addSubview:self.myTableView];
//}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
//
//- (void) setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    [super setEditing:editing
//             animated:animated];
//    [self.myTableView setEditing:editing
//                        animated:animated];
//}
//
//- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
// forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete){
//        i--;
//        NSLog(@"i %d",i);
//        /* Then remove the associated cell from the Table View */
//        [tableView deleteRowsAtIndexPaths:@[indexPath]
//                         withRowAnimation:UITableViewRowAnimationLeft];
//
//    }
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    if ([tableView isEqual:self.myTableView])
//    {
//        return 3;
//    }
//    return 0;
//}
//
//- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if(section == 0)
//        return i;
//    else
//        return 10;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell* cell = nil;
//    cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier
//                                           forIndexPath:indexPath];
//    
//    cell.textLabel.text = [NSString stringWithFormat:@"Section %ld, Cell %ld", (long)indexPath.section,
//                           (long)indexPath.row];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//    button.frame = CGRectMake(0.0f, 0.0f, 150.0f, 25.0f);
//    [button setTitle:@"Expand"
//            forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(performExpand:)
//     forControlEvents:UIControlEventTouchUpInside];
//    cell.accessoryView = button;
//    return cell;
//}
//
//- (void) performExpand:(UIButton *)paramSender
//{
//    /* Handle the tap event of the button */
//    UITableViewCell *parentCell =
//    (UITableViewCell *)[self superviewOfType:[UITableViewCell class]
//                                     forView:paramSender];
//    /* Now do something with the cell if you want to */
//    NSLog(@"%@",parentCell.textLabel.text);
//    
//}
//
//- (UIView *) superviewOfType:(Class)paramSuperviewClass forView:(UIView *)paramView
//{
//    if (paramView.superview != nil)
//    {
//        if ([paramView.superview isKindOfClass:paramSuperviewClass])
//        {
//            return paramView.superview; }
//        else
//        {
//                return [self superviewOfType:paramSuperviewClass forView:paramView.superview];
//            }
//    }
//    return nil;
//}
//
//- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    /* Do something when the accessory button is tapped */
//    NSLog(@"Accessory button is tapped for cell at index path = %@", indexPath);
//    UITableViewCell *ownerCell = [tableView cellForRowAtIndexPath:indexPath];
//    NSLog(@"Cell Title = %@", ownerCell.textLabel.text);
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
