//
//  EnterLittleMap.m
//  MMXTH
//
//  Created by 修海锟 on 2017/3/10.
//  Copyright © 2017年 xc. All rights reserved.
//

#import "EnterLittleMap.h"
#import "TestTrackScene.h"
#import "FirstScene.h"

@implementation EnterLittleMap

@synthesize background;
@synthesize buttonLayer;
@synthesize chinaDic;

#define MAX_SCALE 5 // 最大放大参数

// 后期省市坐标需用plist来储存
#define GD_X  0.65f // 广东X坐标
#define GD_Y 0.15f // 广东Y坐标

+ (EnterLittleMap *)scene {
    return [[self alloc] init];
}

- (id)init {
    if ((self = [super init])) {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    }
    
    [self setUserInteractionEnabled:YES];
    [self setMultipleTouchEnabled:YES];
    
    // 从Scene处理到Node的处理的跨越
    background = [CCNodeColor nodeWithColor:[CCColor blackColor]];

    // 使主Scene层在最下方
    [self addChild:background z: 1];
    
    // Back按钮
    CCButton *backButton = [CCButton buttonWithTitle:@" " spriteFrame:[CCSpriteFrame frameWithImageNamed:@"return.png"]];
    [backButton setTarget:self selector:@selector(onBackButtonClicked:)];
    [backButton setPositionType:CCPositionTypeNormalized];
    [backButton setScale:0.1*self.contentSize.width/backButton.contentSize.width];
    [backButton setPosition:ccp(0.1f, 0.85f)];
    [self addChild:backButton z:9];
    
    [self initScene];
    return self;
}

- (void)initScene {
    CCSprite *chinaMap = [CCSprite spriteWithImageNamed:@"MapResources/中国.png"];
    [chinaMap setPositionType:CCPositionTypeNormalized];
    [chinaMap setPosition:CGPointMake(0.5f, 0.5f)];
    [chinaMap setScale:(self.contentSize.height / chinaMap.contentSize.height)];
    
    [background addChild:chinaMap z: 2];
    
    _dataManager = [DataManager sharedManager];
    chinaDic = [_dataManager bundleDicWithName:@"ChinaMap"];
    //NSArray *chinaArr = chinaDic.allKeys;
    
    for (NSString *key in chinaDic.allKeys ) {
        CCSprite *oneMap = [CCSprite spriteWithImageNamed:[@"MapResources/" stringByAppendingFormat:@"%@.png", key]];
        //NSArray *thisArr = [chinaDic objectForKey:key];
        [oneMap setPositionType:CCPositionTypeNormalized];
        [oneMap setPosition:CGPointMake(0.5f, 0.5f)];
        
        [chinaMap addChild:oneMap z:1];
    }
    
    // GuangDong
//    guangDongMap = [CCSprite spriteWithImageNamed:@"stage_1/5Stage_1_GuangDong.png"];
//    [guangDongMap setPositionType:CCPositionTypeNormalized];
//    [guangDongMap setPosition:CGPointMake(0.5f, 0.5f)];
//    [guangDongMap setScale:(self.contentSize.height / guangDongMap.contentSize.height)];
    
//    guangDongMap = [CCSprite spriteWithImageNamed:@"广东.png"];
//    [guangDongMap setPosition:CGPointMake(0.5 * chinaMap.contentSize.width + 194, 0.5 * chinaMap.contentSize.height - 259)];
//    
//    [chinaMap addChild:guangDongMap z: 1];
    
//    guangDongBtn = [CCButton buttonWithTitle:@"广州" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]];
//    [guangDongBtn setScale:0.1f];
//    [guangDongBtn setColor:[CCColor blackColor]];
//    [guangDongBtn setBackgroundColor:[CCColor grayColor] forState:CCControlStateNormal];
//    [guangDongBtn setBackgroundColor:[CCColor redColor] forState: CCControlStateHighlighted];
//    [guangDongBtn setPositionType:CCPositionTypeNormalized];
//    [guangDongBtn setPosition:ccp(GD_X, GD_Y)];
//    [guangDongBtn setTarget:self selector:@selector(onMapButtonClicked:)];
//    [guangDongBtn setEnabled:NO];
    
    //[background addChild:guangDongMap z: 3];
//    [background addChild:guangDongBtn z: 4];
    
    // 测试;假设为广东
    [self loadMap];
//    [guangDongBtn setEnabled:YES];
}


