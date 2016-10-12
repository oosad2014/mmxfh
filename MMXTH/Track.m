//
//  Track.m
//
//  Created by : mac
//  Project    : MMXTH
//  Date       : 16/9/16
//
//  Copyright (c) 2016年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "Track.h"

// -----------------------------------------------------------------

@implementation Track

static int count_Track = 0;

@synthesize trainArray;
@synthesize url;

// -----------------------------------------------------------------

-(id)init {
    self = [super init];
    [self setRow:0];
    [self setColumn:0];
    
    url = @"";
    trainArray = [NSMutableArray arrayWithObjects:@"Icon.png", @"Icon-Small.png", @"button.png", @"pb.png", @"panda.png", @"tree_1.png", @"sound_mute.png", @"button.png", @"panda.png", nil];
    return self;
}

+(void)setCount:(int)count {
    count_Track = count;
}

+(int)getCount {
    return count_Track;
}

-(Track *)create:(float)x ySet:(float)y {
    Track *train = [Track spriteWithImageNamed:[trainArray objectAtIndex:[Track getCount]]];
    train.url = [trainArray objectAtIndex:[Track getCount]];
    [train setRow:x];
    [train setColumn:y];
    train.positionType = CCPositionTypeNormalized;
    [train setPosition:ccp([train getRow], [train getColumn])];
    return train;
}

-(id)copyWithZone:(NSZone *)zone {
    Track *copyTrain = [[[self class] allocWithZone:zone] init];
    copyTrain.url = self.url;
    copyTrain.trainArray = self.trainArray;
    return copyTrain;
}
// -----------------------------------------------------------------

@end





