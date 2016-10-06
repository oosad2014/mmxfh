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
    for (int i=1; i<=[self getGoodsNum]; i++) {
        ShoppingThings *goods = [[ShoppingThings init] alloc];
        [ShoppingThings setCount:i-1];
        switch (i%6) {
            case 1:
                [goods create:0.25f ySet:0.4f];
                break;
            case 2:
                [goods create:0.25f ySet:0.8f];
                break;
            case 3:
                [goods create:0.5f ySet:0.4f];
                break;
            case 4:
                [goods create:0.5f ySet:0.8f];
                break;
            case 5:
                [goods create:0.75f ySet:0.4f];
                break;
            case 0:
                [goods create:0.75f ySet:0.8f];
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
