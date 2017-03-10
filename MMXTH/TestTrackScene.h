//
//  TestTrackScene.h
//
//  Created by : mac
//  Project    : MMXTH
//  Date       : 16/11/23
//
//  Copyright (c) 2016年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "Train.h"

// -----------------------------------------------------------------

@interface TestTrackScene : CCScene {
    CCSprite *trainhead;
    Train *Trainup;
    Train *traindown;
    Train *Checkpoint;
}

// -----------------------------------------------------------------
// properties
@property(nonatomic, retain) NSMutableArray *posArray; // 记录铁轨路径点
@property(nonatomic, retain) CCDrawNode *node; // 用于画线的node

@property(nonatomic, retain) CCTexture *trackVertical;
@property(nonatomic, retain) CCTexture *trackHorizontal;
@property(nonatomic, retain) CCTexture *otherGoods;

@property(nonatomic, retain) NSMutableArray *trackNowArray; // 当前已铺铁轨保存数组
@property(nonatomic, retain) NSMutableArray *trackArray; // 全部铁轨网格
// -----------------------------------------------------------------
// methods

+ (id)scene;
- (TestTrackScene *)init;

- (struct Coordinates)getCoordinate:(CGPoint)touchPos;
- (double)Floor:(double)num Pcs:(int)pcs;

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
// -----------------------------------------------------------------

@end




