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
    CCSprite9Slice *background = [CCSprite9Slice spriteWithImageNamed:@"firstscene.png"];
    [background setPosition:ccp(0.5f, 0.5f)];
    [background setPositionType:CCPositionTypeNormalized];
    [background setScale:self.contentSize.width / background.contentSize.width];
    [background setOpacity:0.8];
    [self addChild:background];
    
    CCButton *begin = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"开始游戏.png"]];
    [begin setScale:(self.contentSize.width / begin.contentSize.width * 0.25f)];
    [begin setPositionType:CCPositionTypeNormalized];
    [begin setTarget:self selector:@selector(onBeginButtonClicked:)];
    [begin setPosition:ccp(0.5f, 0.5f)];
    [self addChild:begin z:12];
    
    // 添加到页面

}

// -----------------------------------------------------------------

// 开始按钮回调函数
- (void)onBeginButtonClicked:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[processBar scene]
                               withTransition:[CCTransition transitionFadeWithColor:[CCColor redColor] duration:0.5f]];
}

@end





