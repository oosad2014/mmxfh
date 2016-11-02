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
@synthesize backgrounds;
@synthesize buttonLayer;
@synthesize buttonLock;
@synthesize pandaTrain;
// -----------------------------------------------------------------

static CGPoint oldPoint;

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
    // 从Scene处理到Node的处理的跨越
    backgrounds = [CCNodeColor nodeWithColor:[CCColor blackColor]];
    buttonLayer = [CCNodeColor nodeWithColor:[CCColor colorWithWhite:1.f alpha:0] width:100 height:30];
    [buttonLayer setPositionType:CCPositionTypeNormalized];
    [buttonLayer setPosition:ccp(0.8f, 0.9f)];
    
    [self addChild:buttonLayer z: 2];
    [self addChild:backgrounds z: 1];
    //[backgrounds setUserInteractionEnabled:YES]; // 设置支持触屏
    //[backgrounds setMultipleTouchEnabled:YES]; // 设置支持多点触屏
    
    backgroundImg = [CCTexture textureWithFile:@"backGround.png"];
    tempTran = CGPointMake(0, 0);
    oldTranCenter = CGPointMake(0.5f, 0.5f);
    [self setUserInteractionEnabled:YES];
    [self setMultipleTouchEnabled:YES];
    isMoved = NO;
    isLocked = NO;
    
    //[self schedule:@selector(updateAction:) interval:1.f];
    
    [self initScene];
    
    return self;
}

