//
//  Shop.m
//  MMXTH
//
//  Created by mac on 16/10/6.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "Shop.h"
#import "ShoppingThings.h"

@implementation Shop {
    int goodsNum;
}

@synthesize goodsShopArray;

static Shop *shop = nil;

+(Shop *)oneShop {
    if (shop == nil) {
        shop = [[Shop alloc] init];
    }
    
    return shop;
}

-(id)init {
    [self setGoodsNum:[ShoppingThings getGoodsCount]];
    //goodsShopArray = [goodsShopArray initWithCapacity:[self getGoodsNum]];
    goodsShopArray = [NSMutableArray arrayWithCapacity:[self getGoodsNum]];
    for (int i=1; i<=[self getGoodsNum]; i++) {
        ShoppingThings *goods = [[ShoppingThings alloc] init];
        [ShoppingThings setCount:i-1];
        switch (i%6) {
            case 1:
                goods = [goods create:i/6 + 0.25f ySet:0.7f];
                break;
            case 2:
                goods = [goods create:i/6 + 0.25f ySet:0.3f];
                break;
            case 3:
                goods = [goods create:i/6 + 0.5f ySet:0.7f];
                break;
            case 4:
                goods = [goods create:i/6 + 0.5f ySet:0.3f];
                break;
            case 5:
                goods = [goods create:i/6 + 0.75f ySet:0.7f];
                break;
            case 0:
                goods = [goods create:(i/6 - 1) + 0.75f ySet:0.3f];
                break;
                
            default:
                break;
        }
        
        [goodsShopArray addObject:goods];
    }
    
    return self;
}

-(void)setGoodsNum:(int)num {
    goodsNum = num;
}

-(int)getGoodsNum {
    return goodsNum;
}

@end
