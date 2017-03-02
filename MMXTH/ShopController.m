//
//  ShopController.m
//  MMXTH
//
//  Created by Mac on 16/10/7.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"ShopController.h"
@implementation ShopController
@synthesize GoodsArray;
-(id)init
{
    self = [super init];
   GoodsArray = [NSArray arrayWithObjects:@"train", @"traingood", @"button", nil];
    thecustomer=[[Customer alloc] init];
    return self;
}
-(void)buy:(int) x
{
    [thecustomer Buy:x];
    
}
-(void) showbuy
{
    int * buylist=thecustomer.ShowBuy;
    for(int n=0;n<3;++n)
    {
        if(buylist[n]>0)
        
      CCLOG(@"buygoods, Count:  good number is %d",n+1 );
    }
}
//+(NSArray *) showNbuy;


@end