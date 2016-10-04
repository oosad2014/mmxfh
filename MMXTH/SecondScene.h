//
//  SecondScene.h
//
//  Created by : Mac
//  Project    : MMXTH
//  Date       : 16/9/17
//
//  Copyright (c) 2016年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "Train.h"
#import "ModleController.h"

// -----------------------------------------------------------------

@interface SecondScene : CCScene {
    ModleController *mController;
   Train *train;
   Train *Traingoods;
    Train *trainHead;
    Train *newTrain;
}

// -----------------------------------------------------------------
// properties

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




