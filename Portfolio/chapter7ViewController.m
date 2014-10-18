//
//  chapter7ViewController.m
//  Portfolio
//
//  Created by Safin Ahmed on 17/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "chapter7ViewController.h"
#import "CountingOperation.h"
#import "SimpleOperation.h"

@interface chapter7ViewController ()

@property (nonatomic, strong) NSInvocationOperation *simpleOperation;

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSInvocationOperation *firstOperation;
@property (nonatomic, strong) NSInvocationOperation *secondOperation;

@property (nonatomic, strong) SimpleOperation *firstSimpleOperation;
@property (nonatomic, strong) SimpleOperation *secondSimpleOperation;

@property (nonatomic, strong) NSTimer *paintingTimer;

@property (nonatomic, strong) NSThread *myThread;

@end

@implementation chapter7ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) simpleOperationEntry:(id)paramObject{
    NSLog(@"Parameter Object = %@", paramObject);
    NSLog(@"Main Thread = %@", [NSThread mainThread]);
    NSLog(@"Current Thread = %@", [NSThread currentThread]);
}

- (void) firstOperationEntry:(id)paramObject
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"Parameter Object = %@", paramObject);
    NSLog(@"Main Thread = %@", [NSThread mainThread]);
    NSLog(@"Current Thread = %@", [NSThread currentThread]);
}

- (void) secondOperationEntry:(id)paramObject
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"Parameter Object = %@", paramObject);
    NSLog(@"Main Thread = %@", [NSThread mainThread]);
    NSLog(@"Current Thread = %@", [NSThread currentThread]);
}

- (void) paint:(NSTimer *)paramTimer
{
    /* Do something here */
    NSLog(@"Painting");
}

- (void) downloadNewFile:(id)paramObject{
    @autoreleasepool {
    NSString *fileURL = (NSString *)paramObject;
    NSURL    *url = [NSURL URLWithString:fileURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = nil;
    NSError       *error = nil;
    NSData *downloadedData =
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response
                                      error:&error];
    if ([downloadedData length] > 0){ /* Fully downloaded */
    }else{
        /* Nothing was downloaded. Check the Error value */
    }
    }
}

- (void) startPainting
{
    self.paintingTimer = [NSTimer
                          scheduledTimerWithTimeInterval:1.0
                          target:self selector:@selector(paint:) userInfo:nil repeats:YES];
    
//    /* Here is the selector that we want to call */
//    SEL selectorToCall = @selector(paint:);
//    /* Here we compose a method signature out of the selector. We
//     know that the selector is in the current class so it is easy
//     to construct the method signature */
//    NSMethodSignature *methodSignature =
//    [[self class] instanceMethodSignatureForSelector:selectorToCall];
//    /* Now base our invocation on the method signature. We need this
//     invocation to schedule a timer */
//    NSInvocation *invocation =
//    [NSInvocation invocationWithMethodSignature:methodSignature];
//    [invocation setTarget:self];
//    [invocation setSelector:selectorToCall];
//    /* Start a scheduled timer now */
//    self.paintingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                                      invocation:invocation
//                                                         repeats:YES];
    
//    self.paintingTimer = [NSTimer timerWithTimeInterval:1.0
//                                                 target:self
//                                               selector:@selector(paint:) userInfo:nil
//                                                repeats:YES];
//    /* Do your processing here and whenever you are ready,
//     use the addTimer:forMode instance method of the NSRunLoop class
//     in order to schedule the timer on that run loop */
//    [[NSRunLoop currentRunLoop] addTimer:self.paintingTimer
//                                 forMode:NSDefaultRunLoopMode];
}

- (void) stopPainting
{
        if (self.paintingTimer != nil)
        {
            [self.paintingTimer invalidate];
        }
}

- (void) firstCounter{

    NSUInteger counter = 0; for (counter = 0;
                                 counter < 1000;
                                 counter++){
        NSLog(@"First Counter = %lu", (unsigned long)counter);
     } }

- (void) secondCounter
{

    NSUInteger counter = 0; for (counter = 0;
                                 counter < 1000;
                                 counter++){
        NSLog(@"Second Counter = %lu", (unsigned long)counter);
    } }

