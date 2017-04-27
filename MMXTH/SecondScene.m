//
//  SecondScene.m
//
//  Created by : mac
//  Project    : MMXTH
//  Date       : 16/9/14
//
//  Copyright (c) 2016年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "SecondScene.h"
#import "EnterLittleMap.h"
#import "FirstScene.h"
#import "Train.h"
#import "TrainHead.h"

// -----------------------------------------------------------------

@implementation SecondScene

@synthesize isMoved;
@synthesize spriteSelected;
@synthesize beganPoint;
@synthesize sceneHeadNow;
@synthesize viewSize;
@synthesize boxHead;
@synthesize trainHeadArray;

// -----------------------------------------------------------------

+ (SecondScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    if ((self = [super init])) {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    }
    
    self.isMoved = NO; //默认为没有去触屏移动
    self.viewSize = [CCDirector sharedDirector].viewSize; // 获取当前界面的大小
    self.userInteractionEnabled = YES; // 注册触屏事件
    
    _dataManager = [DataManager sharedManager]; // 获取单例
    
    // 定义颜色层节点，用于保存scene页面和触发触屏
//    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:27.0f/255.0f green:185.0f/255.0f blue:239.0f/255.0f alpha:1.0f]];
//    [self addChild:background];
    
    sceneHeadNow = 1; // 默认为第一页
    
    spriteSelected = NO; // 默认没有东西选中
    
    // Head
    selTrainHead = [[TrainHead alloc] init]; // 为选中火车头分配空间
    newTrainHead = [[TrainHead alloc] init]; // 为拖动产生的火车头分配空间
    trainHead = [[TrainHead alloc] init]; // 初始化火车头
    trainHeadArray = [NSMutableArray arrayWithCapacity:0]; // 初始化火车头数组
    NSInteger headCount = [[trainHead trainArray] count]; // 获取当前火车头数组大小
    
    // 为火车头浏览页面加载所有的火车头种类，分配位置
    for (int i=1; i<=headCount; i++) {
        TrainHead *head =  [[TrainHead alloc] init];
        [TrainHead setCount:i-1];
        switch (i%3) {
            case 1:
                head = [head create:(i/3 + 0.25f) ySet:0.28f];
                break;
            case 2:
                head = [head create:(i/3 + 0.5f) ySet:0.28f];
                break;
            case 0:
                head = [head create:(i/3 - 1 + 0.75f) ySet:0.28f];
                break;
        }
        [head setScale:(self.contentSize.width * 0.2f/head.contentSize.width)];
        [trainHeadArray addObject:head];
    }
    
    //[self setTrainHeadToFile:[trainHeadArray objectAtIndex:0]]; // 预设定

    // 加载额外初始化元素
    [self initScene];
    return self;
}

-(void)initScene {
    // Background
    // You can change the .png files to change the background
    // 背景
    CCSprite *background = [CCSprite spriteWithImageNamed:@"组装界面.png"];
    [background setPositionType:CCPositionTypeNormalized];
    [background setPosition:CGPointZero];
    [background setAnchorPoint:CGPointZero];
    [background setScale: self.contentSize.width/background.contentSize.width];
    [self addChild:background];
    
    // Back按钮
    CCButton *backButton = [CCButton buttonWithTitle:@" " spriteFrame:[CCSpriteFrame frameWithImageNamed:@"return.png"]];
    [backButton setTarget:self selector:@selector(onBackButtonClicked:)];
    [backButton setPositionType:CCPositionTypeNormalized];
    [backButton setScale:0.3];
    [backButton setPosition:ccp(0.1f, 0.85f)];
    [self addChild:backButton z:9];
    
    // 火车头终点贴图
    boxHead = [CCSprite spriteWithImageNamed:@"face.jpg"];
    self.boxHead.positionType = CCPositionTypeNormalized;
    [self.boxHead setPosition:ccp(0.5f, 0.65f)];
    [self.boxHead setScale:(self.contentSize.width*0.4/self.boxHead.contentSize.width)];
    [self addChild:self.boxHead z:8];
    boxHead.opacity = 0;
    
    NSDictionary *trainNowDic = [_dataManager documentDicWithName:@"TrainNow"];
    selTrainHead = [TrainHead spriteWithImageNamed:[trainNowDic objectForKey:@"TrainSelected"]];
    selTrainHead.positionType = CCPositionTypeNormalized;
    [selTrainHead setPosition: ccp(0.5f, 0.65f)];
    [selTrainHead setScale:(self.contentSize.width*0.4/selTrainHead.contentSize.width)];
    [self addChild:selTrainHead z:8];
    
    [self insideTrainHeadScene];
}

