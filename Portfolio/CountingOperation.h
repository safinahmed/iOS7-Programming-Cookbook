//
//  CountingOperation.h
//  Portfolio
//
//  Created by Safin Ahmed on 18/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountingOperation : NSOperation
/* Designated Initializer */
- (instancetype) initWithStartingCount:(NSUInteger)paramStartingCount endingCount:(NSUInteger)paramEndingCount;
@end
