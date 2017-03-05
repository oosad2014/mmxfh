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

// -----------------------------------------------------------------

@implementation FirstScene

// -----------------------------------------------------------------

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
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:27.0f/255.0f green:185.0f/255.0f blue:239.0f/255.0f alpha:1.0f]];
    [self addChild:background];
    
    [self initScene];

    return self;
}

// 界面额外的初始化
-(void)initScene {
    // Background
    // You can change the .png files to change the background
    // 背景图
    CCSprite9Slice *background = [CCSprite9Slice spriteWithImageNamed:@"backGround2.png"];
    [background setPosition:ccp(0.5f, 0.5f)];
    [background setPositionType:CCPositionTypeNormalized];
    [background setScale:self.contentSize.width / background.contentSize.width];
    [self addChild:background];
    
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
    
    // 添加到页面
    [self addChild:title z:10];
    [self addChild:beginButton z:9];
}

// -----------------------------------------------------------------

// 开始按钮回调函数
- (void)onBeginButtonClicked:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[processBar scene]
                               withTransition:[CCTransition transitionFadeWithColor:[CCColor redColor] duration:0.5f]];
}

@end





