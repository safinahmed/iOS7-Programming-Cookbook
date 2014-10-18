//
//  Person.h
//  Portfolio
//
//  Created by Safin Ahmed on 29/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * age;

@end
