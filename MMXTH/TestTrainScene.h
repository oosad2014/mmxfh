//
//  TestTrainScene.h
//
//  Created by : mac
//  Project    : MMXTH
//  Date       : 16/10/26
//
//  Copyright (c) 2016年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "TrainHead.h"
#import "TrainGoods.h"
#import "Track.h"

// -----------------------------------------------------------------

@interface TestTrainScene : CCScene

// -----------------------------------------------------------------
// properties
@property(nonatomic, retain) CCSprite *background; // 用于保存游戏界面背景图
@property(nonatomic, retain) CCTexture *backgroundImg; // 用于储存背景的纹理
@property(nonatomic, assign) BOOL isLocked; // 记录是否锁定视角
@property(nonatomic, retain) CCNodeColor *backgrounds; // Node节点，用于盛放主scene层（变化层）
@property(nonatomic, retain) CCNodeColor *buttonLayer; // Node节点，用于盛放锁定按钮（固定层）
@property(nonatomic, retain) CCNodeColor *pauseLayer; // Node节点，用于盛放暂停按钮（固定层）
@property(nonatomic, retain) CCSprite *buttonLock; // 用于保存锁定按钮图片
@property(nonatomic, retain) TrainHead *trainHead; // 火车头
@property(nonatomic, retain) TrainGoods *trainGoods; // 货车货物
@property(nonatomic, retain) Track *track; // 火车轨

// use for pause
@property(nonatomic,retain) CCRenderTexture *pauseTexture; // 用于保存暂停背景截图纹理
@property(nonatomic, retain) CCButton *pauseButton; //暂停按钮
// -----------------------------------------------------------------
// methods

+ (TestTrainScene *)scene;
- (id)init;

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
// -----------------------------------------------------------------

@end




