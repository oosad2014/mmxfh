//
//  SecondScene.m
//
//  Created by : Mac
//  Project    : MMXTH
//  Date       : 16/9/17
//
//  Copyright (c) 2016年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "SecondScene.h"
#import "FirstScene.h"
// -----------------------------------------------------------------

@implementation SecondScene

// -----------------------------------------------------------------

+ (SecondScene *)scene
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (!self) return(nil);
    
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    
    CCButton *moeStagetwoButton = [CCButton buttonWithTitle:@"Moe Train Stage1" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]
                                   ];
    moeStagetwoButton.positionType = CCPositionTypeNormalized;
    moeStagetwoButton.position = ccp(0.20f, 0.45f);
    [moeStagetwoButton setTarget:self selector:@selector(onbackClicked:)];
    
    [self addChild:moeStagetwoButton];
    return self;
}
- (void)onbackClicked:(id)sender
{
    // start scene with transition
    [[CCDirector sharedDirector] replaceScene:[FirstScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
}

// -----------------------------------------------------------------

@end





