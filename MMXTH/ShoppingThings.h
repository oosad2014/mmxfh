//
//  ShoppingThings.h
//  MMXTH
//
//  Created by mac on 16/10/6.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "CCSprite.h"

@interface ShoppingThings : CCSprite 

@property(nonatomic, retain)NSMutableArray *goodsArray;
@property(nonatomic, copy)NSString *url;

// -----------------------------------------------------------------
// methods

-(ShoppingThings *)create:(float)x ySet:(float)y;
-(void)setRow:(float)x;
-(void)setColumn:(float)y;
-(float)getRow;
-(float)getColumn;
+(void)setGoodsCount:(int)count;
+(int)getGoodsCount;
-(void)setBuyOrNot:(BOOL)buyOrNot;
-(BOOL)getBuyOrNot;
-(void)setGoodsID:(int)ID;
-(int)getGoodsID;
+(void)setCount:(int)count;
+(int)getCount;

@end
