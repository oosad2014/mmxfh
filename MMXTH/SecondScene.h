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

@interface SecondScene : CCScene {
    TrainHead *trainHead;
    TrainHead *newTrainHead;
    TrainHead *selTrainHead;
    TrainGoods *trainGoods;
    TrainGoods *newTrainGoods;
    TrainGoods *selTrainGoods;
    Track *trainTrack;
    Track *newTrainTrack;
    Track *selTrainTrack;
}

// -----------------------------------------------------------------
// properties

enum TRAIN {
    train_Head = 1,
    train_Goods,
    train_Track
};

@property(nonatomic, assign) BOOL isMoved;
@property(nonatomic, assign) BOOL spriteSelected;
@property(nonatomic, assign) enum TRAIN trainNow;
@property(nonatomic, assign) int sceneHeadNow;
@property(nonatomic, assign) int sceneGoodsNow;
@property(nonatomic, assign) int sceneTrackNow;
@property(nonatomic, assign) CGPoint beganPoint;
@property(nonatomic, assign) CGSize viewSize;
@property(nonatomic, retain) CCSprite *boxHead;
@property(nonatomic, retain) CCSprite *boxGoods;
@property(nonatomic, retain) CCSprite *boxTrack;
@property(nonatomic, retain) CCButton *trainHeadBtn;
@property(nonatomic, retain) CCButton *trainGoodsBtn;
@property(nonatomic, retain) CCButton *trackBtn;
@property(nonatomic, retain) NSMutableArray<TrainHead *> *trainHeadArray;
@property(nonatomic, retain) NSMutableArray<TrainGoods *> *trainGoodsArray;
@property(nonatomic, retain) NSMutableArray<Track *> *trackArray;

// use for pause
@property(nonatomic,retain) CCRenderTexture *pauseTexture;
@property(nonatomic, retain) CCButton *pauseButton;
// -----------------------------------------------------------------
// methods

+ (SecondScene *)scene;
- (id)init;
-(void)initScene;
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
// -----------------------------------------------------------------

@end




