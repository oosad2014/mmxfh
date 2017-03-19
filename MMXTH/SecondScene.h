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
#import "TrainGoods.h"
#import "Track.h"

// -----------------------------------------------------------------

// 此处定义的静态用于其它类调用
static TrainHead *selTrainHead; // 选中的火车头
static TrainGoods *selTrainGoods; // 选中的火车货物
static Track *selTrainTrack; // 选中的火车轨
@interface SecondScene : CCScene {
    TrainHead *trainHead; // 火车头
    TrainHead *newTrainHead; // 用于拖拉时保存产生的火车头
    TrainGoods *trainGoods; // 火车货物
    TrainGoods *newTrainGoods; // 用于拖拉时保存产生的火车货物
    Track *trainTrack; // 火车轨
    Track *newTrainTrack; // 用于拖拉时保存产生的火车轨
}

// -----------------------------------------------------------------
// properties

// 用于判断当前浏览界面的枚举类
enum TRAIN {
    train_Head = 1,
    train_Goods,
    train_Track
};

@property(nonatomic, assign) BOOL isMoved; // 手指触屏是否在移动
@property(nonatomic, assign) BOOL spriteSelected; // 当前是否选中
@property(nonatomic, assign) enum TRAIN trainNow; // 当前浏览界面
@property(nonatomic, assign) int sceneHeadNow; // 界面当前显示的火车头浏览页码
@property(nonatomic, assign) int sceneGoodsNow; // 界面当前显示的火车货物浏览页码
@property(nonatomic, assign) int sceneTrackNow; // 界面当前显示的火车轨浏览页码
@property(nonatomic, assign) CGPoint beganPoint; // 记录触屏开始点
@property(nonatomic, assign) CGSize viewSize; // 当前界面大小
@property(nonatomic, retain) CCSprite *boxHead; // 火车头拖拉终点
@property(nonatomic, retain) CCSprite *boxGoods; // 货车货物拖拉终点
@property(nonatomic, retain) CCSprite *boxTrack; // 火车轨拖拉终点
@property(nonatomic, retain) CCButton *trainHeadBtn; // 浏览界面的火车头选择按钮
@property(nonatomic, retain) CCButton *trainGoodsBtn; // 浏览界面的火车货物选择按钮
@property(nonatomic, retain) CCButton *trackBtn; // 浏览界面的火车轨选择按钮
@property(nonatomic, retain) NSMutableArray<TrainHead *> *trainHeadArray; // 保存所有火车头种类
@property(nonatomic, retain) NSMutableArray<TrainGoods *> *trainGoodsArray; // 保存所有火车货物种类
@property(nonatomic, retain) NSMutableArray<Track *> *trackArray; // 保存所有火车轨种类

// -----------------------------------------------------------------
// methods

+ (SecondScene *)scene;
- (id)init;
-(void)initScene;

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event;

+ (TrainHead *)getTrainHeadSel;
+ (TrainGoods *)getTrainGoodsSel;
+ (Track *)getTrackSel;
// -----------------------------------------------------------------

@end




