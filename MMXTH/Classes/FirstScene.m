//
//  HelloWorldScene.m
//
//  Created by : xc
//  Project    : MMXTH
//  Date       : 16/9/9
//
//  Copyright (c) 2016年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "FirstScene.h"
#import"SecondScene.h"
// -----------------------------------------------------------------------

@implementation FirstScene

// -----------------------------------------------------------------------
+ (FirstScene *)scene
{
    return [[self alloc] init];
}
- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    
    // The thing is, that if this fails, your app will 99.99% crash anyways, so why bother
    // Just make an assert, so that you can catch it in debug
    NSAssert(self, @"Whoops");
    CCButton *moeStageOneButton = [CCButton buttonWithTitle:@"Moe Train Stage1" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]
                                   ];
    moeStageOneButton.positionType = CCPositionTypeNormalized;
    moeStageOneButton.position = ccp(0.15f, 0.85f);
    [moeStageOneButton setTarget:self selector:@selector(onMoeTrainStageOneClicked:)];
    [self addChild:moeStageOneButton];


    
    
    // done
    return self;
}

// -----------------------------------------------------------------------
- (void)onMoeTrainStageOneClicked:(id)sender
{
    // start scene with transition
    [[CCDirector sharedDirector] replaceScene:[SecondScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
}


@end























// why not add a few extra lines, so we dont have to sit and edit at the bottom of the screen ...
