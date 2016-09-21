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
    CCSprite *BackGround = [CCSprite spriteWithImageNamed:@"timeField.png"];
    BackGround.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
    BackGround.scaleX = self.contentSize.width/BackGround.contentSize.width;
    BackGround.scaleY = self.contentSize.height/BackGround.contentSize.height;
    [self addChild:BackGround];

    
    
    CCButton *moeStagetwoButton = [CCButton buttonWithTitle:@"Moe Train Stage2" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]
                                   ];
    moeStagetwoButton.positionType = CCPositionTypeNormalized;
    moeStagetwoButton.position = ccp(0.15f, 0.85f);
    moeStagetwoButton.color=[CCColor redColor];
    [moeStagetwoButton setTarget:self selector:@selector(onbackClicked:)];
    
    CCButton *moeUpButton=[CCButton buttonWithTitle:@"next" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]];
    moeUpButton.positionType = CCPositionTypeNormalized;
    moeUpButton.position = ccp(0.25f, 0.15f);
    moeUpButton.color=[CCColor redColor];
    
    CCButton *moeDownButton=[CCButton buttonWithTitle:@"before" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]];
    moeDownButton.positionType = CCPositionTypeNormalized;
    moeDownButton.position = ccp(0.85f, 0.15f);
    moeDownButton.color=[CCColor redColor];

    
    
    [self addChild:moeStagetwoButton];
    [self addChild:moeUpButton];
    [self addChild:moeDownButton];
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