#pragma mark--------------------------------------------------------------
#pragma mark - Select Scene
#pragma mark--------------------------------------------------------------

// back按钮回调，返回firstScene
- (void)onBackButtonClicked:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[FirstScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
}

// play按钮回调，进入TestTrainScene界面
//- (void)onPlayButtonClicked:(id)sender {
//    [[CCDirector sharedDirector] replaceScene:[EnterLittleMap scene]
//                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
//}

// 添加火车头浏览界面
-(void)insideTrainHeadScene {
    // 加载所有的火车头种类控件
    for (TrainHead *head in trainHeadArray) {
        [self addChild:head z:9];
    }
}

// 移除火车头浏览界面
-(void)removeTrainHeadScene {
    // 移除浏览界面里的所有火车头种类以达到类似移除界面的效果
    for (TrainHead *head in trainHeadArray) {
        [head removeFromParent];
    }
}

#pragma mark--------------------------------------------------------------
#pragma mark - Touch Handler
#pragma mark--------------------------------------------------------------
// 触屏开始
-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    self.isMoved = YES;
    // 获取点击开始坐标
    beganPoint = [touch locationInNode:self];
    
    // 判断开始坐标是否选中图形
    [self spriteSelectedOrNot:beganPoint];
}

// 触屏运动
-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self]; // 获取当前坐标
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view]; // 获取上一次点的坐标（基于View）
    
    // 通过View坐标去转换成Node坐标
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    // 跟随手指移动
    CGPoint tranLoc = ccpSub(touchLocation, oldTouchLocation);
    tranLoc.x = tranLoc.x / self.viewSize.width; // 转换成CGFloat格式坐标
    tranLoc.y = tranLoc.y / self.viewSize.height;
    
    // 添加跟随运动
    CCAction *action = [CCActionMoveBy actionWithDuration:0.0f position:tranLoc];
    [newTrainHead runAction:[action copy]];
}

// 触屏结束
-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    // 获取触屏结束点坐标
    CGPoint endPoint = [touch locationInNode:self];
    
    // 如果是Move状态，则判断是否拖拉到终点
    if (self.isMoved) {
        CGPoint tranLoc = ccpSub(endPoint, self.beganPoint); // 计算起点终点坐标
        BOOL getOfMove = NO; // 用于判断是到达终点，还是切浏览页面
        
        // 一系列动作特效，到达终点，缩小，取消，触发替换函数
        CCAction *moveEnd = [CCActionMoveTo actionWithDuration:0 position:self.boxHead.position];
        CCAction *little = [CCActionScaleBy actionWithDuration:0 scale:1.5f];
        CCAction *remove = [CCActionRemove action];
        CCAction *onSel = [CCActionCallFunc actionWithTarget:self selector:@selector(onSpriteForSel)];
        CCAction * action = [CCActionSequence actionWithArray:@[moveEnd, little, remove, onSel]];
        
        // if判断是否到达终点，到达终点在触发下列运算
        if ([self spriteGetOrNot:endPoint]) {
            getOfMove = YES; // 是到达终点而非切换页面
            selTrainHead = [selTrainHead createWithExists:newTrainHead]; // 通过已有的对象复制对象，记录选中的火车头
            [self setTrainHeadToFile:selTrainHead]; // 文件储存
            spriteSelected = NO; // 重置纪录项，现在没有选中的对象
            [newTrainHead runAction:[action copy]]; // 到达终点，触发特效
        }
        else {
            [newTrainHead removeFromParent]; // 没有到达终点，重置位置，删除产生的选中对象
            spriteSelected = NO;
        }
        
        // 如果是到达终点，而非切换页面，不需要出发接下来的页面切换操作，直接跳出
        if (getOfMove) {
            return;
        }
        
        // 页面切换操作
        if (self.beganPoint.y < self.viewSize.height / 3) {
            if (tranLoc.x >= 100) {
                // Right
                // 浏览页面整体向右，切换上一页
                [self onRightTouchSlide];
            }
            else if (tranLoc.x <= -100) {
                // Left
                // 浏览页面整体向左，切换下一页
                [self onLeftTouchSlide];
            }
        }
    }
    self.isMoved = NO; // 触屏移动结束
}

