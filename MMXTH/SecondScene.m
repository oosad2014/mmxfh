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

#import "TestTrainScene.h"
#import "SecondScene.h"
#import "FirstScene.h"
#import "Train.h"
#import "TrainHead.h"
#import "TrainGoods.h"
#import "Track.h"

// -----------------------------------------------------------------

@implementation SecondScene

@synthesize isMoved;
@synthesize spriteSelected;
@synthesize beganPoint;
@synthesize trainNow;
@synthesize sceneHeadNow;
@synthesize sceneGoodsNow;
@synthesize sceneTrackNow;
@synthesize viewSize;
@synthesize boxHead;
@synthesize boxGoods;
@synthesize boxTrack;
@synthesize trainHeadArray;
@synthesize trainGoodsArray;
@synthesize trackArray;
@synthesize trainHeadBtn;
@synthesize trainGoodsBtn;
@synthesize trackBtn;

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
    
    // 定义颜色层节点，用于保存scene页面和触发触屏
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:27.0f/255.0f green:185.0f/255.0f blue:239.0f/255.0f alpha:1.0f]];
    [self addChild:background];
    
    sceneHeadNow = 1; // 默认为第一页
    sceneTrackNow = 1;
    sceneGoodsNow = 1;
    
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
                head = [head create:(i/3 + 0.25f) ySet:0.3f];
                break;
            case 2:
                head = [head create:(i/3 + 0.5f) ySet:0.3f];
                break;
            case 0:
                head = [head create:(i/3 - 1 + 0.75f) ySet:0.3f];
                break;
        }
        [trainHeadArray addObject:head];
    }
    
    // Goods
    // 处理同上
    selTrainGoods = [[TrainGoods alloc] init];
    newTrainGoods = [[TrainGoods alloc] init];
    trainGoods = [[TrainGoods alloc] init];
    trainGoodsArray = [NSMutableArray arrayWithCapacity:0];
    NSInteger goodsCount = [[trainGoods trainArray] count];
    for (int i=1; i<=goodsCount; i++) {
        TrainGoods *goods =  [[TrainGoods alloc] init];
        [TrainGoods setCount:i-1];
        switch (i%3) {
            case 1:
                goods = [goods create:(i/3 + 0.25f) ySet:0.3f];
                break;
            case 2:
                goods = [goods create:(i/3 + 0.5f) ySet:0.3f];
                break;
            case 0:
                goods = [goods create:(i/3 - 1 + 0.75f) ySet:0.3f];
                break;
        }
        [trainGoodsArray addObject:goods];
    }
    
    // Track
    // 处理同上
    selTrainTrack = [[Track alloc] init];
    newTrainTrack = [[Track alloc] init];
    trainTrack = [[Track alloc] init];
    trackArray = [NSMutableArray arrayWithCapacity:0];
    NSInteger trackCount = [[trainTrack trainArray] count];
    for (int i=1; i<=trackCount; i++) {
        Track *track =  [[Track alloc] init];
        [Track setCount:i-1];
        switch (i%3) {
            case 1:
                track = [track create:(i/3 + 0.25f) ySet:0.3f];
                break;
            case 2:
                track = [track create:(i/3 + 0.5f) ySet:0.3f];
                break;
            case 0:
                track = [track create:(i/3 - 1 + 0.75f) ySet:0.3f];
                break;
        }
        [trackArray addObject:track];
    }

    // 加载额外初始化元素
    [self initScene];
    return self;
}

