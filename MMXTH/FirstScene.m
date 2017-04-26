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
#import "processBar.h"
#import "CollectionScene.h"
#import "SettingScene.h"
#import "AudioPlayer.h"

// -----------------------------------------------------------------

@implementation FirstScene
// -----------------------------------------------------------------
int isFirstRun;
// 类方法，产生界面
+ (FirstScene *)scene {
    return [[self alloc] init];
}

// 初始化
- (id)init {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    // class initalization goes here

    // 建立一个色层节点，用于存放scene界面
//    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:27.0f/255.0f green:185.0f/255.0f blue:239.0f/255.0f alpha:1.0f]];
//    [self addChild:background];
    
    [self initScene];

    return self;
}

// 界面额外的初始化
-(void)initScene {
    // Background
    // You can change the .png files to change the background
    // 背景图
    CCSprite *background = [CCSprite spriteWithImageNamed:@"背景.png"];
    [background setPositionType:CCPositionTypeNormalized];
    [background setPosition:CGPointMake(0.5f, 0.5f)];
    [background setScale:self.contentSize.width/background.contentSize.width];
    [self addChild:background z: 1];
    
    // As a reason of I couldn't change the color of the words of the button
    // 开始按钮上文字
    CCLabelTTF *title = [CCLabelTTF labelWithString:@"Start" fontName:@"ArialMT" fontSize:20];
    title.color = [CCColor redColor];
    title.positionType = CCPositionTypeNormalized;
    title.position = ccp(0.5f, 0.5f);
    
    // 开始按钮
    CCButton *beginButton = [CCButton buttonWithTitle:@"Start" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]];
    [beginButton setTarget:self selector:@selector(onBeginButtonClicked:)];
    beginButton.positionType = CCPositionTypeNormalized;
    beginButton.position = ccp(0.5f, 0.5f);
    
    // 组装按钮
    CCButton *assembleBtn = [CCButton buttonWithTitle:@"Assemble" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]];
    [assembleBtn setTarget:self selector:@selector(onAssembleButtonClicked:)];
    assembleBtn.positionType = CCPositionTypeNormalized;
    assembleBtn.position = ccp(0.5f, 0.4f);
    
    // 收藏按钮
    CCButton *collectBtn = [CCButton buttonWithTitle:@" " spriteFrame:[CCSpriteFrame frameWithImageNamed:@"Collection.png"]];
    [collectBtn setTarget:self selector:@selector(onCollectionBtnClicked:)];
    [collectBtn setPositionType:CCPositionTypeNormalized];
    [collectBtn setScale:0.1*self.contentSize.width/collectBtn.contentSize.width];
    collectBtn.position = ccp(0.9f, 0.85f);
    
    //设置界面入口
    CCLabelTTF *setting = [CCLabelTTF labelWithString:@"Setting" fontName:@"ArialMT" fontSize:20];
    setting.color = [CCColor redColor];
    setting.positionType = CCPositionTypeNormalized;
    setting.position = ccp(0.5f, 0.3f);
    [self addChild:setting z:10];
    
    CCButton *setButton = [CCButton buttonWithTitle:@"Setting" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]];
    [setButton setTarget:self selector:@selector(onSetButtonClicked:)];
    setButton.positionType = CCPositionTypeNormalized;
    setButton.position = ccp(0.5f, 0.3f);
    
    //音乐播放器初始化
    [[AudioPlayer audioplayer] playMusic];
    
    // 添加到页面
    [self addChild:title z:10];
    [self addChild:beginButton z:9];
    [self addChild:assembleBtn z:9];
    [self addChild:collectBtn z:9];
    [self addChild:setButton z:9];
}

// -----------------------------------------------------------------

// 开始按钮回调函数
- (void)onBeginButtonClicked:(id)sender {
    if(isFirstRun==0){
        isFirstRun++;
    [[CCDirector sharedDirector] replaceScene:[processBar scene]
                               withTransition:[CCTransition transitionFadeWithColor:[CCColor redColor] duration:0.5f]];
    }
    else{
        [[CCDirector sharedDirector] replaceScene:[EnterLittleMap scene]
                                   withTransition:[CCTransition transitionFadeWithColor:[CCColor redColor] duration:0.5f]];
    }
}

- (void)onAssembleButtonClicked:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[SecondScene scene]
                               withTransition:[CCTransition transitionFadeWithColor:[CCColor redColor] duration:0.5f]];
}

- (void)onCollectionBtnClicked:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[CollectionScene scene]
                               withTransition:[CCTransition transitionFadeWithColor:[CCColor redColor] duration:0.5f]];
    
}

- (void)onSetButtonClicked:(id)sender {
    [[CCDirector sharedDirector] pushScene:[SettingScene scene]];
    /*    [[CCDirector sharedDirector] replaceScene:[SettingScene scene]
     withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
     */
}

@end





