//
//  TestChinaMapScene.m
//  MMXTH
//
//  Created by 修海锟 on 2017/3/26.
//  Copyright © 2017年 xc. All rights reserved.
//

#import "TestChinaMapScene.h"

@implementation TestChinaMapScene

+ (id)scene {
    return [[self alloc] init];
}

- (TestChinaMapScene *)init {
    if ((self = [super init])) {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    }
    
    [self setUserInteractionEnabled:YES];
    [self setMultipleTouchEnabled:YES];
    
    // 从Scene处理到Node的处理的跨越
    CCNode *background = [CCNodeColor nodeWithColor:[CCColor blackColor]];
    
    // 使主Scene层在最下方
    [self addChild:background z: 1];
    
    CCSprite *chinaMap = [CCSprite spriteWithImageNamed:@"stage_1/stage_1.png"];
    [chinaMap setPositionType:CCPositionTypeNormalized];
    [chinaMap setPosition:CGPointMake(0.5f, 0.5f)];
    [chinaMap setScale:(self.contentSize.height / chinaMap.contentSize.height)];
    
    [background addChild:chinaMap z: 2];
    
    CCSprite *guangDong = [CCSprite spriteWithImageNamed:@"广东.png"];
    [guangDong setPosition:CGPointMake(0.5 * chinaMap.contentSize.width + 194, 0.5 * chinaMap.contentSize.height - 259)];
    
    [chinaMap addChild:guangDong z: 1];
    
    return self;
}




@end
