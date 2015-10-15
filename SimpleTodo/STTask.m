//
//  STTask.m
//  SimpleTodo
//
//  Created by Kent on 10/15/15.
//  Copyright © 2015 Kent. All rights reserved.
//

#import "STTask.h"

@implementation STTask

//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.detail forKey:@"detail"];
    [encoder encodeObject:self.updateDate forKey:@"updateDate"];
    [encoder encodeBool:self.done forKey:@"done"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.title = [decoder decodeObjectForKey:@"title"];
        self.detail = [decoder decodeObjectForKey:@"detail"];
        self.updateDate = [decoder decodeObjectForKey:@"updateDate"];
        self.done = [decoder decodeBoolForKey:@"done"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
    
    [theCopy setTitle:[self.title copy]];
    [theCopy setDetail:[self.detail copy]];
    [theCopy setUpdateDate:[self.updateDate copy]];
    [theCopy setDone:self.done];
    
    return theCopy;
}

@end
