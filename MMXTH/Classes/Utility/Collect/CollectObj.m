//
//  CollectObj.m
//
//  Created by : dpc
//  Project    : MMXTH
//  Date       : 17/5/1
//
//  Copyright (c) 2017年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "CollectObj.h"

// -----------------------------------------------------------------

@implementation CollectObj
{
    int collectnum;
}

// -----------------------------------------------------------------

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    [self setCount:0];
    
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    
    
    
    return self;
}

-(void)setCount:(int)count
{
    collectnum=count;
}
-(int)getCount
{
    return collectnum;
}

// -----------------------------------------------------------------

@end





