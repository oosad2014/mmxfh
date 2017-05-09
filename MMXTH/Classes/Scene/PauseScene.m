//
//  PauseScene.m
//  MMXTH
//
//  Created by mac on 16/10/23.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "PauseScene.h"

@implementation PauseScene

@synthesize menuground;

+(PauseScene *)scene {
    return [[self alloc] init];
}

-(id)initWithParameter:(CCRenderTexture *)pauseTexture {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    self.userInteractionEnabled = YES; // 开启触屏
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:27.0f/255.0f green:185.0f/255.0f blue:239.0f/255.0f alpha:1.0f]];
    [self addChild:background];
    
    [self initScene:pauseTexture];
    return self;
}

-(void)initScene:(CCRenderTexture *)pauseTexture {
    // pause background
    CCSprite *pauseBlock = [CCSprite spriteWithTexture:pauseTexture.texture];
    [pauseBlock setPosition:ccp(self.contentSize.width/2, self.contentSize.height/2)];
    [pauseBlock setScaleX: self.contentSize.width / pauseBlock.contentSize.width];
    [pauseBlock setScaleY: self.contentSize.height / pauseBlock.contentSize.height];
    [self addChild:pauseBlock];
    
    // v3.x没有CCMenu???
    
    // menu background
    menuground = [CCSprite spriteWithImageNamed:@"暂停背景.png"];
    [menuground setPositionType:CCPositionTypeNormalized];
    [menuground setPosition:ccp(0.5f, 0.42f)];
    [menuground setScaleX: self.contentSize.width * 0.6 / menuground.contentSize.width];
    [menuground setScaleY: self.contentSize.height / menuground.contentSize.height];
    [self addChild:menuground];
    
    // menu back Button
    CCButton *backBtn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"主页.png"]];
    [backBtn setScale:(self.contentSize.width / backBtn.contentSize.width * 0.1f)];
    [backBtn setPositionType:CCPositionTypeNormalized];
    [backBtn setTarget:self selector:@selector(onBackBtnClicked:)];
    [backBtn setPosition:ccp(0.65f, 0.5f)];
    [self addChild:backBtn];
    CCButton *resumeButton = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"上一页.png"]];
    resumeButton.scale = (self.contentSize.width/resumeButton.contentSize.width)*0.1f;
    resumeButton.positionType = CCPositionTypeNormalized;
    resumeButton.position = ccp(0.50f, 0.5f);
    [resumeButton setTarget:self selector:@selector(onResumeClicked:)];
    [self addChild:resumeButton];
    // retry Button
    CCButton *retryBtn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"重新游戏.png"]];
    [retryBtn setScale:(self.contentSize.width / retryBtn.contentSize.width * 0.1f)];
    [retryBtn setPositionType:CCPositionTypeNormalized];
    [retryBtn setTarget:self selector:@selector(onRetryBtnClicked:)];
    [retryBtn setPosition:ccp(0.35f, 0.5f)];
    [self addChild:retryBtn];
    
    
}

// Back按钮点击事件
-(void)onBackBtnClicked:(id)sender {
    [[OALSimpleAudio sharedInstance] stopEverything];
    [[CCDirector sharedDirector] resume]; // 暂停游戏，保存当前状态
    [[CCDirector sharedDirector] replaceScene:[EnterLittleMap scene] withTransition:[CCTransition transitionCrossFadeWithDuration:1.0f]];
}

-(void)onResumeClicked:(id)sender{

    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] popSceneWithTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionInvalid duration:1.0f]];
    
    
}

// Retry按钮点击事件
-(void)onRetryBtnClicked:(id)sender {
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[Newtest scene] withTransition:[CCTransition transitionCrossFadeWithDuration:1.0f]];
}
@end
