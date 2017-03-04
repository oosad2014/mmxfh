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
    Train *traindown;
    Train *Checkpoint;
    Train *winpoint;
    Train *losepoint;
    
}

// -----------------------------------------------------------------
// properties

// -----------------------------------------------------------------
// methods



+ (id)scene;
- (Newtest *)init;
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
// -----------------------------------------------------------------

@end




