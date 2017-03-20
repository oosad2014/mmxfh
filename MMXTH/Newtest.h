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
#import "train.h"

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

@property(nonatomic, retain) NSMutableArray *trackNowArray; // 当前已铺铁轨保存数组
@property(nonatomic, retain) NSMutableArray *trackArray;

@property(nonatomic,retain)    NSMutableArray *meshData;
@property(nonatomic,retain)    NSMutableArray *statearray;
@property(nonatomic,retain)    NSTimer *timer;
+ (id)scene;
- (Newtest *)init;
- (struct Coordinates)getCoordinate:(CGPoint)touchPos;
- (double)Floor:(double)num Pcs:(int)pcs;
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
// -----------------------------------------------------------------

@end




