//
//  Customer.m
//
//  Created by : Mac
//  Project    : MMXTH
//  Date       : 16/10/6
//
//  Copyright (c) 2016年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "Customer.h"

// -----------------------------------------------------------------

@implementation Customer

// -----------------------------------------------------------------


- (id)init
{
    self = [super init];
    for(int n=0;n<3;++n)
    {
        goods[n]=0;
    }
    return self;
}
-(void) Buy:(int)b
{
    goods[b-1]=1;
}
-(int*)ShowBuy{
    return goods;
    
}

// -----------------------------------------------------------------

@end





