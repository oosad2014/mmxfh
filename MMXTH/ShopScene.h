//
//  ShopScene.h
//  MMXTH
//
//  Created by mac on 16/10/6.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface ShopScene : CCScene

@property(nonatomic, retain)NSMutableArray *goodsArray;
@property(nonatomic, retain)CCButton *lastButton;
@property(nonatomic, retain)CCButton *nextButton;

@end