// 触屏中断（暂时不知道如何触发，也用不到）
-(void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CCLOG(@"touchCancelled!");
}

// 此函数用来确认火车图片被选择，并进行相应操作
-(void)spriteSelectedOrNot:(CGPoint)pos {
    CGPoint posSelected = pos;
    for (TrainHead *head in trainHeadArray) {
        if (CGRectContainsPoint(head.boundingBox, posSelected)) {
            spriteSelected = YES; // 设置有精灵选中，可以进行接下来的操作
            newTrainHead = [newTrainHead createWithExists:head]; // 通过选中的对象，新建对象储存
            [newTrainHead setScale:(self.contentSize.width * 0.2f/head.contentSize.width)];
            [self addChild:newTrainHead z:10]; // 添加对象覆盖住原对象，造成选中的特效
            
            CCAction *bigger = [CCActionScaleBy actionWithDuration:0 scale:1.2f]; // 增大特效，选中特效
            [newTrainHead runAction:bigger];
            
            break;
        }
    }
}

// 向右滑动，切换上一页
-(void)onRightTouchSlide {
    if (sceneHeadNow > 1) {
        // 火车头浏览页面所有元素整体向右移动一个页面，造成切换特效
        CCAction *moveRight = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(1.0f, 0)];
        for (TrainHead *head in trainHeadArray) {
            [head runAction:[moveRight copy]];
        }
        sceneHeadNow -= 1; // 纪录当前页面－1
    }
}

// 向左滑动，切换下一页
-(void)onLeftTouchSlide {
    // 火车头浏览页面整体左移动一个页面，造成切换特效
    if ([trainHeadArray count] % 3 == 0 && sceneHeadNow < [trainHeadArray count] / 3) {
        // 如果刚好一个页面放下
        CCAction *moveLeft = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(-1.0f, 0)];
        for (TrainHead *head in trainHeadArray) {
            [head runAction:[moveLeft copy]];
        }
        sceneHeadNow += 1; // 纪录当前页面＋1，
    }
    else if ([trainHeadArray count] % 3 != 0 && sceneHeadNow <= [trainHeadArray count] / 3) {
        // 如果最后一个页面只放下一部分
        CCAction *moveLeft = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(-1.0f, 0)];
        for (TrainHead *head in trainHeadArray) {
            [head runAction:[moveLeft copy]];
        }
        sceneHeadNow += 1;
    }
}

// 判断当前选终点是否到达终点
-(BOOL)spriteGetOrNot:(CGPoint)pos {
    CGPoint posEnd = pos;
    // 如果没有选中对象，此函数跳出
    if (!spriteSelected) {
        return NO;
    }
    
    if (CGRectContainsPoint(selTrainHead.boundingBox, posEnd)) {
        // 到达火车头终点
        //boxHead.opacity = 0; // 终点box隐藏
        [selTrainHead removeFromParent]; // 移除之前产生的纪录选中火车头的对象
        return YES; // 提示调用者到达终点
    }
    return NO;
}

// 到达终点后，使用新产生的选中对象放在终点处，造成把对象拉到终点纪录的特效
- (void)onSpriteForSel {
    [selTrainHead setRow:boxHead.position.x];
    [selTrainHead setColumn:boxHead.position.y];
    [selTrainHead setPosition:[boxHead position]];
    [selTrainHead setScale:(self.contentSize.width * 0.4f/selTrainHead.contentSize.width)];
    
    [self addChild:selTrainHead z:9]; // 将产生的对象放在终点处
}

- (void)setTrainHeadToFile:(TrainHead *) train {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [train url], @"TrainSelected",
                         @"", @"Others",
                         nil];
    [_dataManager writeDicWithName:@"TrainNow" Dic:dic];
}

@end