-(void)initScene {
    // Background
    // You can change the .png files to change the background
    // 背景
    CCSprite9Slice *background = [CCSprite9Slice spriteWithImageNamed:@"white_square.png"];
    background.anchorPoint = CGPointZero;
    background.contentSize = [CCDirector sharedDirector].viewSize;
    background.color = [CCColor grayColor];
    [self addChild:background];
    
    // back按钮上文字
    CCLabelTTF *backTitle = [CCLabelTTF labelWithString:@"Back" fontName:@"ArialMT" fontSize:20];
    backTitle.color = [CCColor redColor];
    backTitle.positionType = CCPositionTypeNormalized;
    backTitle.position = ccp(0.1f, 0.9f);
    [self addChild:backTitle z:10]; // 文字要高于按钮一层
    
    // Back按钮
    CCButton *backButton = [CCButton buttonWithTitle:@"Back" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]];
    [backButton setTarget:self selector:@selector(onBackButtonClicked:)];
    backButton.positionType = CCPositionTypeNormalized;
    [backButton setPosition:ccp(0.1f, 0.9f)];
    [self addChild:backButton z:9];
    
    // Play按钮
    CCButton *play = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"icon/play.png"]];
    [play setTarget:self selector:@selector(onPlayButtonClicked:)];
    [play setPositionType:CCPositionTypeNormalized];
    [play setPosition:ccp(0.95f, 0.1f)];
    [play setScale:0.1f];
    [self addChild:play z: 9];
    
    // TrainHead Button
    trainHeadBtn = [CCButton buttonWithTitle:@"TrainHead" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]];
    [trainHeadBtn setTarget:self selector:@selector(insideTrainHeadScene)];
    trainHeadBtn.positionType = CCPositionTypeNormalized;
    [trainHeadBtn setPosition:ccp(0.1f, 0.3f)];
    [self addChild:trainHeadBtn z:9];
    
    // TrainGoods Button
    trainGoodsBtn = [CCButton buttonWithTitle:@"TrainGoods" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]];
    [trainGoodsBtn setTarget:self selector:@selector(insideTrainGoodsScene)];
    trainGoodsBtn.positionType = CCPositionTypeNormalized;
    [trainGoodsBtn setPosition:ccp(0.1f, 0.2f)];
    [self addChild:trainGoodsBtn z:9];
    
    // Track Button
    trackBtn = [CCButton buttonWithTitle:@"Track" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]];
    [trackBtn setTarget:self selector:@selector(insideTrackScene)];
    trackBtn.positionType = CCPositionTypeNormalized;
    [trackBtn setPosition:ccp(0.1f, 0.1f)];
    [self addChild:trackBtn z:9];
    
    // 火车头终点贴图
    boxHead = [CCSprite spriteWithImageNamed:@"white_square.png"];
    self.boxHead.positionType = CCPositionTypeNormalized;
    [self.boxHead setPosition:ccp(0.35f, 0.8f)];
    [self addChild:self.boxHead z:8];
    
    // 货车货物终点贴图
    boxGoods = [CCSprite spriteWithImageNamed:@"white_square.png"];
    self.boxGoods.positionType = CCPositionTypeNormalized;
    [self.boxGoods setPosition:ccp(0.5f, 0.85f)];
    [self addChild:self.boxGoods z:8];
    
    // 火车铁轨终点贴图
    boxTrack = [CCSprite spriteWithImageNamed:@"white_square.png"];
    self.boxTrack.positionType = CCPositionTypeNormalized;
    [self.boxTrack setPosition:ccp(0.5f, 0.6f)];
    [self addChild:self.boxTrack z:8];
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
- (void)onPlayButtonClicked:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[TestTrainScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
}

// 添加火车头浏览界面
-(void)insideTrainHeadScene {
    // 移除其它两个控件浏览界面并使其按钮可点击
    [self removeTrainGoodsScene];
    [trainGoodsBtn setEnabled:YES];
    [self removeTrackScene];
    [trackBtn setEnabled:YES];
    
    trainNow = train_Head; // 当前为Head选择页面
    
    // 加载所有的火车头种类控件
    CCAction *fadeIn = [CCActionFadeIn actionWithDuration:1.0f];
    for (TrainHead *head in trainHeadArray) {
        [self addChild:head z:9];
        [head runAction:[fadeIn copy]];
    }
    [trainHeadBtn setEnabled:NO]; // 禁用火车头按钮，防止多次点击
}

// 处理同上
-(void)insideTrainGoodsScene {
    [self removeTrainHeadScene];
    [trainHeadBtn setEnabled:YES];
    [self removeTrackScene];
    [trackBtn setEnabled:YES];
    
    trainNow = train_Goods;
    
    CCAction *fadeIn = [CCActionFadeIn actionWithDuration:1.0f];
    for (TrainGoods *goods in trainGoodsArray) {
        [self addChild:goods z:9];
        [goods runAction:[fadeIn copy]];
    }
    [trainGoodsBtn setEnabled:NO];
}

// 处理同上
-(void)insideTrackScene {
    [self removeTrainGoodsScene];
    [trainGoodsBtn setEnabled:YES];
    [self removeTrainHeadScene];
    [trainHeadBtn setEnabled:YES];
    
    trainNow = train_Track;
    
    CCAction *fadeIn = [CCActionFadeIn actionWithDuration:1.0f];
    for (Track *track in trackArray) {
        [self addChild:track z:9];
        [track runAction:[fadeIn copy]];
    }
    [trackBtn setEnabled:NO];
}

// 移除火车头浏览界面
-(void)removeTrainHeadScene {
    // 移除浏览界面里的所有火车头种类以达到类似移除界面的效果
    for (TrainHead *head in trainHeadArray) {
        [head removeFromParent];
    }
}

// 同上
-(void)removeTrainGoodsScene {
    for (TrainGoods *goods in trainGoodsArray) {
        [goods removeFromParent];
    }
}

