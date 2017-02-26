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

// -----------------------------------------------------------------
// methods

+ (id)scene;
- (TestTrackScene *)init;


- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
// -----------------------------------------------------------------

@end




