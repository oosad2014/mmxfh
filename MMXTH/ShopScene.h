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
@property(nonatomic, retain)NSMutableArray *goodsArraySel; // 选择后的goods页面数组
@property(nonatomic, retain)CCButton *lastButton;
@property(nonatomic, retain)CCButton *nextButton;
@property(nonatomic, retain)CCButton *selectButton; // 用于过滤的按钮，之后可以用checkbox代替
@property(nonatomic, retain)CCButton *recoverButton;
@property(assign)int countSel;

@end
