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

// -----------------------------------------------------------------

@interface SecondScene : CCScene {
    Train *train;
}

// -----------------------------------------------------------------
// properties

// -----------------------------------------------------------------
// methods

+ (SecondScene *)scene;
- (id)init;

// -----------------------------------------------------------------

@end



