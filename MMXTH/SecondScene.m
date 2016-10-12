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
#import "FirstScene.h"
#import "Train.h"
#import "TrainHead.h"
#import "TrainGoods.h"
#import "Track.h"

// -----------------------------------------------------------------

@implementation SecondScene

#define LEFT 0
#define RITHT 1

@synthesize isMoved;
@synthesize beganPoint;
@synthesize trainNow;
@synthesize sceneNow;
@synthesize viewSize;
@synthesize boxHead;
@synthesize trainHeadArray;
@synthesize trainGoodsArray;
@synthesize trackArray;

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
    self.viewSize = [CCDirector sharedDirector].viewSize;
    self.userInteractionEnabled = YES; // 注册触屏事件
    // 暂时不知道为什么必须定义一个CCNodeColor才能使用触屏功能
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:27.0f/255.0f green:185.0f/255.0f blue:239.0f/255.0f alpha:1.0f]];
    [self addChild:background];
    
    trainNow = train_Head; // 当前为Head选择页面
    sceneNow = 1; // 默认为第一页
    selTrainHead = [[TrainHead alloc] init];
    newTrainHead = [[TrainHead alloc] init];
    
    trainHead = [[TrainHead alloc] init];
    trainHeadArray = [NSMutableArray arrayWithCapacity:0];
    NSInteger headCount = [[trainHead trainArray] count];
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
    
    [self initScene];
    return self;
}

-(void)initScene {
    // Background
    // You can change the .png files to change the background
    CCSprite9Slice *background = [CCSprite9Slice spriteWithImageNamed:@"white_square.png"];
    background.anchorPoint = CGPointZero;
    background.contentSize = [CCDirector sharedDirector].viewSize;
    background.color = [CCColor grayColor];
    [self addChild:background];
    
    CCLabelTTF *backTitle = [CCLabelTTF labelWithString:@"Back" fontName:@"ArialMT" fontSize:20];
    backTitle.color = [CCColor redColor];
    backTitle.positionType = CCPositionTypeNormalized;
    backTitle.position = ccp(0.1f, 0.9f);
    
    // BackButton
    CCButton *backButton = [CCButton buttonWithTitle:@"Back" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]];
    [backButton setTarget:self selector:@selector(onBackButtonClicked:)];
    backButton.positionType = CCPositionTypeNormalized;
    
    [backButton setPosition:ccp(0.1f, 0.9f)];
    
    [self addChild:backButton z:9];
    [self addChild:backTitle z:10];
    
    [self insideTrainHeadScene];
}
// -----------------------------------------------------------------

- (void)onBackButtonClicked:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[FirstScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
}

-(void)insideTrainHeadScene {
    boxHead = [CCSprite spriteWithImageNamed:@"white_square.png"];
    self.boxHead.positionType = CCPositionTypeNormalized;
    [self.boxHead setPosition:ccp(0.3f, 0.8f)];
    [self addChild:self.boxHead z:8];
    
    for (TrainHead *head in trainHeadArray) {
        [self addChild:head z:9];
    }
}

#pragma mark--------------------------------------------------------------
#pragma mark - Touch Handler
#pragma mark--------------------------------------------------------------

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    self.isMoved = YES;
    // 获取点击坐标
    beganPoint = [touch locationInNode:self];
    CCLOG(@"touchBegan!");
    //CCLOG(@"beganPoint: %@", NSStringFromCGPoint(beganPoint));
    //CCLOG(@"Location:%@", NSStringFromCGPoint(touchLocation));
    
    [self spriteSelectedOrNot:beganPoint];
}

