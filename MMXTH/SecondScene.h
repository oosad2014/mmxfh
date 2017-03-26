//
//  SecondScene.h
//
//  Created by : mac
//  Project    : MMXTH
//  Date       : 16/9/14
//
//  Copyright (c) 2016年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "Train.h"
#import "TrainHead.h"
#import "DataManager.h"

// -----------------------------------------------------------------

@interface SecondScene : CCScene {
    TrainHead *trainHead; // 火车头
    TrainHead *newTrainHead; // 用于拖拉时保存产生的火车头
    TrainHead *selTrainHead; // 选中的火车头
}

// -----------------------------------------------------------------
// properties

@property(nonatomic, assign) BOOL isMoved; // 手指触屏是否在移动
@property(nonatomic, assign) BOOL spriteSelected; // 当前是否选中
@property(nonatomic, assign) int sceneHeadNow; // 界面当前显示的火车头浏览页码
@property(nonatomic, assign) CGPoint beganPoint; // 记录触屏开始点
@property(nonatomic, assign) CGSize viewSize; // 当前界面大小
@property(nonatomic, retain) TrainHead *boxHead; // 火车头拖拉终点
@property(nonatomic, retain) NSMutableArray<TrainHead *> *trainHeadArray; // 保存所有火车头种类

@property(nonatomic, weak) DataManager *dataManager; // 文件管理类

// -----------------------------------------------------------------
// methods

+ (SecondScene *)scene;
- (id)init;
-(void)initScene;

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event;

- (void)spriteSelectedOrNot:(CGPoint)pos;
// -----------------------------------------------------------------

@end




