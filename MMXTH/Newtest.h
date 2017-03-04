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
#import "train.h"

// -----------------------------------------------------------------

@interface Newtest : CCScene
{
    CCSprite *trainhead;
    Train *trainup;
    Train *traindown;
    Train *Checkpoint;
    
}

// -----------------------------------------------------------------
// properties

// -----------------------------------------------------------------
// methods



+ (id)scene;
- (Newtest *)init;
// -----------------------------------------------------------------

@end




