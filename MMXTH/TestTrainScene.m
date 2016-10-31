//
//  TestTrainScene.m
//
//  Created by : mac
//  Project    : MMXTH
//  Date       : 16/10/26
//
//  Copyright (c) 2016年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "TestTrainScene.h"

// #define SCALE 3.0
#define LIGHT_ADJUST 0.02 // 微调参数

// -----------------------------------------------------------------

@implementation TestTrainScene

@synthesize background;
@synthesize backgroundImg;
@synthesize tempTran;
@synthesize oldTranCenter;
@synthesize isMoved;
@synthesize isLocked;
// -----------------------------------------------------------------

+ (TestTrainScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    if ((self = [super init])) {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    }
    // 暂时不知道为什么必须定义一个CCNodeColor才能使用触屏功能
    CCNodeColor *backgrounds = [CCNodeColor nodeWithColor:[CCColor blackColor]];
    [self addChild:backgrounds];
    
    [self setUserInteractionEnabled:YES]; // 设置支持触屏
    [self setMultipleTouchEnabled:YES]; // 设置支持多点触屏
    backgroundImg = [CCTexture textureWithFile:@"backGround.png"];
    tempTran = CGPointMake(0, 0);
    oldTranCenter = CGPointMake(0.5f, 0.5f);
    isMoved = NO;
    isLocked = NO;
    
    [self initScene];
    
    return self;
}

-(void)initScene {
    // Scene的Positon设置是根据像素而非比例设置,sprite的是根据比例设置
    background = [CCSprite spriteWithTexture: backgroundImg];
    [background setPosition:ccp(0.5f, 0.5f)];
    [background setPositionType:CCPositionTypeNormalized];
    [background setScale:0.5];
    [self addChild:background z:5];
    
    [self setAnchorPoint:CGPointZero];
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    NSArray *touches = [[event allTouches] allValues];
    
    if (touches.count == 2) {
        CCTouch *touch1 = [touches objectAtIndex:0];
        CCTouch *touch2 = [touches objectAtIndex:1];
        CGPoint touchPoint1 = [touch1 locationInNode:self];
        CGPoint touchPoint2 = [touch2 locationInNode:self];
        
        CCLOG(@"Point1: %@ Point2: %@", NSStringFromCGPoint(touchPoint1), NSStringFromCGPoint(touchPoint2));
    }
    else {
        CGPoint touchPoint = [touch locationInNode:self];
        CCLOG(@"onlyPoint1: %@", NSStringFromCGPoint(touchPoint));
    }
    CCLOG(@"touchBegan--->%lu", (unsigned long)touches.count);
    // CGPoint touchPoint = [touch locationInNode:self];
}

