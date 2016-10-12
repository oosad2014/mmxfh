//
//  TrainGoods.m
//
//  Created by : mac
//  Project    : MMXTH
//  Date       : 16/9/16
//
//  Copyright (c) 2016年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "TrainGoods.h"

// -----------------------------------------------------------------

@implementation TrainGoods

static int count_Goods = 0;

@synthesize trainArray;
@synthesize url;

// -----------------------------------------------------------------

-(id)init {
    self = [super init];
    [self setRow:0];
    [self setColumn:0];
    
    url = @"";
    trainArray = [NSMutableArray arrayWithObjects:@"sound_mute.png", @"button.png", @"panda.png", @"pb.png", @"panda.png", @"tree_1.png", @"Icon.png", @"Icon-Small.png", @"button.png", nil];
    return self;
}

+(void)setCount:(int)count {
    count_Goods = count;
}

+(int)getCount {
    return count_Goods;
}

-(TrainGoods *)create:(float)x ySet:(float)y {
    TrainGoods *train = [TrainGoods spriteWithImageNamed:[trainArray objectAtIndex:[TrainGoods getCount]]];
    train.url = [trainArray objectAtIndex:[TrainGoods getCount]];
    [train setRow:x];
    [train setColumn:y];
    train.positionType = CCPositionTypeNormalized;
    [train setPosition:ccp([train getRow], [train getColumn])];
    return train;
}

-(id)copyWithZone:(NSZone *)zone {
    TrainGoods *copyTrain = [[[self class] allocWithZone:zone] init];
    copyTrain.url = self.url;
    copyTrain.trainArray = self.trainArray;
    return copyTrain;
}
// -----------------------------------------------------------------

@end