- (void) thirdCounter{

    NSUInteger counter = 0; for (counter = 0;
                                 counter < 1000;
                                 counter++){
        NSLog(@"Third Counter = %lu", (unsigned long)counter);
    }
}

- (void) autoreleaseThread:(id)paramSender{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath = [mainBundle pathForResource:@"MacbookAir"
                                              ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    /* Do something with the image */
    NSLog(@"Image = %@", image);
}

- (void) threadEntryPoint{
    @autoreleasepool {
        NSLog(@"Thread Entry Point");
        while ([[NSThread currentThread] isCancelled] == NO){
            [NSThread sleepForTimeInterval:4];
            NSLog(@"Thread Loop");
        }
        NSLog(@"Thread Finished");
    }
}

- (void) stopThread{
    NSLog(@"Cancelling the Thread");
    [self.myThread cancel];
    NSLog(@"Releasing the thread");
    self.myThread = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //EXITING THREADS
    self.myThread = [[NSThread alloc]
                     initWithTarget:self
                     selector:@selector(threadEntryPoint) object:nil];
    [self performSelector:@selector(stopThread) withObject:nil
               afterDelay:3.0f];
    [self.myThread start];
    
    
    //BACKGROUND -
//    [self performSelectorInBackground:@selector(firstCounter)
//                           withObject:nil];
//    [self performSelectorInBackground:@selector(secondCounter)
//                           withObject:nil];
//    [self performSelectorInBackground:@selector(thirdCounter)
//                           withObject:nil];
//    
    
    //THREADS HARDCORE
//    NSString *fileToDownload = @"http://www.OReilly.com";
//    
//    //SHOULD BE THROWING WARNINGS BECAUSE OF AUTO RELEASE POOL....
//    [NSThread detachNewThreadSelector:@selector(autoreleaseThread:) toTarget:self
//                           withObject:self];
//    
//    [NSThread detachNewThreadSelector:@selector(firstCounter) toTarget:self
//                           withObject:nil];
//    [NSThread detachNewThreadSelector:@selector(secondCounter) toTarget:self
//                           withObject:nil];
//    [NSThread detachNewThreadSelector:@selector(thirdCounter) toTarget:self
//                           withObject:nil];
//    
//    [NSThread detachNewThreadSelector:@selector(downloadNewFile:) toTarget:self
//                           withObject:fileToDownload];
//    
    
    //TIMERS
//    [self startPainting];
    
    
    //BLOCKS
//    NSString *result = [self convertIntToString:123
//                               usingBlockObject:intToString];
//    NSLog(@"result = %@", result);
//    
//    
//    
//    IntToStringConverter inlineConverter = ^(NSUInteger paramInteger){
//        NSString *result = [NSString stringWithFormat:@"%lu",
//                            (unsigned long)paramInteger];
//        return result;
//    };
//    
//    result = [self convertIntToString:321
//                               usingBlockObject:inlineConverter];
//    NSLog(@"result = %@", result);
//    
//    result = [self convertIntToString:333 usingBlockObject:^NSString *(NSUInteger paramInteger) {
//        NSString *result = [NSString stringWithFormat:@"%lu",
//                            (unsigned long)paramInteger];
//        return result;
//    }];
//    NSLog(@"result = %@", result);
//    
//    [self simpleMethod];
    
    //ASYNC CUSTOM OPERATIONS (NON BLOCKING)
//    NSNumber *firstNumber = @111;
//    NSNumber *secondNumber = @222;
//    self.firstSimpleOperation = [[SimpleOperation alloc]
//                           initWithObject:firstNumber];
//    self.secondSimpleOperation = [[SimpleOperation alloc]
//                            initWithObject:secondNumber];
//    self.operationQueue = [[NSOperationQueue alloc] init];
//    /* Add the operations to the queue */
//    [self.operationQueue addOperation:self.firstSimpleOperation];
//    [self.operationQueue addOperation:self.secondSimpleOperation];
//    NSLog(@"Main thread is here");
    
    
    
    //ASYNC OPERATION (OPERATION QUEUES) (NON BLOCKING)
//    NSNumber *firstNumber = @111;
//    NSNumber *secondNumber = @222;
//    self.firstOperation =[[NSInvocationOperation alloc]
//                          initWithTarget:self
//                          selector:@selector(firstOperationEntry:) object:firstNumber];
//    self.secondOperation = [[NSInvocationOperation alloc]
//                            initWithTarget:self
//                            selector:@selector(secondOperationEntry:) object:secondNumber];
//    [self.firstOperation addDependency:self.secondOperation];
//    self.operationQueue = [[NSOperationQueue alloc] init];
//    /* Add the operations to the queue */
//    [self.operationQueue addOperation:self.firstOperation];
//    [self.operationQueue addOperation:self.secondOperation];
//    NSLog(@"Main thread is here");
    
    
    
    //SIMPLE OPERATIONS (NO QUEUE IS SYNC, BLOCKING)
//    self.simpleOperation = [[CountingOperation alloc]
//                            initWithStartingCount:0
//                            endingCount:1000];
//    [self.simpleOperation start];
//    NSLog(@"Main thread is here");
//    
//
//    self.simpleOperation = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"Main Thread = %@", [NSThread mainThread]);
//        NSLog(@"Current Thread = %@", [NSThread currentThread]);
//        NSUInteger counter = 0;
//        for (counter = 0; counter < 1000;
//             counter++){
//            NSLog(@"Count = %lu", (unsigned long)counter);
//        } }];
//    /* Start the operation */
//    [self.simpleOperation start];
//
//    NSNumber *simpleObject = [NSNumber numberWithInteger:123];
//    self.simpleOperation = [[NSInvocationOperation alloc]
//                            initWithTarget:self
//                            selector:@selector(simpleOperationEntry:) object:simpleObject];
//    [self.simpleOperation start];
    
    
    
    //SERIAL QUEUES (NON BLOCKING)
//    dispatch_queue_t firstSerialQueue = dispatch_queue_create("com.pixolity.GCD.serialQueue1", 0);
//    dispatch_async(firstSerialQueue, ^{ NSUInteger counter = 0;
//        for (counter = 0;
//             counter < 5;
//             counter++){
//            NSLog(@"First iteration, counter = %lu", (unsigned long)counter);
//        }
//    });
//    
//    dispatch_async(firstSerialQueue, ^{
//        NSUInteger counter = 0;
//        for (counter = 0;
//             counter < 5;
//             counter++){
//            NSLog(@"Second iteration, counter = %lu", (unsigned long)counter);
//        }
//    });
//    
//    dispatch_async(firstSerialQueue, ^{
//        NSUInteger counter = 0;
//        for (counter = 0;
//             counter < 5;
//             counter++){
//            NSLog(@"Third iteration, counter = %lu", (unsigned long)counter);
//        }
//    });
    

    
    //GROUPS (NON BLOCKING)
//    dispatch_group_t taskGroup = dispatch_group_create();
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
//    
//    /* Reload the table view on the main queue */
//    dispatch_group_async(taskGroup, mainQueue, ^{
//        [self reloadTableView];
//    });
//    
//    /* Reload the scroll view on the main queue */
//    dispatch_group_async(taskGroup, mainQueue, ^{
//        [self reloadScrollView];
//    });
//    
//    /* Reload the image view on the main queue */
//    dispatch_group_async(taskGroup, mainQueue, ^{
//        [self reloadImageView];
//    });
//    
//    /* At the end when we are done, dispatch the following block */
//    dispatch_group_notify(taskGroup, mainQueue, ^{
//        /* Do some processing here */
//        [[[UIAlertView alloc] initWithTitle:@"Finished"
//                                    message:@"All tasks are finished"
//                                   delegate:nil
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles:nil, nil] show];
//    });
    
    //DISPATH ONCE