-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    NSArray *touches = [[event allTouches] allValues];
    CCLOG(@"touchMoved--->%lu", (unsigned long)touches.count);
    
    if (touches.count == 2) {
        CCTouch *touch1 = [touches objectAtIndex:0];
        CCTouch *touch2 = [touches objectAtIndex:1];
        CGPoint oldTouchPoint1 = [touch1 previousLocationInView:touch1.view];
        CGPoint oldTouchPoint2 = [touch2 previousLocationInView:touch2.view];
        CGPoint touchPoint1 = [touch1 locationInNode:self];
        CGPoint touchPoint2 = [touch2 locationInNode:self];
        oldTouchPoint1 = [[CCDirector sharedDirector] convertToGL:oldTouchPoint1];
        oldTouchPoint1 = [self convertToNodeSpace:oldTouchPoint1];
        oldTouchPoint2 = [[CCDirector sharedDirector] convertToGL:oldTouchPoint2];
        oldTouchPoint2 = [self convertToNodeSpace:oldTouchPoint2];
        
        CGPoint newTranCenter = ccpMult(ccpAdd(oldTouchPoint1, oldTouchPoint2), 0.5);
        //CCLOG(@"Center: %@", NSStringFromCGPoint(newTranCenter));
        
        CGFloat oldTranLoc = ccpDistance(oldTouchPoint1, oldTouchPoint2); // 两个Point变幻之前的距离
        CGFloat tranLoc = ccpDistance(touchPoint1, touchPoint2); // 两个Point变幻之后的距离
        
        //CCLOG(@"oldDistance: %f newDistance: %f", oldTranLoc, tranLoc);
        
        double tempScale = [self scale] * tranLoc / oldTranLoc;
        // tempScale 约束到1 －> 2之间
        tempScale = tempScale <= 1 ? 1 : tempScale;
        tempScale = tempScale >= 5 ? 5 : tempScale;
        
        CGPoint oldAnchorPoint = [self anchorPoint];
        oldAnchorPoint.x *= self.contentSize.width;
        oldAnchorPoint.y *= self.contentSize.height;
        CGPoint tranFromAnchor = ccpSub(newTranCenter, oldAnchorPoint);
        CGPoint newPosition = [self position];
        double scale = [self scale];
        newPosition.x += tranFromAnchor.x * scale;
        newPosition.y += tranFromAnchor.y * scale;
        
        CGPoint newAnchorPoint = CGPointMake(newTranCenter.x/self.contentSize.width, newTranCenter.y/self.contentSize.height);
        //CCLOG(@"AP: %f NP: %f", (1.0 - newAnchorPoint.y) * tempScale * self.contentSize.height, self.contentSize.height - newPosition.y);
        if (newAnchorPoint.y * tempScale * self.contentSize.height < newPosition.y) {
            newAnchorPoint.y = 0.0;
            newPosition.y = 0.0;
            CCLOG(@"Bottom get!");
        }
        if ((1.0 - newAnchorPoint.y) * tempScale * self.contentSize.height < (self.contentSize.height - newPosition.y)) {
            newAnchorPoint.y = 1.0;
            newPosition.y = self.contentSize.height;
            CCLOG(@"Top get!");
        }
        if (newAnchorPoint.x * tempScale * self.contentSize.width < newPosition.x) {
            newAnchorPoint.x = 0.0;
            newPosition.x = 0.0;
            CCLOG(@"left get!");
        }
        if ((1.0 - newAnchorPoint.x) * tempScale * self.contentSize.width < (self.contentSize.width - newPosition.x)) {
            newAnchorPoint.x = 1.0;
            newPosition.x = self.contentSize.width;
            CCLOG(@"right get!");
        }
        
        // 重置锚点与位置，scene对应屏幕
        [self setAnchorPoint:newAnchorPoint];
        [self setPosition:newPosition];
        //CCLOG(@"NAP: %@, NP: %@", NSStringFromCGPoint(newAnchorPoint), NSStringFromCGPoint(newPosition));
        
        [self setScale:tempScale];
        CCLOG(@"scale: %f", [self scale]);

        /*
         **当初天真的自我实现
        CCTouch *touch1 = [touches objectAtIndex:0];
        CCTouch *touch2 = [touches objectAtIndex:1];
        CGPoint touchPoint1 = [touch1 locationInNode:self];
        CGPoint touchPoint2 = [touch2 locationInNode:self];
        CGPoint oldTouchPoint1 = [touch1 previousLocationInView:touch1.view];
        CGPoint oldTouchPoint2 = [touch2 previousLocationInView:touch2.view];
        oldTouchPoint1 = [[CCDirector sharedDirector] convertToGL:oldTouchPoint1];
        oldTouchPoint1 = [self convertToNodeSpace:oldTouchPoint1];
        oldTouchPoint2 = [[CCDirector sharedDirector] convertToGL:oldTouchPoint2];
        oldTouchPoint2 = [self convertToNodeSpace:oldTouchPoint2];
        
        CGPoint newTranCenter = ccpMult(ccpAdd(oldTouchPoint1, oldTouchPoint2), 0.5);
        newTranCenter.x /= self.contentSize.width;
        newTranCenter.y /= self.contentSize.height;
        
        //CGPoint tran1 = ccpSub(touchPoint1, oldTouchPoint1); // Point1的变换
        //CGPoint tran2 = ccpSub(touchPoint2, oldTouchPoint2); // Point2的变换
        
        CGFloat oldTranLoc = ccpDistance(oldTouchPoint1, oldTouchPoint2); // 两个Point变幻之前的距离
        CGFloat tranLoc = ccpDistance(touchPoint1, touchPoint2); // 两个Point变幻之后的距离
        
        CCLOG(@"oldDistance: %f newDistance: %f", oldTranLoc, tranLoc);
        
        double tempScale = [background scale] * tranLoc / oldTranLoc;
        // 包含一个防颤抖处理（还未完善，需优化）
        //double tempScale = [background scale] * ((tranLoc / oldTranLoc >= 1 + LIGHT_ADJUST) || (tranLoc / oldTranLoc <= 1 -LIGHT_ADJUST) ? tranLoc / oldTranLoc : 1.0);
    
        // tempScale 约束到0.5 －> 2之间
        tempScale = tempScale <= 0.5 ? 0.5 : tempScale;
        tempScale = tempScale >= 2 ? 2 : tempScale;
        CCLOG(@"scale1: %f", [background scale]);
        
        if (!isMoved) {
            isMoved = YES; // 用于标注开始移动
            tempTran = ccpSub(newTranCenter, oldTranCenter);
        }
        
        
        //之后素材需要刚刚好与背景相同
        //tempTran.x *= [background scale];
        //tempTran.y *= [background scale];
         
        CGPoint tranCenter = ccpSub(newTranCenter, tempTran);
        CCLOG(@"width: %f height: %f", background.contentSize.width, background.contentSize.height);
        CGFloat bgWidth = (background.contentSize.width * background.scale / 2 / self.contentSize.width) - LIGHT_ADJUST;
        CGFloat bgHeigh = (background.contentSize.height * background.scale / 2 / self.contentSize.height) - LIGHT_ADJUST;
        CCLOG(@"width: %f height: %f", bgWidth , bgHeigh);
        tranCenter.x = tranCenter.x <= bgWidth ? tranCenter.x : bgWidth;
        tranCenter.x = tranCenter.x >= 1.0 - bgWidth ? tranCenter.x : 1.0 - bgWidth;
        tranCenter.y = tranCenter.y <= bgHeigh ? tranCenter.y : bgHeigh;
        tranCenter.y = tranCenter.y >= 1.0 - bgHeigh ? tranCenter.y : 1.0 - bgHeigh;
        
        [background setScale:tempScale];
        [background setPosition:tranCenter];
        CCLOG(@"scale2: %f", [background scale]);
        CCLOG(@"center: %@", NSStringFromCGPoint(tranCenter));
        oldTranCenter = tranCenter;
         */
    }
    else {
        CGPoint touchPoint = [touch locationInNode:self];
        CGPoint oldTouchPoint = [touch previousLocationInView:touch.view];
        oldTouchPoint = [[CCDirector sharedDirector] convertToGL:oldTouchPoint];
        oldTouchPoint = [self convertToNodeSpace:oldTouchPoint];
        
        CGFloat scale = [self scale];
        CGPoint nowPos = [self position];
        CGPoint tran = ccpSub(touchPoint, oldTouchPoint); // 识别移动距离，仅通过一个点
        tran.x *= scale;
        tran.y *= scale;
        
        CCLOG(@"oldPosition: %@", NSStringFromCGPoint(nowPos));
        CGPoint anchorPoint = [self anchorPoint];
        CGPoint newPosition = ccpAdd(tran, nowPos);
        
        newPosition.y = (anchorPoint.y * scale * self.contentSize.height < newPosition.y) || (1.0 - anchorPoint.y) * scale * self.contentSize.height < (self.contentSize.height - newPosition.y) ? nowPos.y : newPosition.y;
        newPosition.x = (anchorPoint.x * scale * self.contentSize.width < newPosition.x) || (1.0 - anchorPoint.x) * scale * self.contentSize.width < (self.contentSize.width - newPosition.x) ? nowPos.x : newPosition.x;
        
        [self setPosition:newPosition];
        CCLOG(@"newPosition: %@", NSStringFromCGPoint(newPosition));
        CCLOG(@"OnlyTran: %@", NSStringFromCGPoint(tran));
    }
}

-(void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CCLOG(@"touchCancelled!");
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    NSArray *touches = [[event allTouches] allValues];
    
    isMoved = NO;
    CCLOG(@"touchEnded--->%lu", (unsigned long)touches.count);
}
// -----------------------------------------------------------------

@end





