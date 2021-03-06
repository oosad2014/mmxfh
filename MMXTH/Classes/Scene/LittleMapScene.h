//
//  Newtest.h
//
//  Created by : dpc
//  Project    : MMXTH
//  Date       : 17/3/4
//
//  Copyright (c) 2017年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "DataManager.h"
#import "CollectObj.h"
#import "Train.h"
#import "TrainHead.h"
#import "PauseScene.h"

// -----------------------------------------------------------------

@interface Newtest : CCScene
{
    CCSprite *trainhead;
    Train *trainup;
    Train *_train;
    Train *traindown;
    Train *Checkpoint;
    Train *winpoint;
    Train *losepoint;
    CGPoint _preLoc;
    CGPoint _nextLoc;
    CGPoint _presentLoc;
       CGSize _tile;
    CGPoint _goal;
     CGPoint _start;
    int _row;
    int _column;
    int gamemode;
   BOOL isTraveling ;
     BOOL isPaused ;
    CGPoint _trainLoc;
    float _trainSpeedDuration;
    bool isPresentSelected;
}

// -----------------------------------------------------------------
// properties

// -----------------------------------------------------------------
// methods

@property(nonatomic, retain) CCNodeColor *backgrounds; // Node节点，用于盛放主scene层（变化层）
@property(nonatomic, retain) CCNodeColor *buttonLayer; // Node节点，用于盛放锁定按钮（固定层）
@property(nonatomic, retain) CCNodeColor *pauseLayer; // Node节点，用于盛放暂停按钮（固定层）
@property(nonatomic, retain) CCSprite *buttonLock; // 用于保存锁定按钮图片

// use for pause
@property(nonatomic,retain) CCRenderTexture *pauseTexture; // 用于保存暂停背景截图纹理
@property(nonatomic, retain) CCButton *pauseButton; //暂停按钮

//
@property(nonatomic, retain) NSMutableArray *posArray; // 记录铁轨路径点
@property(nonatomic, retain) CCDrawNode *node; // 用于画线的node

@property(nonatomic, retain) CCTexture *trackVertical;
@property(nonatomic, retain) CCTexture *trackHorizontal;
@property(nonatomic, retain) CCTexture *otherGoods;

@property(nonatomic, strong) DataManager *dataManager;

@property(nonatomic, retain) NSMutableArray *trackNowArray; // 当前已铺铁轨保存数组
@property(nonatomic, retain) NSMutableArray *trackArray;
@property(nonatomic,retain)    NSMutableArray *meshData;
@property(nonatomic,retain)    NSMutableArray *statearray;
@property(nonatomic,retain)    NSTimer *timer;
@property(nonatomic,retain)    NSMutableArray *railGroup;
@property(nonatomic,retain)    NSMutableArray *goodsarray;
@property(nonatomic,retain)    NSMutableArray *collectionsarray;
@property(nonatomic,retain)    NSMutableArray *kindsarray;
@property(nonatomic,retain)    NSMutableArray *scenekinds;
@property(nonatomic,retain)    NSMutableArray *collectgroup;

@property(nonatomic,retain)    NSMutableDictionary *collection;

@property(nonatomic, retain) CCNodeColor *panelLayer;
@property(nonatomic, assign) int collectionCount;

+ (id)scene;
- (Newtest *)init;
- (struct Coordinates)getCoordinate:(CGPoint)touchPos;
- (double)Floor:(double)num Pcs:(int)pcs;
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event;

- (id)initWithBGImageName:(NSString *)backgroundImage StageName:(NSString *)StageName;
// -----------------------------------------------------------------

@end




