//
//  ModleController.m
//  MMXTH
//
//  Created by Mac on 16/9/22.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"ModleController.h"


@implementation ModleController

-(id)init
{
    self = [super init];
    train=NULL;
    SouceNum=0;
    return self;
}
-(void)setTrain:(Train *)mtrain
{
    train=mtrain;
}
-(void)setSouceNum:(int)tNum
{
    SouceNum=tNum;
}
-(Train *)getTrain
{
    return train;
}
-(int) getSouceNum
{
    return SouceNum;
}





@end

