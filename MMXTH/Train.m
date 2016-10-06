//
//  Train.m
//
//  Created by : mac
//  Project    : MMXTH
//  Date       : 16/9/12
//
//  Copyright (c) 2016年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "Train.h"

// -----------------------------------------------------------------

static int count = 0;

@implementation Train {
    float Row;
    float Column;
}


@synthesize trainArray;
@synthesize url;

// -----------------------------------------------------------------

-(id)init {
    self = [super init];
    [self setRow:0];
    [self setColumn:0];
    
    url = @"";
    trainArray = [NSArray arrayWithObjects:@"Icon.png", @"Icon-Small.png", @"button.png", nil];
    return self;
}

-(void)setRow:(float)x {
    Row = x;
}

-(void)setColumn:(float)y {
    Column = y;
}

+(void)setCount:(int)countNew {
    count = countNew;
}

-(float)getRow {
    return Row;
}

-(float)getColumn {
    return Column;
}

+(int)getCount {
    return count;
}

// -----------------------------------------------------------------

-(Train *)create:(float)x ySet:(float)y {
    Train *train = [Train spriteWithImageNamed:[trainArray objectAtIndex:[Train getCount]]];
    train.url = [trainArray objectAtIndex:[Train getCount]];
    [train setRow:x];
    [train setColumn:y];
    train.positionType = CCPositionTypeNormalized;
    [train setPosition:ccp([train getRow], [train getColumn])];
    return train;
}

-(id)copyWithZone:(NSZone *)zone {
    Train *copyTrain = [[[self class] allocWithZone:zone] init];
    copyTrain.url = self.url;
    copyTrain.trainArray = self.trainArray;
    return copyTrain;
}

@end





