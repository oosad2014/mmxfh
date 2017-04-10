//
//  TrainHead.h
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
#import "DataManager.h"

// -----------------------------------------------------------------

@interface TrainHead : Train

// -----------------------------------------------------------------
// properties

@property(nonatomic, retain)NSArray *trainArray;
@property(nonatomic, copy)NSString *url;

@property(weak) DataManager *dataManager;
// -----------------------------------------------------------------
// methods

-(TrainHead *)createWithExists:(TrainHead *)head;
// -----------------------------------------------------------------

@end




