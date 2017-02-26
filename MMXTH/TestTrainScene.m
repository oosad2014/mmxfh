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
#import "PauseScene.h"
#import "SecondScene.h"

#define MAX_SCALE 5 // 最大放大参数
#define UPDATE_DELTA  0.01f // 更新频率
#define LIGHT_ADJUST 0.02 // 微调参数

// -----------------------------------------------------------------

@implementation TestTrainScene

@synthesize background;
@synthesize backgroundImg;
@synthesize isLocked;
@synthesize backgrounds;
@synthesize buttonLayer;
@synthesize pauseLayer;
@synthesize buttonLock;
@synthesize trainHead;
@synthesize trainGoods;
@synthesize track;

@synthesize pauseButton;
@synthesize pauseTexture;
// -----------------------------------------------------------------

static CGPoint oldPoint; // 用于刷新视角跟踪，记录上一次刷新的位置

+ (TestTrainScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    if ((self = [super init])) {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    }
    
    // 从Scene处理到Node的处理的跨越
    backgrounds = [CCNodeColor nodeWithColor:[CCColor blackColor]];
    
    pauseLayer =  [CCNodeColor nodeWithColor:[CCColor colorWithWhite:1.f alpha:0] width:30 height:30];
    [pauseLayer setPositionType:CCPositionTypeNormalized];
    [pauseLayer setPosition:ccp(0.9f, 0.05f)];
    
    buttonLayer = [CCNodeColor nodeWithColor:[CCColor colorWithWhite:1.f alpha:0] width:100 height:30];
    [buttonLayer setPositionType:CCPositionTypeNormalized];
    [buttonLayer setPosition:ccp(0.8f, 0.9f)];
    
    // 使主Scene层在最下方
    [self addChild:buttonLayer z: 2];
    [self addChild:pauseLayer z: 2];
    [self addChild:backgrounds z: 1];
    
    backgroundImg = [CCTexture textureWithFile:@"backGround.png"];
    [self setUserInteractionEnabled:YES];
    [self setMultipleTouchEnabled:YES];
    isLocked = NO; // 初始状态不锁定视角
    
    [self initScene];
    
    return self;
}

-(void)initScene {
    // Scene的Positon设置是根据像素而非比例设置,sprite的是根据比例设置
    background = [CCSprite spriteWithTexture: backgroundImg]; // 通过纹理建立背景
    [background setPosition:ccp(0.5f, 0.5f)];
    [background setPositionType:CCPositionTypeNormalized];
    [background setScale:backgrounds.contentSize.width / background.contentSize.width];
    [backgrounds addChild:background z:5];
    
    // TrainHead
    trainHead = [[TrainHead alloc] init];
    trainHead = [trainHead createWithExists:[SecondScene getTrainHeadSel]];
    [trainHead setScale:0.1f];
    [trainHead setPosition:ccp(0.25f, 0.25f)];
    [trainHead setPositionType:CCPositionTypeNormalized];
    [backgrounds addChild:trainHead z:9];
    
    // TrainGoods
    trainGoods = [[TrainGoods alloc] init];
    trainGoods = [trainGoods createWithExists:[SecondScene getTrainGoodsSel]];
    [trainGoods setScale:0.1f];
    [trainGoods setPosition:ccp(0.27f, 0.26f)];
    [trainGoods setPositionType:CCPositionTypeNormalized];
    [backgrounds addChild:trainGoods z:9];
    
    // Track
    track = [[Track alloc] init];
    track = [track createWithExists:[SecondScene getTrackSel]];
    [track setScale:0.1f];
    [track setPosition:ccp(0.27f, 0.24f)];
    [track setPositionType:CCPositionTypeNormalized];
    [backgrounds addChild:track z:9];
    
    // LockButton
    buttonLock = [CCSprite spriteWithImageNamed:@"button.png"];
    [buttonLock setPositionType:CCPositionTypeNormalized];
    [buttonLock setPosition:ccp(0.5f, 0.5f)];
    [buttonLayer addChild:buttonLock];
    
    // PauseButton
    pauseButton = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"icon/pause_normal.png"]];
    pauseButton.scale = (self.contentSize.width/pauseButton.contentSize.width)*0.05f;
    pauseButton.positionType = CCPositionTypeNormalized;
    [pauseButton setPosition:ccp(0.93f, 0.93f)];
    [pauseButton setTarget:self selector:@selector(onPauseButtonClicked:)];
    [pauseLayer addChild:pauseButton z:9];
    
    // 此处用于模拟火车循环运动，正式优化时删除
    id moveRight = [CCActionMoveBy actionWithDuration:10.0f position:ccp(0.5f, 0)];
    id moveTop = [CCActionMoveBy actionWithDuration:10.0f position:ccp(0, 0.5f)];
    id moveLeft = [CCActionMoveBy actionWithDuration:10.0f position:ccp(-0.5f, 0)];
    id moveButton = [CCActionMoveBy actionWithDuration:10.0f position:ccp(0, -0.5f)];
    id moveAction = [CCActionSequence actionWithArray:@[moveRight, moveTop, moveLeft, moveButton]];
    id forverAction = [CCActionRepeatForever actionWithAction:moveAction];
    [trainHead runAction:[forverAction copy]];
    [trainGoods runAction:[forverAction copy]];
    [track runAction:[forverAction copy]];
    
    oldPoint = trainHead.position; // 设置刷新的最初的位置（基于火车头刷新）
    [backgrounds setAnchorPoint:CGPointZero]; // 设置背景层锚点为左下角，之后方便操作
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    NSArray *touches = [[event allTouches] allValues]; // 获取所有的触点（用于多点触控）
    CCLOG(@"touchBegan--->%lu", (unsigned long)touches.count);
    
    // 触点为2时，触发响应操作（此处的代码没有用，仅供调试方便）
    if (touches.count == 2) {
        CCTouch *touch1 = [touches objectAtIndex:0];
        CCTouch *touch2 = [touches objectAtIndex:1];
        CGPoint touchPoint1 = [touch1 locationInNode:backgrounds]; // 寻找触点相应背景的位置，而非界面的！
        CGPoint touchPoint2 = [touch2 locationInNode:backgrounds];
        
        CCLOG(@"Point1: %@ Point2: %@", NSStringFromCGPoint(touchPoint1), NSStringFromCGPoint(touchPoint2));
    }
    else {
        CGPoint touchPoint = [touch locationInNode:backgrounds];
        CGPoint touchPointInScene = [touch locationInNode:buttonLayer];
        [self buttonIsSelected:touchPointInScene];
        
        CCLOG(@"PointForBtnLayer: %@\nPointForBgLayer: %@", NSStringFromCGPoint(touchPointInScene), NSStringFromCGPoint(touchPoint));
    }
}