//    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    
//    dispatch_once(&onceToken, ^{
//        dispatch_async(concurrentQueue,
//                       executedOnlyOnce);
//    });
//    dispatch_once(&onceToken, ^{
//        dispatch_async(concurrentQueue,
//                       executedOnlyOnce);
//    });
    
    // DELAYED EXECUTION
//    double delayInSeconds = 2.0;
//    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    
//    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void)
//    {
//        /* Perform your operations here */
//        NSLog(@"DELAYED");
//    });
    
    
    //CREATE FILE WITH 10000 RANDOM NUMBER AND THEN SORTS THEM
//    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    
//    /* If we have not already saved an array of 10,000
//     random numbers to the disk before, generate these numbers now
//     and then save them to the disk in an array */
//    dispatch_async(concurrentQueue, ^{
//        NSUInteger numberOfValuesRequired = 10000;
//        if ([self hasFileAlreadyBeenCreated] == NO)
//        {
//            dispatch_sync(concurrentQueue, ^{
//            NSMutableArray *arrayOfRandomNumbers =
//            [[NSMutableArray alloc]
//             initWithCapacity:numberOfValuesRequired];
//            NSUInteger counter = 0;
//            for (counter = 0;     counter < numberOfValuesRequired;
//                 counter++)
//            {
//                unsigned int randomNumber =
//                arc4random() % ((unsigned int)RAND_MAX + 1);
//                [arrayOfRandomNumbers addObject:
//                 [NSNumber numberWithUnsignedInt:randomNumber]];
//            }
//            /* Now let's write the array to disk */
//            [arrayOfRandomNumbers writeToFile:[self fileLocation]
//                                   atomically:YES];
//            });
//        }
//        
//        __block NSMutableArray *randomNumbers = nil;
//        /* Read the numbers from disk and sort them in an
//         ascending fashion */
//        dispatch_sync(concurrentQueue, ^{
//            /* If the file has now been created, we have to read it */
//            if ([self hasFileAlreadyBeenCreated])
//            {
//                randomNumbers = [[NSMutableArray alloc] initWithContentsOfFile:[self fileLocation]];
//                /* Now sort the numbers */
//                [randomNumbers sortUsingComparator: ^NSComparisonResult(id obj1, id obj2) {
//                    NSNumber *number1 = (NSNumber *)obj1;
//                    NSNumber *number2 = (NSNumber *)obj2;
//                    return [number1 compare:number2];
//                }];
//            }
//        });
//    
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if ([randomNumbers count] > 0)
//            {
//                NSLog(@"SIm");
//            /* Refresh the UI here using the numbers in the
//             randomNumbers array */
//            }
//        });
//    });
    
    // PRINT 1000 NUMBERS SYNC - CONCURRENT QUEUE (BLOCKS MAIN THREAD)
