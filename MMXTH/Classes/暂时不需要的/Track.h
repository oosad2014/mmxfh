//
//  Track.h
//
//  Created by : mac
//  Project    : MMXTH
//  Date       : 16/9/16
//
//  Copyright (c) 2016年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Train.h"

// -----------------------------------------------------------------

@interface Track : Train

// -----------------------------------------------------------------
// properties
@property(nonatomic, retain)NSMutableArray *trainArray;
@property(nonatomic, copy)NSString *url;
// -----------------------------------------------------------------
// methods

-(Track *)createWithExists:(Track *)head;

// -----------------------------------------------------------------

@end




