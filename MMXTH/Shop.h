//
//  Shop.h
//
//  Created by : Mac
//  Project    : MMXTH
//  Date       : 16/10/7
//
//  Copyright (c) 2016年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import"ShopController.h"

// -----------------------------------------------------------------

@interface ShopScene : CCScene
{
    ShopController * mscontroller;
}

// -----------------------------------------------------------------
// properties

// -----------------------------------------------------------------
// methods

- (instancetype)init;
+ (ShopScene *)scene;

// -----------------------------------------------------------------

@end