//    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_sync(concurrentQueue, printFrom1To1000);
//    dispatch_sync(concurrentQueue, printFrom1To1000);
    
    
    // DOWNLOAD FILE ASYNC
//    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(concurrentQueue, ^{
//        __block UIImage *image = nil;
//        dispatch_sync(concurrentQueue, ^{
//            /* Download the image here */
//            /* iPad's image from Apple's website. Wrap it into two
//             lines as the URL is too long to fit into one line */
//            NSString *urlAsString =
//            @"http://photojournal.jpl.nasa.gov/jpeg/PIA17555.jpg";
//            NSURL *url = [NSURL URLWithString:urlAsString];
//            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//            NSError *downloadError = nil;
//            NSData *imageData = [NSURLConnection
//                                 sendSynchronousRequest:urlRequest
//                                 returningResponse:nil
//                                 error:&downloadError];
//            if (downloadError == nil && imageData != nil){
//                image = [UIImage imageWithData:imageData];
//                /* We have the image. We can use it now */
//            }
//            else if (downloadError != nil){
//                NSLog(@"Error happened = %@", downloadError); }
//            else{
//                    NSLog(@"No data could get downloaded from the URL.");
//                }
//        });
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            /* Show the image to the user here on the main queue */
//            if (image != nil){
//                /* Create the image view here */
//                UIImageView *imageView = [[UIImageView alloc]
//                                          initWithFrame:self.view.bounds];
//                [imageView setImage:image];
//                /* Set the image */
//                /* Make sure the image is not scaled incorrectly */
//                [imageView setContentMode:UIViewContentModeScaleAspectFit];
//                /* Add the image to this view controller's view */
//                [self.view addSubview:imageView];
//            }
//            else{
//                NSLog(@"Image isn't downloaded. Nothing to display.");
//            }
//        });
//    });
    
    
    // SHOW ALERT VIEW - MAIN THREAD - DOESN'T BLOCK MAIN THREAD
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
//    dispatch_async(mainQueue, printFrom1To1000);
//    dispatch_async(mainQueue, ^(void) {
//        [[[UIAlertView alloc] initWithTitle:@"GCD"
//                                    message:@"GCD is amazing!"
//                                   delegate:nil
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles:nil, nil] show];
//    });
    
    
    
