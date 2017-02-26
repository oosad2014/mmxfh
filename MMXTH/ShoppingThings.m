//
//  ShoppingThings.m
//  MMXTH
//
//  Created by mac on 16/10/6.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "ShoppingThings.h"

@implementation ShoppingThings {
    BOOL buyOrNot;
    int ID;
    float Row;
    float Column;
}

static int count = 0;
static int goodsCount = 18;

@synthesize goodsArray;
@synthesize url;

// -----------------------------------------------------------------

-(id)init {
    self = [super init];
    [self setRow:0];
    [self setColumn:0];
    [self setBuyOrNot:NO];
    
    url = @"";
    goodsArray = [NSMutableArray arrayWithCapacity:0]; // 初始化可变数组
    for (int i=0; i<goodsCount; i+=2) {
        [goodsArray addObject:@"Icon-Small.png"];
        [goodsArray addObject:@"button.png"];
    }
    
    return self;
}

-(void)setRow:(float)x {
    Row = x;
}

-(void)setColumn:(float)y {
    Column = y;
}

+(void)setGoodsCount:(int)count; {
    goodsCount = count;
}

-(void)setBuyOrNot:(BOOL)buyYN {
    buyOrNot = buyYN;
}

-(void)setGoodsID:(int)id {
    ID = id;
}

+(void)setCount:(int)countNew {
    count = countNew;
}

-(float)getRow {
    return Row;
}

-(float)getColumn {
    return Column;
}

+(int)getGoodsCount {
    return goodsCount;
}

-(BOOL)getBuyOrNot {
    return buyOrNot;
}

-(int)getGoodsID {
    return ID;
}

+(int)getCount {
    return count;
}

// -----------------------------------------------------------------

-(ShoppingThings *)create:(float)x ySet:(float)y {
    // 外部通过类的Count参数创建
    ShoppingThings *goods = [ShoppingThings spriteWithImageNamed:[goodsArray objectAtIndex:[ShoppingThings getCount]]];
    goods.url = [goodsArray objectAtIndex:[ShoppingThings getCount]];
    [goods setGoodsID:[ShoppingThings getCount]];
    [goods setBuyOrNot:NO]; //未购买(后期调成自文件创建)
    [goods setRow:x];
    [goods setColumn:y];
    goods.positionType = CCPositionTypeNormalized;
    [goods setPosition:ccp([goods getRow], [goods getColumn])];
    return goods;
}


@end