-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    NSArray *touches = [[event allTouches] allValues]; // 获取所有的触点（用于多点触控）
    CCLOG(@"touchBegan--->%lu", (unsigned long)touches.count);
    
    // 触点为2时，触发响应操作（此处的代码没有用，仅供调试方便）
    if (touches.count == 2) {
        CCTouch *touch1 = [touches objectAtIndex:0];
        CCTouch *touch2 = [touches objectAtIndex:1];
        CGPoint touchPoint1 = [touch1 locationInNode:background]; // 寻找触点相应背景的位置，而非界面的！
        CGPoint touchPoint2 = [touch2 locationInNode:background];
        
        CCLOG(@"Point1: %@ Point2: %@", NSStringFromCGPoint(touchPoint1), NSStringFromCGPoint(touchPoint2));
    }
    else {
        CGPoint touchPoint = [touch locationInNode:background];
        CGPoint touchPointInScene = [touch locationInNode:buttonLayer];
        
        
//        // 测试;假设为广东
//        [self loadMap];
//        [guangDongBtn setEnabled:YES];
        
        CCLOG(@"PointForBtnLayer: %@\nPointForBgLayer: %@", NSStringFromCGPoint(touchPointInScene), NSStringFromCGPoint(touchPoint));
    }
}

-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    NSArray *touches = [[event allTouches] allValues];
    CCLOG(@"touchMoved--->%lu", (unsigned long)touches.count);
    
    // 两个触控点，触发操作
    if (touches.count == 2) {
            CCTouch *touch1 = [touches objectAtIndex:0];
            CCTouch *touch2 = [touches objectAtIndex:1];
            CGPoint oldTouchPoint1 = [touch1 previousLocationInView:touch1.view]; // 上一次的位置
            CGPoint oldTouchPoint2 = [touch2 previousLocationInView:touch2.view];
            CGPoint touchPoint1 = [touch1 locationInNode:background]; // 现在的位置
            CGPoint touchPoint2 = [touch2 locationInNode:background];
            
            // 改变坐标系
            oldTouchPoint1 = [[CCDirector sharedDirector] convertToGL:oldTouchPoint1];
            oldTouchPoint1 = [background convertToNodeSpace:oldTouchPoint1];
            oldTouchPoint2 = [[CCDirector sharedDirector] convertToGL:oldTouchPoint2];
            oldTouchPoint2 = [background convertToNodeSpace:oldTouchPoint2];
            
            // 通过两个触控点计算二者中点作为新的中心（缩放放大中心）
            CGPoint newTranCenter = ccpMult(ccpAdd(oldTouchPoint1, oldTouchPoint2), 0.5);
            
            CGFloat oldTranLoc = ccpDistance(oldTouchPoint1, oldTouchPoint2); // 两个Point变幻之前的距离
            CGFloat tranLoc = ccpDistance(touchPoint1, touchPoint2); // 两个Point变幻之后的距离
            
            double tempScale = [background scale] * tranLoc / oldTranLoc; // 计算最新的Scale
            
            // tempScale 约束到1 －> Max之间
            tempScale = tempScale <= 1 ? 1 : tempScale;
            tempScale = tempScale >= MAX_SCALE ? MAX_SCALE : tempScale;
            
            CGPoint oldAnchorPoint = [background anchorPoint]; // 获取旧锚点
            
            // 锚点坐标格式转换成CGFloat
            oldAnchorPoint.x *= background.contentSize.width;
            oldAnchorPoint.y *= background.contentSize.height;
            
            // 通过计算新的中心与旧的锚点的距离
            CGPoint tranFromAnchor = ccpSub(newTranCenter, oldAnchorPoint);
            
            CGPoint newPosition = [background position]; // 获取当前Scene层位置
            double scale = [background scale]; // 获取当前Scene 层Scale
            
            // 计算最新的Scene层位置
            newPosition.x += tranFromAnchor.x * scale;
            newPosition.y += tranFromAnchor.y * scale;
            
            // 计算最新的锚点位置
            CGPoint newAnchorPoint = CGPointMake(newTranCenter.x/background.contentSize.width, newTranCenter.y/background.contentSize.height);
            
            // 为锚点及位置添加约束，禁止背景图露出边界，如果出界，则重置到边界处
            if (newAnchorPoint.y * tempScale * background.contentSize.height < newPosition.y) {
                newAnchorPoint.y = 0.0;
                newPosition.y = 0.0;
                CCLOG(@"Bottom get!");
            }
            if ((1.0 - newAnchorPoint.y) * tempScale * background.contentSize.height < (background.contentSize.height - newPosition.y)) {
                newAnchorPoint.y = 1.0;
                newPosition.y = background.contentSize.height;
                CCLOG(@"Top get!");
            }
            if (newAnchorPoint.x * tempScale * background.contentSize.width < newPosition.x) {
                newAnchorPoint.x = 0.0;
                newPosition.x = 0.0;
                CCLOG(@"left get!");
            }
            if ((1.0 - newAnchorPoint.x) * tempScale * background.contentSize.width < (background.contentSize.width - newPosition.x)) {
                newAnchorPoint.x = 1.0;
                newPosition.x = background.contentSize.width;
                CCLOG(@"right get!");
            }
            
            // 重置锚点与位置，scene对应屏幕
            [background setAnchorPoint:newAnchorPoint];
            [background setPosition:newPosition];
            
            // 记录并更新新的Scale
            [background setScale:tempScale];
            CCLOG(@"scale: %f", [background scale]);
    }
    else {
            // 仅操作Scene层的位置实现视角移动
            CGPoint touchPoint = [touch locationInNode:background];
            CGPoint oldTouchPoint = [touch previousLocationInView:touch.view];
            oldTouchPoint = [[CCDirector sharedDirector] convertToGL:oldTouchPoint];
            oldTouchPoint = [background convertToNodeSpace:oldTouchPoint];
            
            CGFloat scale = [background scale];
            CGPoint nowPos = [background position];
            CGPoint tran = ccpSub(touchPoint, oldTouchPoint); // 识别移动距离，仅通过一个点
            tran.x *= scale; // 通过计算移动的距离，要与Scale一同计算
            tran.y *= scale;
            
            CCLOG(@"oldPosition: %@", NSStringFromCGPoint(nowPos));
            
            CGPoint anchorPoint = [background anchorPoint];
            CGPoint newPosition = ccpAdd(tran, nowPos);
            
            // 约束位置
            newPosition.y = (anchorPoint.y * scale * background.contentSize.height < newPosition.y) || (1.0 - anchorPoint.y) * scale * background.contentSize.height < (background.contentSize.height - newPosition.y) ? nowPos.y : newPosition.y;
            newPosition.x = (anchorPoint.x * scale * background.contentSize.width < newPosition.x) || (1.0 - anchorPoint.x) * scale * background.contentSize.width < (background.contentSize.width - newPosition.x) ? nowPos.x : newPosition.x;
            
            [background setPosition:newPosition];
            CCLOG(@"newPosition: %@", NSStringFromCGPoint(newPosition));
            CCLOG(@"OnlyTran: %@", NSStringFromCGPoint(tran));
    }
}

