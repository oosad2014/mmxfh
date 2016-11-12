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
@property(nonatomic, retain) CCSprite *background;
@property(nonatomic, retain) CCTexture *backgroundImg;
@property(nonatomic, assign) CGPoint tempTran;
@property(nonatomic, assign) CGPoint oldTranCenter;
@property(nonatomic, assign) BOOL isMoved;
@property(nonatomic, assign) BOOL isLocked;
@property(nonatomic, retain) CCNodeColor *backgrounds;
@property(nonatomic, retain) CCNodeColor *buttonLayer;
@property(nonatomic, retain) CCNodeColor *pauseLayer;
@property(nonatomic, retain) CCSprite *buttonLock;
@property(nonatomic, retain) TrainHead *trainHead;
@property(nonatomic, retain) TrainGoods *trainGoods;
@property(nonatomic, retain) Track *track;

// use for pause
@property(nonatomic,retain) CCRenderTexture *pauseTexture;
@property(nonatomic, retain) CCButton *pauseButton;
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




