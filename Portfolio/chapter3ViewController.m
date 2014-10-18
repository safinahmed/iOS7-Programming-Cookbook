//
//  chapter3ViewController.m
//  Portfolio
//
//  Created by Safin Ahmed on 16/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "chapter3ViewController.h"

/* Email Text Field Constraints */
NSString *const kEmailTextFieldHorizontal = @"H:|-[_textFieldEmail]-|";
NSString *const kEmailTextFieldVertical = @"V:|-[_textFieldEmail]";
/* Confirm Email Text Field Constraints */
NSString *const kConfirmEmailHorizontal = @"H:|-[_textFieldConfirmEmail]-|";
NSString *const kConfirmEmailVertical = @"V:[_textFieldEmail]-[_textFieldConfirmEmail]";
/* Register Button Constraint */
NSString *const kRegisterVertical = @"V:[_textFieldConfirmEmail]-[_registerButton]";

@interface chapter3ViewController ()

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UITextField *textFieldEmail;
@property (nonatomic, strong) UITextField *textFieldConfirmEmail;
@property (nonatomic, strong) UIButton *registerButton;


@property (nonatomic, strong) UIView *topGrayView;
@property (nonatomic, strong) UIButton *topButton;
@property (nonatomic, strong) UIView *bottomGrayView;
@property (nonatomic, strong) UIButton *bottomButton;

@end

@implementation chapter3ViewController

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
//    [self buttonConstraint];
//    [self visualFLang];
//    [self crossView];
}

-(void)crossView
{
    [self createGrayViews];
    [self createButtons];
    [self applyConstraintsToTopGrayView];
    [self applyConstraintsToButtonOnTopGrayView];
    [self applyConstraintsToBottomGrayView];
    [self applyConstraintsToButtonOnBottomGrayView];
}

- (void) applyConstraintsToButtonOnBottomGrayView{
    NSDictionary *views = NSDictionaryOfVariableBindings(_topButton,
                                                         _bottomButton);
    NSString *const kHConstraint = @"H:[_topButton][_bottomButton]";
    
    /* Horizontal constraint(s) */
    [self.bottomGrayView.superview addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:kHConstraint
                                             options:0
                                             metrics:nil
                                               views:views]
      ];
    
    /* Vertical constraint(s) */
    [self.bottomButton.superview addConstraint:
     [NSLayoutConstraint constraintWithItem:self.bottomButton
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.bottomGrayView
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0f
                                   constant:0.0f]
     ];
}

- (void) applyConstraintsToBottomGrayView{
    NSDictionary *views = NSDictionaryOfVariableBindings(_topGrayView,
                                                         _bottomGrayView);
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    NSString *const kHConstraint = @"H:|-[_bottomGrayView]-|";
    NSString *const kVConstraint = @"V:|-[_topGrayView]-[_bottomGrayView(==100)]";
    
    /* Horizontal constraint(s) */
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:kHConstraint
                                             options:0
                                             metrics:nil
                                               views:views]
      ];
    /* Vertical constraint(s) */
     [constraints addObjectsFromArray:
      [NSLayoutConstraint constraintsWithVisualFormat:kVConstraint
                                              options:0
                                              metrics:nil
                                                views:views]
      ];
      [self.bottomGrayView.superview addConstraints:constraints];
      }

- (void) applyConstraintsToButtonOnTopGrayView
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_topButton);
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    NSString *const kHConstraint = @"H:|-[_topButton]";
    
    /* Horizontal constraint(s) */
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:kHConstraint
                                             options:0
                                             metrics:nil
                                               views:views]
      ];
    
    /* Vertical constraint(s) */
     [constraints addObject:
      [NSLayoutConstraint constraintWithItem:self.topButton
                                   attribute:NSLayoutAttributeCenterY
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.topGrayView
                                   attribute:NSLayoutAttributeCenterY
                                  multiplier:1.0f
                                    constant:0.0f]
      ];
     [self.topButton.superview addConstraints:constraints];
     }

- (void) applyConstraintsToTopGrayView{
    NSDictionary *views = NSDictionaryOfVariableBindings(_topGrayView);
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    NSString *const kHConstraint = @"H:|-[_topGrayView]-|";
    NSString *const kVConstraint = @"V:|-[_topGrayView(==100)]";
    /* Horizontal constraint(s) */
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:kHConstraint
                                             options:0
                                             metrics:nil
                                               views:views]
      ];
    /* Vertical constraint(s) */
     [constraints addObjectsFromArray:
      [NSLayoutConstraint constraintsWithVisualFormat:kVConstraint
                                              options:0
                                              metrics:nil
                                                views:views]];
      [self.topGrayView.superview addConstraints:constraints];
}