// 同上
-(void)removeTrackScene {
    for (Track *track in trackArray) {
        [track removeFromParent];
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
    
    // 判断此时存在的展示页面，对其进行运动操作
    switch (trainNow) {
        case train_Head:
            [newTrainHead runAction:[action copy]];
            break;
        case train_Goods:
            [newTrainGoods runAction:[action copy]];
            break;
        case train_Track:
            [newTrainTrack runAction:[action copy]];
            break;
        default:
            break;
    }
    
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
        CCAction *little = [CCActionScaleTo actionWithDuration:0 scale:1.0f];
        CCAction *remove = [CCActionRemove action];
        CCAction *onSel = [CCActionCallFunc actionWithTarget:self selector:@selector(onSpriteForSel)];
        CCAction * action = [CCActionSequence actionWithArray:@[moveEnd, little, remove, onSel]];
        
        switch (trainNow) {
            case train_Head:
                // if判断是否到达终点，到达终点在触发下列运算
                if ([self spriteGetOrNot:endPoint]) {
                    getOfMove = YES; // 是到达终点而非切换页面
                    selTrainHead= [selTrainHead createWithExists:newTrainHead]; // 通过已有的对象复制对象，记录选中的火车头
                    spriteSelected = NO; // 重置纪录项，现在没有选中的对象
                    [newTrainHead runAction:[action copy]]; // 到达终点，触发特效
                }
                else {
                    [newTrainHead removeFromParent]; // 没有到达终点，重置位置，删除产生的选中对象
                    spriteSelected = NO;
                }
                break;
            case train_Goods:
                if ([self spriteGetOrNot:endPoint]) {
                    getOfMove = YES;
                    selTrainGoods = [selTrainGoods createWithExists:newTrainGoods];
                    spriteSelected = NO;
                    [newTrainGoods runAction:[action copy]];
                }
                else {
                    [newTrainGoods removeFromParent];
                    spriteSelected = NO;
                }
                break;
            case train_Track:
                if ([self spriteGetOrNot:endPoint]) {
                    getOfMove = YES;
                    selTrainTrack = [selTrainTrack createWithExists:newTrainTrack];
                    spriteSelected = NO;
                    [newTrainTrack runAction:[action copy]];
                }
                else {
                    [newTrainTrack removeFromParent];
                    spriteSelected = NO;
                }
                break;
            default:
                break;
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
    switch (trainNow) {
        case train_Head:
            for (TrainHead *head in trainHeadArray) {
                if (CGRectContainsPoint(head.boundingBox, posSelected)) {
                    spriteSelected = YES; // 设置有精灵选中，可以进行接下来的操作
                    newTrainHead = [newTrainHead createWithExists:head]; // 通过选中的对象，新建对象储存
                    [self addChild:newTrainHead z:10]; // 添加对象覆盖住原对象，造成选中的特效
                    
                    CCAction *bigger = [CCActionScaleTo actionWithDuration:0 scale:1.2f]; // 增大特效，选中特效
                    [newTrainHead runAction:bigger];
                    
                    break;
                }
            }
            break;
        case train_Goods:
            for (TrainGoods *goods in trainGoodsArray) {
                if (CGRectContainsPoint(goods.boundingBox, posSelected)) {
                    spriteSelected = YES;
                    newTrainGoods = [newTrainGoods createWithExists:goods];
                    [self addChild:newTrainGoods z:10];
                    
                    CCAction *bigger = [CCActionScaleTo actionWithDuration:0 scale:1.2f];
                    [newTrainGoods runAction:bigger];
                    
                    break;
                }
            }
            break;
        case train_Track:
            for (Track *track in trackArray) {
                if (CGRectContainsPoint(track.boundingBox, posSelected)) {
                    spriteSelected = YES;
                    newTrainTrack = [newTrainTrack createWithExists:track];
                    [self addChild:newTrainTrack z:10];
                    
                    CCAction *bigger = [CCActionScaleTo actionWithDuration:0 scale:1.2f];
                    [newTrainTrack runAction:bigger];
                    
                    break;
                }
            }
            break;
        default:
            break;
    }
}

// 向右滑动，切换上一页
-(void)onRightTouchSlide {
    switch (trainNow) {
        case train_Head:
            if (sceneHeadNow > 1) {
                // 火车头浏览页面所有元素整体向右移动一个页面，造成切换特效
                CCAction *moveRight = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(1.0f, 0)];
                for (TrainHead *head in trainHeadArray) {
                    [head runAction:[moveRight copy]];
                }
                sceneHeadNow -= 1; // 纪录当前页面－1
            }
            break;
        case train_Goods:
            if (sceneGoodsNow > 1) {
                CCAction *moveRight = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(1.0f, 0)];
                for (TrainGoods *goods in trainGoodsArray) {
                    [goods runAction:[moveRight copy]];
                }
                sceneGoodsNow -= 1;
            }
            break;
        case train_Track:
            if (sceneTrackNow > 1) {
                CCAction *moveRight = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(1.0f, 0)];
                for (Track *track in trackArray) {
                    [track runAction:[moveRight copy]];
                }
                sceneTrackNow -= 1;
            }
            break;
        default:
            break;
    }
}