-(void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CCLOG(@"touchCancelled!");
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    NSArray *touches = [[event allTouches] allValues];
    
    CCLOG(@"touchEnded--->%lu", (unsigned long)touches.count);
}

// 入场特效
- (void)loadingAction:(CCTime)delta {
    CGFloat scale = [background scale];
    [background setScale:(scale + 4 * 0.0025f)];
}

// 点击地图入场
- (void)loadMap {
    CGPoint newTranCenter = CGPointMake(background.contentSize.width / 2, background.contentSize.height / 2);
    CGPoint oldAnchorPoint = [background anchorPoint]; // 获取旧锚点
    
    // 锚点坐标格式转换成CGFloat
    oldAnchorPoint.x *= background.contentSize.width;
    oldAnchorPoint.y *= background.contentSize.height;
    
    // 通过计算新的中心与旧的锚点的距离
    CGPoint tranFromAnchor = ccpSub(newTranCenter, oldAnchorPoint);
    
    CGPoint newPosition = [background position]; // 获取当前Scene层位置
    CGFloat scale = [background scale];
    
    // 计算最新的Scene层位置
    newPosition.x += tranFromAnchor.x * scale;
    newPosition.y += tranFromAnchor.y * scale;
    
    // 计算最新的锚点位置
    CGPoint newAnchorPoint = CGPointMake(newTranCenter.x/background.contentSize.width, newTranCenter.y/background.contentSize.height);
    
    // 重置锚点与位置，scene对应屏幕
    [background setAnchorPoint:newAnchorPoint];
    [background setPosition:newPosition];
    
    //[self schedule:@selector(loadingAction:) interval:0.01f repeat:400 delay:0];
    [background setAnchorPoint:CGPointMake(0.65f, 0.15f)];
    [background setScale:5];
    //[background setPosition: CGPointMake(0.35f*background.contentSize.width, 0.85f*background.contentSize.height)];
//    CCAction* moveBy = [CCActionMoveBy actionWithDuration:0 position:CGPointMake(-0.15f*MAX_SCALE*background.contentSize.width, 0.35f*MAX_SCALE*background.contentSize.height)];
//    [background runAction:moveBy];
}

// 此函数用于加载小界面
- (void)onMapButtonClicked:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[TestTrackScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionInvalid duration:0.5f]];
}

// 此函数用来确认地图块被选择，并进行相应操作
- (void)spriteSelectedOrNot:(CGPoint)pos Map: (CCSprite *)mapSprite {
    CGPoint posSelected = pos;
    if (CGRectContainsPoint(mapSprite.boundingBox, posSelected)) {
        [self loadMap];
    }
}


// back按钮回调，返回firstScene
- (void)onBackButtonClicked:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[FirstScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
}

@end