-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    
    // 通过View坐标去转换成Node坐标
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    // 跟随手指移动
    CGPoint tranLoc = ccpSub(touchLocation, oldTouchLocation);
    tranLoc.x = tranLoc.x / self.viewSize.width;
    tranLoc.y = tranLoc.y / self.viewSize.height;
    CCLOG(@"TranLoc: %@", NSStringFromCGPoint(newTrainHead.position));
    CCAction *action = [CCActionMoveBy actionWithDuration:0.0f position:tranLoc];
    [newTrainHead runAction:action];
    
    CCLOG(@"touchMoved!");
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint endPoint = [touch locationInNode:self];
    if (self.isMoved) {
        CGPoint tranLoc = ccpSub(endPoint, self.beganPoint);
        CCLOG(@"tranloc: %@", NSStringFromCGPoint(tranLoc));
        BOOL getOfMove = NO;
        switch (trainNow) {
            case train_Head:
                if ([self spriteGetOrNot:endPoint]) {
                    CCLOG(@"Get!");
                    getOfMove = YES;
                    selTrainHead = [selTrainHead createWithExists:newTrainHead];
                    CCAction *moveEnd = [CCActionMoveTo actionWithDuration:0 position:self.boxHead.position];
                    CCAction *little = [CCActionScaleTo actionWithDuration:0 scale:1.0f];
                    CCAction *remove = [CCActionRemove action];
                    CCAction *onSel = [CCActionCallFunc actionWithTarget:self selector:@selector(onSpriteForSel)];
                    CCAction * action = [CCActionSequence actionWithArray:@[moveEnd, little, remove, onSel]];
                    [newTrainHead runAction:action];
                }
                else {
                    [newTrainHead removeFromParent];
                }
                break;
            case train_Goods:
                break;
            case train_Track:
                break;
            default:
                break;
        }
        
        if (getOfMove) {
            return;
        }
        
        if (self.beganPoint.y < self.viewSize.height / 3) {
            if (tranLoc.x >= 100) {
                // Right
                CCLOG(@"Right!");
                [self onRightTouchSlide];
            }
            else if (tranLoc.x <= -100) {
                // Left
                CCLOG(@"Left!");
                [self onLeftTouchSlide];
            }
        }
    }
    self.isMoved = NO; // 触屏移动结束
    CCLOG(@"touchEnded!");
}

-(void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CCLOG(@"touchCancelled!");
}

// 此函数用来确认火车图片被选择，并进行相应操作
-(void)spriteSelectedOrNot:(CGPoint)pos {
    CGPoint posSelected = pos;
    for (TrainHead *head in trainHeadArray) {
        if (CGRectContainsPoint(head.boundingBox, posSelected)) {
            CCLOG(@"火车已选择%@图片！", head);
            newTrainHead = [newTrainHead createWithExists:head];
            [self addChild:newTrainHead z:10];
            
            CCAction *bigger = [CCActionScaleTo actionWithDuration:0 scale:1.2f];
            [newTrainHead runAction:bigger];
            
            break;
        }
    }
}

-(void)onRightTouchSlide {
    if (sceneNow > 1) {
        CCAction *moveRight = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(1.0f, 0)];
        for (TrainHead *head in trainHeadArray) {
            [head runAction:[moveRight copy]];
        }
        sceneNow -= 1;
        CCLOG(@"scene: %d", sceneNow);
    }
}

-(void)onLeftTouchSlide {
    if ([trainHeadArray count] % 3 == 0 && sceneNow < [trainHeadArray count] / 3) {
        CCAction *moveLeft = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(-1.0f, 0)];
        for (TrainHead *head in trainHeadArray) {
            [head runAction:[moveLeft copy]];
        }
        sceneNow += 1;
        CCLOG(@"scene: %d", sceneNow);
    }
    else if ([trainHeadArray count] % 3 != 0 && sceneNow <= [trainHeadArray count] / 3) {
        CCAction *moveLeft = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(-1.0f, 0)];
        for (TrainHead *head in trainHeadArray) {
            [head runAction:[moveLeft copy]];
        }
        sceneNow += 1;
        CCLOG(@"scene: %d", sceneNow);
        
    }
}

-(BOOL)spriteGetOrNot:(CGPoint)pos {
    CGPoint posEnd = pos;
    switch (trainNow) {
        case train_Head:
            if (CGRectContainsPoint(boxHead.boundingBox, posEnd)) {
                CCLOG(@"火车已到达boxHead！");
                boxHead.opacity = 0; // 隐藏
                [selTrainHead removeFromParent];
                return YES;
            }
            break;
        case train_Goods:
            break;
        case train_Track:
            break;
        default:
            break;
    }
    return NO;
}

