//
//  SecondScene.m
//
//  Created by : mac
//  Project    : MMXTH
//  Date       : 16/9/14
//
//  Copyright (c) 2016年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "SecondScene.h"
#import "FirstScene.h"
#import "Train.h"
#import "TrainHead.h"
#import "TrainGoods.h"
#import "Track.h"

// -----------------------------------------------------------------

@implementation SecondScene

// -----------------------------------------------------------------

+ (SecondScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    if ((self = [super init])) {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    }
    // class initalization goes here
    
    // Background
    // You can change the .png files to change the background
    CCSprite9Slice *background = [CCSprite9Slice spriteWithImageNamed:@"white_square.png"];
    background.anchorPoint = CGPointZero;
    background.contentSize = [CCDirector sharedDirector].viewSize;
    background.color = [CCColor grayColor];
    [self addChild:background];
    
    CCLabelTTF *backTitle = [CCLabelTTF labelWithString:@"Back" fontName:@"ArialMT" fontSize:20];
    backTitle.color = [CCColor redColor];
    backTitle.positionType = CCPositionTypeNormalized;
    backTitle.position = ccp(0.1f, 0.9f);
    
    // BackButton
    CCButton *backButton = [CCButton buttonWithTitle:@"Back" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]];
    [backButton setTarget:self selector:@selector(onBackButtonClicked:)];
    backButton.positionType = CCPositionTypeNormalized;
    
    // CGSize screenSize = [CCDirector sharedDirector].viewSize;
    [backButton setPosition:ccp(0.1f, 0.9f)];
    
    [self addChild:backButton z:9];
    [self addChild:backTitle z:10];
    
    train = [[Train alloc] init];
    train = [train create:0.5f ySet:0.3f];
    //train.positionType = CCPositionTypeNormalized;
    //[train setPosition:ccp([train getRow], [train getColumn])];
    
    [self addChild:train z:9];
    
    [self insideScene];
    
    return self;
}

// -----------------------------------------------------------------

- (void)onBackButtonClicked:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[FirstScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
}

-(void)insideScene {
    CCButton *leftBtn = [CCButton buttonWithTitle:@"上一个" fontName:@"ArialMT" fontSize:20];
    leftBtn.positionType = CCPositionTypeNormalized;
    leftBtn.position = ccp(0.2f, 0.2f);
    [leftBtn setTarget:self selector:@selector(onLastButtonClicked:)];
    CCButton *rightBtn = [CCButton buttonWithTitle:@"下一个" fontName:@"ArialMT" fontSize:20];
    rightBtn.positionType = CCPositionTypeNormalized;
    rightBtn.position = ccp(0.8f, 0.2f);
    [rightBtn setTarget:self selector:@selector(onNextButtonClicked:)];
    
    [self addChild:leftBtn z:9];
    [self addChild:rightBtn z:9];
}

-(void)onLastButtonClicked:(id)sender {
    int temp = [Train getCount];
    temp --;
    [Train setCount:temp];
    CCLOG(@"Last Change, Count: %d", [Train getCount]);
    
    [train removeFromParent];
    train = [[Train alloc] init];
    train = [train create:0.5f ySet:0.3f];
    [self addChild:train z:9];
}

-(void)onNextButtonClicked:(id)sender {
    int temp = [Train getCount];
    temp ++;
    [Train setCount:temp];
    CCLOG(@"Next Change, Count: %d", [Train getCount]);
    
    [train removeFromParent];
    train = [[Train alloc] init];
    train = [train create:0.5f ySet:0.3f];
    [self addChild:train z:9];
}
@end




