//
//  tabbedViewController.m
//  Portfolio
//
//  Created by Safin Ahmed on 12/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "tabbedViewController.h"

@interface tabbedViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *myLabel;
@property (nonatomic, strong) UITextField *myTextField;
@property (nonatomic, strong) UITextView *myTextView;
@property (nonatomic, strong) UIButton *myButton;

@property (nonatomic, strong) UILabel *label;

@end

@implementation tabbedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Tab Controller";
        self.tabBarItem.image = [UIImage imageNamed:@"logo.png"];
    }
    return self;
}

- (void) calculateAndDisplayTextFieldLengthWithText:(NSString *)paramText
{
    NSString *characterOrCharacters = @"Characters";
    if ([paramText length] == 1) {
        characterOrCharacters = @"Character";
    }
    self.myLabel.text = [NSString stringWithFormat:@"%lu %@", (unsigned long)[paramText length],
                              characterOrCharacters];
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
 replacementString:(NSString *)string
{
    if ([textField isEqual:self.myTextField])
    {
        NSString *wholeText =
        [textField.text stringByReplacingCharactersInRange:range
                                                withString:string];
        [self calculateAndDisplayTextFieldLengthWithText:wholeText];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    // LABEL
    CGRect labelFrame = CGRectMake(0.0f,
                                   0.0f,
                                   100.0f,
                                   70.0f);
    
    self.myLabel = [[UILabel alloc] initWithFrame:labelFrame];
    self.myLabel.numberOfLines = 3;
    self.myLabel.adjustsFontSizeToFitWidth = YES;
    self.myLabel.text = @"iOS 7 Programming Cookbook";
    self.myLabel.backgroundColor = [UIColor clearColor];
    self.myLabel.font = [UIFont boldSystemFontOfSize:70.0f];
    self.myLabel.textColor = [UIColor blackColor];
    self.myLabel.shadowColor = [UIColor lightGrayColor];
    self.myLabel.shadowOffset = CGSizeMake(2.0f, 2.0f);
    [self.myLabel sizeToFit];
    self.myLabel.center = CGPointMake(self.view.center.x, 120);
    
    [self.view addSubview:self.myLabel];
    
    
    //TEXT FIELD
    CGRect textFieldFrame = CGRectMake(0.0f,
                                       0.0f,
                                       200.0f,
                                       31.0f);
    self.myTextField = [[UITextField alloc]
                        initWithFrame:textFieldFrame];
    self.myTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.myTextField.delegate = self;
    self.myTextField.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    self.myTextField.textAlignment = NSTextAlignmentCenter;
    self.myTextField.text = @"Sir Richard Branson";
    self.myTextField.center = CGPointMake(self.view.center.x, 100);
    
    //Text Field Left View View
    UILabel *currencyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    currencyLabel.text = [[[NSNumberFormatter alloc] init] currencySymbol];
    currencyLabel.font = self.myTextField.font;
    [currencyLabel sizeToFit];
    self.myTextField.leftView = currencyLabel;
    self.myTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.myTextField];
    
    
    UIImage *normalImage = [UIImage imageNamed:@"buttonNormal"];
    UIImage *highlightedImage = [UIImage imageNamed:@"buttonHigh"];
    self.myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.myButton.frame = CGRectMake(50.0f,
                                     250.0f,
                                     100.0f,
                                     100.0f);
    [self.myButton setBackgroundImage:normalImage
                             forState:UIControlStateNormal];
    [self.myButton setTitle:@""
                   forState:UIControlStateNormal];
    [self.myButton setBackgroundImage:highlightedImage
                             forState:UIControlStateHighlighted];
    [self.myButton setTitle:@""
                   forState:UIControlStateHighlighted];

    [self.view addSubview:self.myButton];
    
    //Attributed Strings
    self.label = [[UILabel alloc] init];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.attributedText = [self attributedText];
    [self.label sizeToFit];
    self.label.center = CGPointMake(self.view.center.x+20.0f,350.0f);
    [self.view addSubview:self.label];
    
}

- (NSAttributedString *) attributedText
{
    NSString *string = @"iOS SDK";
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc]
                                         initWithString:string];
    
    NSDictionary *attributesForFirstWord = @{
                                             NSFontAttributeName : [UIFont boldSystemFontOfSize:60.0f],
                                             NSForegroundColorAttributeName : [UIColor redColor],
                                             NSBackgroundColorAttributeName : [UIColor blackColor]
                                             };
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor darkGrayColor];
    shadow.shadowOffset = CGSizeMake(4.0f, 4.0f);
    
    NSDictionary *attributesForSecondWord = @{
                                              NSFontAttributeName : [UIFont boldSystemFontOfSize:60.0f],
                                              NSForegroundColorAttributeName : [UIColor whiteColor],
                                              NSBackgroundColorAttributeName : [UIColor redColor],
                                              NSShadowAttributeName : shadow
                                              };
    
    /* Find the string "iOS" in the whole string and sets its attribute */
    [result setAttributes:attributesForFirstWord
                    range:[string rangeOfString:@"iOS"]];
    
    /* Do the same thing for the string "SDK" */
    [result setAttributes:attributesForSecondWord
                    range:[string rangeOfString:@"SDK"]];
    
    return [[NSAttributedString alloc] initWithAttributedString:result];

}

