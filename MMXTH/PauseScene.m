//
//  PauseScene.m
//  MMXTH
//
//  Created by mac on 16/10/23.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "PauseScene.h"
#import "TestTrainScene.h"
#import "FirstScene.h"
#import "SecondScene.h"


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
    
    /*
    CCTexture *menuPic = [CCTexture textureWithFile:@"icon/menu.png"];
    CCSprite *menuground = [CCSprite spriteWithTexture:menuPic];
     */
    
    // v3.x没有CCMenu???
    
    // menu background
    menuground = [CCSprite spriteWithImageNamed:@"icon/menu.png"];
    [menuground setPosition:ccp(self.contentSize.width/2, self.contentSize.height/2)];
    [menuground setScaleX: self.contentSize.width / menuground.contentSize.width];
    [menuground setScaleY: self.contentSize.height / menuground.contentSize.height];
    [self addChild:menuground];
    
    // menu back Button
    CCButton *backBtn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"icon/menu_normal.png"]];
    [backBtn setScale:(self.contentSize.width / backBtn.contentSize.width * 0.1f)];
    [backBtn setPositionType:CCPositionTypeNormalized];
    [backBtn setTarget:self selector:@selector(onBackBtnClicked:)];
    [backBtn setPosition:ccp(0.5f, 0.5f)];
    [self addChild:backBtn];
    
    // retry Button
    CCButton *retryBtn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"icon/retry_normal.png"]];
    [retryBtn setScale:(self.contentSize.width / retryBtn.contentSize.width * 0.1f)];
    [retryBtn setPositionType:CCPositionTypeNormalized];
    [retryBtn setTarget:self selector:@selector(onRetryBtnClicked:)];
    [retryBtn setPosition:ccp(0.65f, 0.5f)];
    [self addChild:retryBtn];
    
    // return Button
    CCButton *returnBtn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"icon/return_normal.png"]];
    [returnBtn setScale:(self.contentSize.width / returnBtn.contentSize.width * 0.1f)];
    [returnBtn setPositionType:CCPositionTypeNormalized];
    [returnBtn setTarget:self selector:@selector(onReturnBtnClicked:)];
    [returnBtn setPosition:ccp(0.35f, 0.5f)];
    [self addChild:returnBtn];
}

-(void)onBackBtnClicked:(id)sender {
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[SecondScene scene] withTransition:[CCTransition transitionCrossFadeWithDuration:1.0f]];
}

-(void)onRetryBtnClicked:(id)sender {
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[TestTrainScene scene] withTransition:[CCTransition transitionCrossFadeWithDuration:1.0f]];
}

-(void)onReturnBtnClicked:(id)sender {
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] popSceneWithTransition:[CCTransition transitionCrossFadeWithDuration:1.0f]];
}

/*
-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchPoint = [touch locationInNode:self];
    
    if (CGRectContainsPoint(menuground.boundingBox, touchPoint)) {
        CCLOG(@"pause in menu!");
    }
    else {
        CCLOG(@"pause out menu!");
    }
}

-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    
}

-(void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    
}
 */
@end
