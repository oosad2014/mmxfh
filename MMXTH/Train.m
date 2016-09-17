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

@implementation Train

@synthesize trainArray;
@synthesize url;

// -----------------------------------------------------------------

-(id)init {
    self = [super init];
    Row = 0;
    Column = 0;
    url = @"";
    trainArray = [NSArray arrayWithObjects:@"Icon.png", @"Icon@2x.png", @"button.png", nil];
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

// 其实create后，train实例里的内容并没有，所以，train实例里什么都没有
-(Train *)create:(float)x ySet:(float)y {
    url = [trainArray objectAtIndex:[Train getCount]];
    Train *train = [Train spriteWithImageNamed:url];
    train.url = [trainArray objectAtIndex:[Train getCount]];
    [train setRow:x];
    [train setColumn:y];
    train.positionType = CCPositionTypeNormalized;
    [train setPosition:ccp([train getRow], [train getColumn])];
    return train;
}

@end