//    AlertViewData *context = (AlertViewData *)
//    malloc(sizeof(AlertViewData));
//    if (context != NULL)
//    {
//        context->title = "GCD";
//        context->message = "GCD is amazing.";
//        context->cancelButtonTitle = "OK";
//        dispatch_async_f(mainQueue,
//                         (void *)context,
//                         displayAlertView);
//     }
}

- (void) reloadTableView{
    /* Reload the table view here */ NSLog(@"%s", __FUNCTION__);
}
- (void) reloadScrollView{
    /* Do the work here */ NSLog(@"%s", __FUNCTION__);
}
- (void) reloadImageView{
    /* Reload the image view here */ NSLog(@"%s", __FUNCTION__);
}

static dispatch_once_t onceToken;

void (^executedOnlyOnce)(void) = ^{
    static NSUInteger numberOfEntries = 0;
    numberOfEntries++;
    NSLog(@"Executed %lu time(s)", (unsigned long)numberOfEntries);
};

- (NSString *) fileLocation
{
    /* Get the document folder(s) */
    NSArray *folders =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    /* Did we find anything? */
    if ([folders count] == 0)
        return nil;
    
    /* Get the first folder */
    NSString *documentsFolder = folders[0];
    /* Append the filename to the end of the documents path */
    return [documentsFolder stringByAppendingPathComponent:@"list.txt"];
    
}

- (BOOL) hasFileAlreadyBeenCreated
{
    BOOL result = NO;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:[self fileLocation]])
    {
        result = YES;
    }
    return result;
}

void (^printFrom1To1000)(void) = ^{
    NSUInteger counter = 0;
    
    for (counter = 1;counter <= 1000;counter++)
    {
        NSLog(@"Counter = %lu - Thread = %@ %@", (unsigned long)counter, [NSThread currentThread], [NSThread mainThread]);
    }
};

void displayAlertView(void *paramContext)
{
    AlertViewData *alertData = (AlertViewData *)paramContext;
    NSString *title =
    [NSString stringWithUTF8String:alertData->title];
    NSString *message =
    [NSString stringWithUTF8String:alertData->message];
    NSString *cancelButtonTitle =
    [NSString stringWithUTF8String:alertData->cancelButtonTitle];
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:nil
                      cancelButtonTitle:cancelButtonTitle
                      otherButtonTitles:nil, nil] show];
    free(alertData);
}




- (void) simpleMethod
{
    NSUInteger outsideVariable = 10;
    NSMutableArray *array = [[NSMutableArray alloc]
                             initWithObjects:@"obj1",
                             @"obj2", nil];
    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSUInteger insideVariable = 20;
        NSLog(@"Outside variable = %lu", (unsigned long)outsideVariable);
        NSLog(@"Inside variable = %lu", (unsigned long)insideVariable);
        /* Return value for our block object */
        return NSOrderedSame; }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *) convertIntToString:(NSUInteger)paramInteger usingBlockObject:(IntToStringConverter)paramBlockObject
{
    return paramBlockObject(paramInteger);
}

NSString* (^intToString)(NSUInteger) = ^(NSUInteger paramInteger)
{
    NSString *result = [NSString stringWithFormat:@"%lu",
                        (unsigned long)paramInteger];
    
                        return result;
};

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