- (UIButton *) newButtonPlacedOnView:(UIView *)paramView
{
    UIButton *result = [UIButton buttonWithType:UIButtonTypeSystem];
    result.translatesAutoresizingMaskIntoConstraints = NO;
    [result setTitle:@"Button" forState:UIControlStateNormal];
    [paramView addSubview:result];
    return result;
}

- (void) createButtons{
    self.topButton = [self newButtonPlacedOnView:self.topGrayView];
    self.bottomButton = [self newButtonPlacedOnView:self.bottomGrayView];
}

- (UIView *) newGrayView
{
    UIView *result = [[UIView alloc] init];
    result.backgroundColor = [UIColor lightGrayColor];
    result.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:result];
    return result;
}
- (void) createGrayViews{
    self.topGrayView = [self newGrayView];
    self.bottomGrayView = [self newGrayView];
}

- (void) visualFLang{
    [self constructUIComponents];
    [self.view addSubview:self.textFieldEmail];
    [self.view addSubview:self.textFieldConfirmEmail];
    [self.view addSubview:self.registerButton];
    [self.view addConstraints:[self constraints]];
}

- (NSArray *) emailTextFieldConstraints
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSDictionary *viewsDictionary =
    NSDictionaryOfVariableBindings(_textFieldEmail);
    [result addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:kEmailTextFieldHorizontal
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]
      ];
     [result addObjectsFromArray:
      [NSLayoutConstraint constraintsWithVisualFormat:kEmailTextFieldVertical
                                              options:0
                                              metrics:nil
                                                views:viewsDictionary]
     ];
   return [NSArray arrayWithArray:result];
}

- (NSArray *) confirmEmailTextFieldConstraints
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSDictionary *viewsDictionary =
    NSDictionaryOfVariableBindings(_textFieldConfirmEmail, _textFieldEmail);
    [result addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:kConfirmEmailHorizontal
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]
      ];
     [result addObjectsFromArray:
      [NSLayoutConstraint constraintsWithVisualFormat:kConfirmEmailVertical
                                              options:0
                                              metrics:nil
                                                views:viewsDictionary]
       ];
      return [NSArray arrayWithArray:result];
}

- (NSArray *) registerButtonConstraints{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSDictionary *viewsDictionary =
    NSDictionaryOfVariableBindings(_registerButton, _textFieldConfirmEmail);
    [result addObject:
     [NSLayoutConstraint constraintWithItem:self.registerButton
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1.0f
                                   constant:0.0f]
      ];
    [result addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:kRegisterVertical
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]
     ];
    return [NSArray arrayWithArray:result];
}


- (NSArray *)constraints{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [result addObjectsFromArray:[self emailTextFieldConstraints]];
    [result addObjectsFromArray:[self confirmEmailTextFieldConstraints]];
    [result addObjectsFromArray:[self registerButtonConstraints]];
    return [NSArray arrayWithArray:result];
}

- (UITextField *) textFieldWithPlaceholder:(NSString *)paramPlaceholder
{
    UITextField *result = [[UITextField alloc] init];
    result.translatesAutoresizingMaskIntoConstraints = NO;
    result.borderStyle = UITextBorderStyleRoundedRect;
    result.placeholder = paramPlaceholder;
    return result;
}

- (void) constructUIComponents
{
    self.textFieldEmail = [self textFieldWithPlaceholder:@"Email"];
    self.textFieldConfirmEmail = [self textFieldWithPlaceholder:@"Confirm Email"];
    self.registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.registerButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.registerButton setTitle:@"Register" forState:UIControlStateNormal];
}

-(void)buttonConstraint
{
    /* 1) Create our button */
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.button setTitle:@"Button" forState:UIControlStateNormal];
    [self.view addSubview:self.button];
    UIView *superview = self.button.superview;
    
    /* 2) Create the constraint to put the button horizontally in the center */
    NSLayoutConstraint *centerXConstraint =
    [NSLayoutConstraint constraintWithItem:self.button
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:superview
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0f
                                  constant:0.0f];
    
    /* 3) Create the constraint to put the button vertically in the center */
    NSLayoutConstraint *centerYConstraint =
    [NSLayoutConstraint constraintWithItem:self.button
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:superview
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0f
                                  constant:0.0f];
    
    /* Add the constraints to the superview of the button */
    [superview addConstraints:@[centerXConstraint, centerYConstraint]];
    
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
