//
//  FirstScene.m
//
//  Created by : mac
//  Project    : MMXTH
//  Date       : 16/9/12
//
//  Copyright (c) 2016年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "FirstScene.h"

// -----------------------------------------------------------------

@implementation FirstScene

// -----------------------------------------------------------------

+ (FirstScene *)scene {
    return [[self alloc] init];
}

- (id)init {
    if ((self = [super init])) {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    }
    // class initalization goes here

    // Background
    CCSprite9Slice *background = [CCSprite9Slice spriteWithImageNamed:@"white_square.png"];
    background.anchorPoint = CGPointZero;
    background.contentSize = [CCDirector sharedDirector].viewSize;
    background.color = [CCColor grayColor];
    [self addChild:background];
    
    CCLabelTTF *title = [CCLabelTTF labelWithString:@"Start" fontName:@"ArialMT" fontSize:20];
    title.color = [CCColor redColor];
    title.positionType = CCPositionTypeNormalized;
    title.position = ccp(0.5f, 0.5f);
    
    CCButton *beginButton = [CCButton buttonWithTitle:@"Start" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]];
    beginButton.positionType = CCPositionTypeNormalized;
    beginButton.position = ccp(0.5f, 0.5f);
    
    [self addChild:title z:10];
    [self addChild:beginButton z:9];
    return self;
}


// -----------------------------------------------------------------

@end





