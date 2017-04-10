//
//  Shop.h
//  MMXTH
//
//  Created by mac on 16/10/6.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shop : NSObject

@property(nonatomic, retain)NSMutableArray *goodsShopArray;

+(Shop *)oneShop;
-(void)setGoodsNum:(int)num;
-(int)getGoodsNum;

@end
