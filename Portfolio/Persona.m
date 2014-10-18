//
//  Person.m
//  Portfolio
//
//  Created by Safin Ahmed on 26/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "Persona.h"

NSString *const kFirstNameKey = @"FirstNameKey";
NSString *const kLastNameKey = @"LastNameKey";

@implementation Persona

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.firstName forKey:kFirstNameKey];
    [aCoder encodeObject:self.lastName forKey:kLastNameKey];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{ self = [super init];
    if (self != nil)
    {
        _firstName = [aDecoder decodeObjectForKey:kFirstNameKey];
        _lastName = [aDecoder decodeObjectForKey:kLastNameKey];
    }
    return self; }
@end