-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    NSArray *touches = [[event allTouches] allValues];
    CCLOG(@"touchMoved--->%lu", (unsigned long)touches.count);
    
    // 两个触控点，触发操作
    if (touches.count == 2) {
        if (!isLocked) {
            // 如果没有锁定
            CCTouch *touch1 = [touches objectAtIndex:0];
            CCTouch *touch2 = [touches objectAtIndex:1];
            CGPoint oldTouchPoint1 = [touch1 previousLocationInView:touch1.view]; // 上一次的位置
            CGPoint oldTouchPoint2 = [touch2 previousLocationInView:touch2.view];
            CGPoint touchPoint1 = [touch1 locationInNode:backgrounds]; // 现在的位置
            CGPoint touchPoint2 = [touch2 locationInNode:backgrounds];
            
            // 改变坐标系
            oldTouchPoint1 = [[CCDirector sharedDirector] convertToGL:oldTouchPoint1];
            oldTouchPoint1 = [backgrounds convertToNodeSpace:oldTouchPoint1];
            oldTouchPoint2 = [[CCDirector sharedDirector] convertToGL:oldTouchPoint2];
            oldTouchPoint2 = [backgrounds convertToNodeSpace:oldTouchPoint2];
            
            // 通过两个触控点计算二者中点作为新的中心（缩放放大中心）
            CGPoint newTranCenter = ccpMult(ccpAdd(oldTouchPoint1, oldTouchPoint2), 0.5);
            
            CGFloat oldTranLoc = ccpDistance(oldTouchPoint1, oldTouchPoint2); // 两个Point变幻之前的距离
            CGFloat tranLoc = ccpDistance(touchPoint1, touchPoint2); // 两个Point变幻之后的距离
            
            double tempScale = [backgrounds scale] * tranLoc / oldTranLoc; // 计算最新的Scale
            
            // tempScale 约束到1 －> Max之间
            tempScale = tempScale <= 1 ? 1 : tempScale;
            tempScale = tempScale >= MAX_SCALE ? MAX_SCALE : tempScale;
            
            CGPoint oldAnchorPoint = [backgrounds anchorPoint]; // 获取旧锚点
            
            // 锚点坐标格式转换成CGFloat
            oldAnchorPoint.x *= backgrounds.contentSize.width;
            oldAnchorPoint.y *= backgrounds.contentSize.height;
            
            // 通过计算新的中心与旧的锚点的距离
            CGPoint tranFromAnchor = ccpSub(newTranCenter, oldAnchorPoint);
            
            CGPoint newPosition = [backgrounds position]; // 获取当前Scene层位置
            double scale = [backgrounds scale]; // 获取当前Scene 层Scale
            
            // 计算最新的Scene层位置
            newPosition.x += tranFromAnchor.x * scale;
            newPosition.y += tranFromAnchor.y * scale;
            
            // 计算最新的锚点位置
            CGPoint newAnchorPoint = CGPointMake(newTranCenter.x/backgrounds.contentSize.width, newTranCenter.y/backgrounds.contentSize.height);
            
            // 为锚点及位置添加约束，禁止背景图露出边界，如果出界，则重置到边界处
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
            
            // 记录并更新新的Scale
            [backgrounds setScale:tempScale];
            CCLOG(@"scale: %f", [backgrounds scale]);
        }
        else {
            // 待实现
        }
    }
    else {
        if (!isLocked) {
            // 仅操作Scene层的位置实现视角移动
            CGPoint touchPoint = [touch locationInNode:backgrounds];
            CGPoint oldTouchPoint = [touch previousLocationInView:touch.view];
            oldTouchPoint = [[CCDirector sharedDirector] convertToGL:oldTouchPoint];
            oldTouchPoint = [backgrounds convertToNodeSpace:oldTouchPoint];
            
            CGFloat scale = [backgrounds scale];
            CGPoint nowPos = [backgrounds position];
            CGPoint tran = ccpSub(touchPoint, oldTouchPoint); // 识别移动距离，仅通过一个点
            tran.x *= scale; // 通过计算移动的距离，要与Scale一同计算
            tran.y *= scale;
            
            CCLOG(@"oldPosition: %@", NSStringFromCGPoint(nowPos));
            
            CGPoint anchorPoint = [backgrounds anchorPoint];
            CGPoint newPosition = ccpAdd(tran, nowPos);
            
            // 约束位置
            newPosition.y = (anchorPoint.y * scale * backgrounds.contentSize.height < newPosition.y) || (1.0 - anchorPoint.y) * scale * backgrounds.contentSize.height < (backgrounds.contentSize.height - newPosition.y) ? nowPos.y : newPosition.y;
            newPosition.x = (anchorPoint.x * scale * backgrounds.contentSize.width < newPosition.x) || (1.0 - anchorPoint.x) * scale * backgrounds.contentSize.width < (backgrounds.contentSize.width - newPosition.x) ? nowPos.x : newPosition.x;
            
            [backgrounds setPosition:newPosition];
            CCLOG(@"newPosition: %@", NSStringFromCGPoint(newPosition));
            CCLOG(@"OnlyTran: %@", NSStringFromCGPoint(tran));
        }
    }
}