-(void)initScene {
    // Scene的Positon设置是根据像素而非比例设置,sprite的是根据比例设置
    background = [CCSprite spriteWithTexture: backgroundImg];
    [background setPosition:ccp(0.5f, 0.5f)];
    [background setPositionType:CCPositionTypeNormalized];
    [background setScale:0.5];
    [backgrounds addChild:background z:5];
    
    CCTexture *panda = [CCTexture textureWithFile:@"panda.png"];
    pandaTrain = [CCSprite spriteWithTexture:panda];
    [pandaTrain setPosition:ccp(0.3f, 0.5f)];
    [pandaTrain setPositionType:CCPositionTypeNormalized];
    [backgrounds addChild:pandaTrain z:9];
    
    buttonLock = [CCSprite spriteWithImageNamed:@"button.png"];
    [buttonLock setPositionType:CCPositionTypeNormalized];
    [buttonLock setPosition:ccp(0.5f, 0.5f)];
    [buttonLayer addChild:buttonLock];
    CCAction *moveBy = [CCActionMoveBy actionWithDuration:10.0f position:ccp(0.5f, 0)];
    [pandaTrain runAction:moveBy];
    
    oldPoint = pandaTrain.position;
    [backgrounds setAnchorPoint:CGPointZero];
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    NSArray *touches = [[event allTouches] allValues];
    
    if (touches.count == 2) {
        CCTouch *touch1 = [touches objectAtIndex:0];
        CCTouch *touch2 = [touches objectAtIndex:1];
        CGPoint touchPoint1 = [touch1 locationInNode:backgrounds];
        CGPoint touchPoint2 = [touch2 locationInNode:backgrounds];
        
        CCLOG(@"Point1: %@ Point2: %@", NSStringFromCGPoint(touchPoint1), NSStringFromCGPoint(touchPoint2));
    }
    else {
        CGPoint touchPoint = [touch locationInNode:backgrounds];
        CGPoint touchPointInScene = [touch locationInNode:buttonLayer];
        [self buttonIsSelected:touchPointInScene];
        CCLOG(@"onlyPoint1: %@", NSStringFromCGPoint(touchPointInScene));
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
        CGPoint touchPoint1 = [touch1 locationInNode:backgrounds];
        CGPoint touchPoint2 = [touch2 locationInNode:backgrounds];
        oldTouchPoint1 = [[CCDirector sharedDirector] convertToGL:oldTouchPoint1];
        oldTouchPoint1 = [backgrounds convertToNodeSpace:oldTouchPoint1];
        oldTouchPoint2 = [[CCDirector sharedDirector] convertToGL:oldTouchPoint2];
        oldTouchPoint2 = [backgrounds convertToNodeSpace:oldTouchPoint2];
        
        CGPoint newTranCenter = ccpMult(ccpAdd(oldTouchPoint1, oldTouchPoint2), 0.5);
        //CCLOG(@"Center: %@", NSStringFromCGPoint(newTranCenter));
        
        CGFloat oldTranLoc = ccpDistance(oldTouchPoint1, oldTouchPoint2); // 两个Point变幻之前的距离
        CGFloat tranLoc = ccpDistance(touchPoint1, touchPoint2); // 两个Point变幻之后的距离
        
        //CCLOG(@"oldDistance: %f newDistance: %f", oldTranLoc, tranLoc);
        
        double tempScale = [backgrounds scale] * tranLoc / oldTranLoc;
        // tempScale 约束到1 －> 2之间
        tempScale = tempScale <= 1 ? 1 : tempScale;
        tempScale = tempScale >= 5 ? 5 : tempScale;
        
        CGPoint oldAnchorPoint = [backgrounds anchorPoint];
        oldAnchorPoint.x *= backgrounds.contentSize.width;
        oldAnchorPoint.y *= backgrounds.contentSize.height;
        CGPoint tranFromAnchor = ccpSub(newTranCenter, oldAnchorPoint);
        CGPoint newPosition = [backgrounds position];
        double scale = [backgrounds scale];
        newPosition.x += tranFromAnchor.x * scale;
        newPosition.y += tranFromAnchor.y * scale;
        
        CGPoint newAnchorPoint = CGPointMake(newTranCenter.x/backgrounds.contentSize.width, newTranCenter.y/backgrounds.contentSize.height);
        //CCLOG(@"AP: %f NP: %f", (1.0 - newAnchorPoint.y) * tempScale * self.contentSize.height, self.contentSize.height - newPosition.y);
        if (newAnchorPoint.y * tempScale * backgrounds.contentSize.height < newPosition.y) {
            newAnchorPoint.y = 0.0;
            newPosition.y = 0.0;
            CCLOG(@"Bottom get!");
        }
        if ((1.0 - newAnchorPoint.y) * tempScale * backgrounds.contentSize.height < (backgrounds.contentSize.height - newPosition.y)) {
            newAnchorPoint.y = 1.0;
            newPosition.y = backgrounds.contentSize.height;
            CCLOG(@"Top get!");
        }
        if (newAnchorPoint.x * tempScale * backgrounds.contentSize.width < newPosition.x) {
            newAnchorPoint.x = 0.0;
            newPosition.x = 0.0;
            CCLOG(@"left get!");
        }
        if ((1.0 - newAnchorPoint.x) * tempScale * backgrounds.contentSize.width < (backgrounds.contentSize.width - newPosition.x)) {
            newAnchorPoint.x = 1.0;
            newPosition.x = backgrounds.contentSize.width;
            CCLOG(@"right get!");
        }
        
        // 重置锚点与位置，scene对应屏幕
        [backgrounds setAnchorPoint:newAnchorPoint];
        [backgrounds setPosition:newPosition];
        //CCLOG(@"NAP: %@, NP: %@", NSStringFromCGPoint(newAnchorPoint), NSStringFromCGPoint(newPosition));
        
        [backgrounds setScale:tempScale];
        CCLOG(@"scale: %f", [backgrounds scale]);

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
        CGPoint touchPoint = [touch locationInNode:backgrounds];
        CGPoint oldTouchPoint = [touch previousLocationInView:touch.view];
        oldTouchPoint = [[CCDirector sharedDirector] convertToGL:oldTouchPoint];
        oldTouchPoint = [backgrounds convertToNodeSpace:oldTouchPoint];
        
        CGFloat scale = [backgrounds scale];
        CGPoint nowPos = [backgrounds position];
        CGPoint tran = ccpSub(touchPoint, oldTouchPoint); // 识别移动距离，仅通过一个点
        tran.x *= scale;
        tran.y *= scale;
        
        CCLOG(@"oldPosition: %@", NSStringFromCGPoint(nowPos));
        CGPoint anchorPoint = [backgrounds anchorPoint];
        CGPoint newPosition = ccpAdd(tran, nowPos);
        
        newPosition.y = (anchorPoint.y * scale * backgrounds.contentSize.height < newPosition.y) || (1.0 - anchorPoint.y) * scale * backgrounds.contentSize.height < (backgrounds.contentSize.height - newPosition.y) ? nowPos.y : newPosition.y;
        newPosition.x = (anchorPoint.x * scale * backgrounds.contentSize.width < newPosition.x) || (1.0 - anchorPoint.x) * scale * backgrounds.contentSize.width < (backgrounds.contentSize.width - newPosition.x) ? nowPos.x : newPosition.x;
        
        [backgrounds setPosition:newPosition];
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

-(void)buttonIsSelected:(CGPoint )pos {
    CGPoint posSet = pos;
    if (CGRectContainsPoint(buttonLock.boundingBox, posSet)) {
        isLocked = isLocked == YES ? NO : YES;
        CCLOG(@"Locked! %@", isLocked?@"YES":@"NO");
    }
    
    //id actionFollow = [CCActionFollow actionWithTarget:pandaTrain];
    if (isLocked) {
        // 移动到中心坐标问题等待解决
        CGFloat scale = [backgrounds scale];
        
        CGPoint nowPos = [backgrounds position];
        CGPoint anPos = [backgrounds anchorPoint];
        CGPoint centerPos = CGPointMake(0.5f, 0.5f);
        centerPos.x *= backgrounds.contentSize.width;
        centerPos.y *= backgrounds.contentSize.height;
        anPos.x *= backgrounds.contentSize.width;
        anPos.y *= backgrounds.contentSize.height;
        CGPoint a = ccpAdd(anPos, ccpSub(centerPos, nowPos));
        a.x /= backgrounds.contentSize.width;
        a.y /= backgrounds.contentSize.height;
        
        CGPoint tran = ccpSub(a, pandaTrain.position);
        tran.x *= scale * backgrounds.contentSize.width;
        tran.y *= scale * backgrounds.contentSize.height;
        
        CGPoint newPosition = ccpAdd(tran, nowPos);
        
        [backgrounds setPosition:newPosition];
        oldPoint = pandaTrain.position;
        [self schedule:@selector(updateLocked:) interval:0.01f];
    }
    else {
        [self unschedule:@selector(updateLocked:)];
    }
}

-(void)updateLocked:(CCTime)delta {
    CGFloat scale = [backgrounds scale];
    CGPoint nowPos = [backgrounds position];
    CGPoint tran = ccpSub(pandaTrain.position, oldPoint);
    tran.x *= - scale * backgrounds.contentSize.width;
    tran.y *= - scale * backgrounds.contentSize.height;
    
    // CCLOG(@"tran: %@", NSStringFromCGPoint(tran));
    CGPoint newPosition = ccpAdd(tran, nowPos);
    
    [backgrounds setPosition:newPosition];
    // CCLOG(@"update!");
    oldPoint = pandaTrain.position;
}

-(void)windowLocked:(CCNode *)node {

}
// -----------------------------------------------------------------

@end





