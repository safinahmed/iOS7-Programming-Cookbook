//
//  CountingOperation.m
//  Portfolio
//
//  Created by Safin Ahmed on 18/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "CountingOperation.h"

@interface CountingOperation ()
@property (nonatomic, unsafe_unretained) NSUInteger startingCount;
@property (nonatomic, unsafe_unretained) NSUInteger endingCount;
@property (nonatomic, unsafe_unretained, getter=isFinished) BOOL finished;
@property (nonatomic, unsafe_unretained, getter=isExecuting) BOOL executing;
@end

@implementation CountingOperation

- (instancetype) init
{
    return([self initWithStartingCount:0
                           endingCount:1000]);
}
- (instancetype) initWithStartingCount:(NSUInteger)paramStartingCount
                endingCount:(NSUInteger)paramEndingCount
{
    self = [super init];
    if (self != nil)
    {

        /* Keep these values for the main method */
        _startingCount = paramStartingCount;
        _endingCount = paramEndingCount;
    }
    return(self);
}
- (void) main
{
    @try {
        /* Here is our autorelease pool */
        @autoreleasepool
        {
            /* Keep a local variable here that must get set to YES
             whenever we are done with the task */
            BOOL taskIsFinished = NO;
            /* Create a while loop here that only exists
             if the taskIsFinished variable is set to YES or
             the operation has been cancelled */
            while (taskIsFinished == NO && [self isCancelled] == NO)
            {
                /* Perform the task here */
                NSLog(@"Main Thread = %@", [NSThread mainThread]);
                NSLog(@"Current Thread = %@", [NSThread currentThread]);
                NSUInteger counter = _startingCount;
                for (counter = _startingCount;
                     counter < _endingCount;
                     counter++){
                    NSLog(@"Count = %lu", (unsigned long)counter);
                }
                /* Very important. This way we can get out of the
                 loop and we are still complying with the cancellation
                 rules of operations */
                taskIsFinished = YES;
            }
            /* KVO compliance. Generate the
             required KVO notifications */
            [self willChangeValueForKey:@"isFinished"];
            [self willChangeValueForKey:@"isExecuting"];

            [self didChangeValueForKey:@"isFinished"];
            [self didChangeValueForKey:@"isExecuting"];
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception %@", e);
    }
}
@end