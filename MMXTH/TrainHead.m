//
//  TrainHead.m
//
//  Created by : mac
//  Project    : MMXTH
//  Date       : 16/9/16
//
//  Copyright (c) 2016年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "TrainHead.h"

// -----------------------------------------------------------------

@implementation TrainHead

static int count_Head = 0;

@synthesize trainArray;
@synthesize url;

// -----------------------------------------------------------------

-(id)init {
    self = [super init];
    [self setRow:0];
    [self setColumn:0];
    
    url = @"";
    _dataManager = [DataManager sharedManager];
    trainArray = [_dataManager bundleArrayWithName:@"TrainHeadImages"];
    
    return self;
}

+(void)setCount:(int)count {
    count_Head = count;
}

+(int)getCount {
    return count_Head;
}

-(TrainHead *)create:(float)x ySet:(float)y {
    TrainHead *train = [TrainHead spriteWithImageNamed:[trainArray objectAtIndex:[TrainHead getCount]]];
    train.url = [trainArray objectAtIndex:[TrainHead getCount]];
    [train setRow:x];
    [train setColumn:y];
    train.positionType = CCPositionTypeNormalized;
    [train setPosition:ccp([train getRow], [train getColumn])];
    return train;
}

-(TrainHead *)createWithExists:(TrainHead *)head {
    TrainHead *train = [TrainHead spriteWithImageNamed:[head url]];
    train.url = [head url];
    [train setRow:[head getRow]];
    [train setColumn:[head getColumn]];
    train.positionType = head.positionType;
    [train setPosition:[head position]];
    return train;
}

-(id)copyWithZone:(NSZone *)zone {
    TrainHead *copyTrain = [[[self class] allocWithZone:zone] init];
    copyTrain.url = self.url;
    copyTrain.trainArray = self.trainArray;
    
    [copyTrain setRow:[self getRow]];
    [copyTrain setColumn:[self getColumn]];
    copyTrain.positionType = self.positionType;
    copyTrain.position = self.position;
    // copy不了父类的相关属性
    
    return copyTrain;
}

// -----------------------------------------------------------------

@end