-(void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CCLOG(@"touchCancelled!");
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    NSArray *touches = [[event allTouches] allValues];
    
    CCLOG(@"touchEnded--->%lu", (unsigned long)touches.count);
}

// 锁定按钮触发回调函数
-(void)buttonIsSelected:(CGPoint )pos {
    CGPoint posSet = pos;
    if (CGRectContainsPoint(buttonLock.boundingBox, posSet)) {
        isLocked = isLocked == YES ? NO : YES; // 改变锁定状态
        CCLOG(@"Locked! %@", isLocked?@"YES":@"NO");
    }
    
    if (isLocked) {
        // 锁定时，绑定Schedule函数
        CGFloat scale = [backgrounds scale];
        
        CGPoint nowPos = [backgrounds position];
        CGPoint anPos = [backgrounds anchorPoint];
        CGPoint centerPos = CGPointMake(0.5f, 0.5f); // 设置当前的视角中心
        
        nowPos.x /= backgrounds.contentSize.width;
        nowPos.y /= backgrounds.contentSize.height;
        
        CGPoint temp = ccpSub(centerPos, nowPos); // 计算需要移动的距离
        temp.x /= scale;
        temp.y /= scale;
        CGPoint a = ccpAdd(anPos, temp); // 计算最新的锚点
        
        CGPoint tran = ccpSub(a, trainHead.position); // 最新锚点与火车头当前位置距离
        tran.x *= scale * backgrounds.contentSize.width;
        tran.y *= scale * backgrounds.contentSize.height;
        
        id moveTo = [CCActionMoveBy actionWithDuration:0.5f position:tran];
        [backgrounds runAction:moveTo];
        
        oldPoint = trainHead.position; // 记录当前火车头位置用于下一次更新
        
        [self schedule:@selector(updateLocked:) interval:UPDATE_DELTA]; // 每秒更新100次
    }
    else {
        [self unschedule:@selector(updateLocked:)]; // 如果解除锁定，则解除更新
    }
}

// 中心视角更新函数
-(void)updateLocked:(CCTime)delta {
    // 通过模仿手指不断滑动界面实现跟踪视角
    CGFloat scale = [backgrounds scale];
    CGPoint nowPos = [backgrounds position];
    CGPoint tran = ccpSub(trainHead.position, oldPoint);
    tran.x *= - scale * backgrounds.contentSize.width;
    tran.y *= - scale * backgrounds.contentSize.height;
    
    CGPoint newPosition = ccpAdd(tran, nowPos); // 计算最新的位置
    
    [backgrounds setPosition:newPosition];
    oldPoint = trainHead.position;
}

-(void)onPauseButtonClicked:(id)sender {
    // 此处将整个页面作为快照保存，作为暂停的背景
    pauseTexture = [CCRenderTexture renderTextureWithWidth:self.contentSize.width height:self.contentSize.height];
    
    // 相关操作（记住就好）
    [pauseTexture begin];
    [self visit];
    [pauseTexture end];
    
    // 加载暂停界面
    [[CCDirector sharedDirector] pushScene:[[PauseScene scene] initWithParameter:pauseTexture] withTransition: [CCTransition transitionPushWithDirection:CCTransitionDirectionInvalid duration:1.0f]];
}

// -----------------------------------------------------------------

@end





