//
//  CollectObj.h
//
//  Created by : dpc
//  Project    : MMXTH
//  Date       : 17/5/1
//
//  Copyright (c) 2017年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// -----------------------------------------------------------------

@interface CollectObj : CCSprite

// -----------------------------------------------------------------
// properties

// -----------------------------------------------------------------
// methods

+ (instancetype)node;
- (instancetype)init;
-(void)setCount:(int)count;
-(int)getCount;

// -----------------------------------------------------------------

@end