- (void) handleKeyboardDidShow:(NSNotification *)paramNotification{
    NSLog(@"didShowKeyb");
    /* Get the frame of the keyboard */
    NSValue *keyboardRectAsObject = [[paramNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    /* Place it in a CGRect */
    CGRect keyboardRect = CGRectZero;
    
    [keyboardRectAsObject getValue:&keyboardRect];
    
    /* Give a bottom margin to our text view that makes it
     reach to the top of the keyboard */
    self.myTextView.contentInset =
    UIEdgeInsetsMake(0.0f,
                     0.0f,
                     keyboardRect.size.height,
                     0.0f);
}
- (void) handleKeyboardWillHide:(NSNotification *)paramNotification{ /* Make the text view as big as the whole view again */
    NSLog(@"willHideKeyb");
    self.myTextView.contentInset = UIEdgeInsetsZero;
}

- (void) viewWillAppear:(BOOL)paramAnimated
{
    [super viewWillAppear:paramAnimated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //TEXT VIEW
    self.myTextView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f,
                                                                   120.0f,
                                                                   360.f,
                                                                   100.0f)];
    self.myTextView.text = @"E quando se pensava que nada podia correr pior, eis que surge a pior notícia: os Los Angeles Lakers não vão poder contar Kobe Bryant, principal “estrela” da equipa, naquela que já é considera a pior temporada de sempre da história clube da Califórnia.\nO base/extremo de 35 anos regressou no início da época após paragem prolongada devido a uma lesão no tendão de Aquiles mas voltou a lesionar-se após seis jogos, contraindo uma fratura no joelho que, inicialmente, implicava apenas uma paragem de seis semanas.\nMas a recuperação não correu como previsto e, após testes realizados esta quarta-feira, confirmou-se o pior cenário. «A lesão não sarou e, tendo em conta a recuperação e preparação necessárias, ficámos sem tempo. No entanto, vai ter toda a pré-época para se preparar e esperamos que fique a 100 por cento para a próxima época», explicou o preparador físico dos Lakers, Gary Vitti, em declarações ao site do clube.\nO influente jogador, que ajudou os Lakers a conquistarem cinco títulos entre 2000 e 2010, não escondeu o desalento: «Obviamente que esta foi uma época frustrante e dececionante. Agradeço todo o apoio que tenho vindo a receber dos adeptos e espero estar de regresso na pré-época.»\nEmpatados com os Sacramento Kings no último lugar da Conferência Oeste, com 22 vitórias e 42 derrotas, os play-offs são praticamente uma miragem para a equipa orientada por Mike D`Antoni, que também se viu privado de outros jogadores influentes como Pau Gasol e Steve Nash em grande parte dos jogos.";
    self.myTextView.contentInset = UIEdgeInsetsMake(10.0f, 0.0f, 0.0f, 0.0f);
    self.myTextView.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:self.myTextView];
}

- (void) viewWillDisappear:(BOOL)paramAnimated{
    [super viewWillDisappear:paramAnimated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