// 向左滑动，切换下一页
-(void)onLeftTouchSlide {
    switch (trainNow) {
        case train_Head:
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
            break;
        case train_Goods:
            if ([trainGoodsArray count] % 3 == 0 && sceneGoodsNow < [trainGoodsArray count] / 3) {
                CCAction *moveLeft = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(-1.0f, 0)];
                for (TrainGoods *goods in trainGoodsArray) {
                    [goods runAction:[moveLeft copy]];
                }
                sceneHeadNow += 1;
            }
            else if ([trainGoodsArray count] % 3 != 0 && sceneGoodsNow <= [trainGoodsArray count] / 3) {
                CCAction *moveLeft = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(-1.0f, 0)];
                for (TrainGoods *goods in trainGoodsArray) {
                    [goods runAction:[moveLeft copy]];
                }
                sceneGoodsNow += 1;
            }
            break;
        case train_Track:
            if ([trackArray count] % 3 == 0 && sceneTrackNow < [trackArray count] / 3) {
                CCAction *moveLeft = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(-1.0f, 0)];
                for (Track *track in trackArray) {
                    [track runAction:[moveLeft copy]];
                }
                sceneTrackNow += 1;
            }
            else if ([trackArray count] % 3 != 0 && sceneTrackNow <= [trackArray count] / 3) {
                CCAction *moveLeft = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(-1.0f, 0)];
                for (Track *track in trackArray) {
                    [track runAction:[moveLeft copy]];
                }
                sceneTrackNow += 1;
            }
            break;
        default:
            break;
    }
}

// 判断当前选终点是否到达终点
-(BOOL)spriteGetOrNot:(CGPoint)pos {
    CGPoint posEnd = pos;
    // 如果没有选中对象，此函数跳出
    if (!spriteSelected) {
        return NO;
    }
    
    switch (trainNow) {
        case train_Head:
            if (CGRectContainsPoint(boxHead.boundingBox, posEnd)) {
                // 到达火车头终点
                boxHead.opacity = 0; // 终点box隐藏
                [selTrainHead removeFromParent]; // 移除之前产生的纪录选中火车头的对象
                return YES; // 提示调用者到达终点
            }
            break;
        case train_Goods:
            if (CGRectContainsPoint(boxGoods.boundingBox, posEnd)) {
                boxGoods.opacity = 0;
                [selTrainGoods removeFromParent];
                return YES;
            }
            break;
        case train_Track:
            if (CGRectContainsPoint(boxTrack.boundingBox, posEnd)) {
                boxTrack.opacity = 0;
                [selTrainTrack removeFromParent];
                return YES;
            }
            break;
        default:
            break;
    }
    return NO;
}

// 到达终点后，使用新产生的选中对象放在终点处，造成把对象拉到终点纪录的特效
-(void)onSpriteForSel {
    switch (trainNow) {
        case train_Head:
            [selTrainHead setRow:boxHead.position.x];
            [selTrainHead setColumn:boxHead.position.y];
            [selTrainHead setPosition:[boxHead position]];
            
            [self addChild:selTrainHead z:9]; // 将产生的对象放在终点处
            break;
        case train_Goods:
            [selTrainGoods setRow:boxGoods.position.x];
            [selTrainGoods setColumn:boxGoods.position.y];
            [selTrainGoods setPosition:[boxGoods position]];
            
            [self addChild:selTrainGoods z:9];
            break;
        case train_Track:
            [selTrainTrack setRow:boxTrack.position.x];
            [selTrainTrack setColumn:boxTrack.position.y];
            [selTrainTrack setPosition:[boxTrack position]];
            
            [self addChild:selTrainTrack z:9];
            break;
        default:
            break;
    }
}

// 类方法，暴露当前选中的火车头对象
+ (TrainHead *)getTrainHeadSel {
    return selTrainHead;
}

// 类方法，暴露当前选中的火车货物对象
+ (TrainGoods *)getTrainGoodsSel {
    return selTrainGoods;
}

// 类方法，暴露当前选中的火车轨对象
+ (Track *)getTrackSel {
    return selTrainTrack;
}

@end

