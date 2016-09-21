//
//  Train.h
//
//  Created by : mac
//  Project    : MMXTH
//  Date       : 16/9/12
//
//  Copyright (c) 2016年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// -----------------------------------------------------------------

@interface Train : CCSprite <NSCopying>{
    float Row;
    float Column;
}

// -----------------------------------------------------------------
// properties

@property(nonatomic, retain)NSArray *trainArray;
@property(nonatomic, copy)NSString *url;

// -----------------------------------------------------------------
// methods

-(Train *)create:(float)x ySet:(float)y;
-(void)setRow:(float)x;
-(void)setColumn:(float)y;
-(float)getRow;
-(float)getColumn;
+(void)setCount:(int)count;
+(int)getCount;
// -----------------------------------------------------------------

@end