-(void)onSpriteForSel {
    if (trainNow == train_Head) {
        //selTrainHead = [selTrainHead createWithExists:selTrainHead];
        [selTrainHead setRow:boxHead.position.x];
        [selTrainHead setColumn:boxHead.position.y];
        [selTrainHead setPosition:[boxHead position]];
        
        [self addChild:selTrainHead z:9];
        CCLOG(@"sel Set!");
    }
    else if (trainNow == train_Goods) {
        
    }
    else if (trainNow == train_Track) {
        
    }
}
/*
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    self.isMoved = YES; // 标记发生触屏移动
    // 获取点击坐标
    beganPoint = [touch locationInNode:self];
    CCLOG(@"touchBegan!");
    //CCLOG(@"beganPoint: %@", NSStringFromCGPoint(beganPoint));
    //CCLOG(@"Location:%@", NSStringFromCGPoint(touchLocation));
    [self spriteSelectedOrNot:beganPoint];
}

-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    
    CGPoint touchLocation = [touch locationInNode:self];
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    
    // 通过View坐标去转换成Node坐标
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    // 跟随手指移动
    CGPoint tranLoc = ccpSub(touchLocation, oldTouchLocation);
    tranLoc.x = tranLoc.x / self.viewSize.width;
    tranLoc.y = tranLoc.y / self.viewSize.height;
    CCLOG(@"TranLoc: %@", NSStringFromCGPoint(newTrain.position));
    CCAction *action = [CCActionMoveBy actionWithDuration:0.0f position:tranLoc];
    [newTrain runAction:action];
    
    CCLOG(@"touchMoved!");
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint endPoint = [touch locationInNode:self];
    if (self.isMoved) {
        CGPoint tranLoc = ccpSub(endPoint, self.beganPoint);
        CCLOG(@"tranloc: %@", NSStringFromCGPoint(tranLoc));
        
        if (self.beganPoint.y < self.viewSize.height / 3) {
            if (tranLoc.x >= 100) {
                // Right
                CCLOG(@"Right!");
                [self onRightTouchSlide];
            }
            else if (tranLoc.x <= -100) {
                // Left
                CCLOG(@"Left!");
                [self onLeftTouchSlide];
            }
        }
        
        if ([self spriteGetOrNot:endPoint]) {
            CCLOG(@"Get!");
            CCAction *moveEnd = [CCActionMoveTo actionWithDuration:0 position:self.box.position];
            CCAction *little = [CCActionScaleTo actionWithDuration:0 scale:1.0f];
            CCAction *remove = [CCActionRemove action];
            CCAction *onSel = [CCActionCallFunc actionWithTarget:self selector:@selector(onSpriteForSel)];
            CCAction * action = [CCActionSequence actionWithArray:@[moveEnd, little, remove, onSel]];
            [newTrain runAction:action];
            
            //[newTrain stopAllActions];
        }
        else {
            [newTrain removeFromParent];
        }
        //CCLOG(@"endPoint: %@", NSStringFromCGPoint(endPoint));
    }
    self.isMoved = NO; // 触屏移动结束
    CCLOG(@"touchEnded!");
}

-(void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CCLOG(@"touchCancelled!");
}

// 此函数用来确认火车图片被选择，并进行相应操作
-(void)spriteSelectedOrNot:(CGPoint)pos {
    CGPoint posSelected = pos;
    if (CGRectContainsPoint(train.boundingBox, posSelected)) {
        CCLOG(@"火车已选择此图片！");
        [self changeSpriteStyle];
    }
}

-(BOOL)spriteGetOrNot:(CGPoint)pos {
    CGPoint posEnd = pos;
    if (CGRectContainsPoint(box.boundingBox, posEnd)) {
        CCLOG(@"火车已到达box！");
        box.opacity = 0; // 隐藏
        if (selTrain) {
            // 如果存在，重置
            [selTrain removeFromParent];
        }
        return YES;
    }
    return NO;
}

-(void)spriteSelectedMove:(CGPoint)pos {
    CGPoint posSelected = pos;
    if (CGRectContainsPoint(train.boundingBox, posSelected)) {
        CCLOG(@"火车已选择此图片并移动！");
    }
}

-(void)onSpriteForSel {
    selTrain = [[Train alloc] init];
    selTrain = [selTrain create:self.box.position.x ySet:self.box.position.y];
    [self addChild:selTrain z:9];
}

-(void)changeSpriteStyle {
    [newTrain removeFromParent];
    newTrain = [[Train alloc] init];
    newTrain = [newTrain create:0.5f ySet:0.3f];
    
    [self addChild:newTrain z:9];
    
    CCAction *bigger = [CCActionScaleTo actionWithDuration:0 scale:1.2f];
    [newTrain runAction:bigger];
}

-(void)onActionEnd_Out {
    [train removeFromParent];
}

-(void)onActionEnd_In:(float)x {
    train = [[Train alloc] init];
    train = [train create:0.5f+x ySet:0.3f];
    //train.opacity = 0; //不显示
    train.scale = 0.4f;
    [self addChild:train z:9];
}

-(void)onRightTouchSlide {
    int temp = [Train getCount];
    temp ++;
    if (temp >= 3) {
        temp = 0;
    }
    [Train setCount:temp];
    CCLOG(@"Next Change, Count: %d", [Train getCount]);
    
    [self leftToRight_Out];
}

-(void)onLeftTouchSlide {
    int temp = [Train getCount];
    temp --;
    if (temp < 0) {
        temp = 2;
    }
    [Train setCount:temp];
    CCLOG(@"Last Change, Count: %d", [Train getCount]);

    [self rightToLeft_Out];
}

-(void)leftToRight_Out {
    id actionEnd = [CCActionCallFunc actionWithTarget:self selector:@selector(onActionEnd_Out)];
    id actionIn = [CCActionCallFunc actionWithTarget:self selector:@selector(leftToRight_In)];
    CCAction *rightMove = [CCActionMoveBy actionWithDuration:0.5f position:CGPointMake(0.1f, 0)];
    CCAction *spriteFadeOut = [CCActionFadeOut actionWithDuration:0.5f];
    CCAction *spriteToLittle = [CCActionScaleTo actionWithDuration:0.5f scale:0.4f];
    CCAction *rightAction = [CCActionSpawn actionWithArray:@[rightMove, spriteToLittle, spriteFadeOut]];
    CCAction *action = [CCActionSequence actionWithArray:@[rightAction, actionEnd, actionIn]];
    [train runAction:action];
}

-(void)rightToLeft_Out {
    id actionEnd = [CCActionCallFunc actionWithTarget:self selector:@selector(onActionEnd_Out)];
    id actionIn = [CCActionCallFunc actionWithTarget:self selector:@selector(rightToLeft_In)];
    CCAction *leftMove = [CCActionMoveBy actionWithDuration:0.5f position:CGPointMake(-0.1f, 0)];
    CCAction *spriteFadeOut = [CCActionFadeOut actionWithDuration:0.5f];
    CCAction *spriteToLittle = [CCActionScaleTo actionWithDuration:0.5f scale:0.4f];
    CCAction *actionRemove = [CCActionRemove action];
    CCAction *leftAction = [CCActionSpawn actionWithArray:@[leftMove, spriteToLittle, spriteFadeOut]];
    CCAction *action = [CCActionSequence actionWithArray:@[leftAction, actionRemove, actionEnd, actionIn]];
    [train runAction:action];
}

-(void)leftToRight_In {
    [self onActionEnd_In:-0.1f];
    CCAction *leftMove = [CCActionMoveBy actionWithDuration:0.5f position:CGPointMake(0.1f, 0)];
    CCAction *spriteFadeIn = [CCActionFadeIn actionWithDuration:0.5f];
    CCAction *spriteToLarge = [CCActionScaleTo actionWithDuration:0.5f scale:1.0f];
    //CCAction *actionRemove = [CCActionRemove action];
    CCAction *leftAction = [CCActionSpawn actionWithArray:@[leftMove, spriteToLarge, spriteFadeIn]];
    //CCAction *action = [CCActionSequence actionWithArray:@[leftAction, actionRemove]];
    //train.opacity = 1; //设置成显示
    [train runAction:leftAction];
}

-(void)rightToLeft_In {
    [self onActionEnd_In:0.1f];
    CCAction *rightMove = [CCActionMoveBy actionWithDuration:0.5f position:CGPointMake(-0.1f, 0)];
    CCAction *spriteFadeIn = [CCActionFadeIn actionWithDuration:0.5f];
    CCAction *spriteToLarge = [CCActionScaleTo actionWithDuration:0.5f scale:1.0f];
    //CCAction *actionRemove = [CCActionRemove action];
    CCAction *rightAction = [CCActionSpawn actionWithArray:@[rightMove, spriteToLarge, spriteFadeIn]];
    //CCAction *action = [CCActionSequence actionWithArray:@[rightAction, actionRemove]];
    //train.opacity = 1; //设置成显示
    [train runAction:rightAction];
}
@end



*/

@end

