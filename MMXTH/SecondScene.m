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
@synthesize viewSize;
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
    
    // CGSize screenSize = [CCDirector sharedDirector].viewSize;
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
    /*
    CCButton *leftBtn = [CCButton buttonWithTitle:@"上一个" fontName:@"ArialMT" fontSize:20];
    leftBtn.positionType = CCPositionTypeNormalized;
    leftBtn.position = ccp(0.2f, 0.2f);
    [leftBtn setTarget:self selector:@selector(onLastButtonClicked:)];
    CCButton *rightBtn = [CCButton buttonWithTitle:@"下一个" fontName:@"ArialMT" fontSize:20];
    rightBtn.positionType = CCPositionTypeNormalized;
    rightBtn.position = ccp(0.8f, 0.2f);
    [rightBtn setTarget:self selector:@selector(onNextButtonClicked:)];
    */
    train = [[Train alloc] init];
    train = [train create:0.5f ySet:0.3f];
    //train.positionType = CCPositionTypeNormalized;
    //[train setPosition:ccp([train getRow], [train getColumn])];
    
    [self addChild:train z:9];
    
    //[self addChild:leftBtn z:9];
    //[self addChild:rightBtn z:9];
}
/*
-(void)onLastButtonClicked:(id)sender {
    int temp = [Train getCount];
    temp --;
    [Train setCount:temp];
    CCLOG(@"Last Change, Count: %d", [Train getCount]);
    
    [train removeFromParent];
    train = [[Train alloc] init];
    train = [train create:0.5f ySet:0.3f];
    [self addChild:train z:9];
}

-(void)onNextButtonClicked:(id)sender {
    int temp = [Train getCount];
    temp ++;
    [Train setCount:temp];
    CCLOG(@"Next Change, Count: %d", [Train getCount]);
    
    [train removeFromParent];
    train = [[Train alloc] init];
    train = [train create:0.5f ySet:0.3f];
    [self addChild:train z:9];
}
*/
#pragma mark--------------------------------------------------------------
#pragma mark - Touch Handler
#pragma mark--------------------------------------------------------------

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
    /*
    CGPoint touchLocation = [touch locationInNode:self];
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    
    // 通过View坐标去转换成Node坐标
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint tranLoc = ccpSub(touchLocation, oldTouchLocation);
    
    //  当在下方滑动，用来判断滑动方向
    
    if (touchLocation.y < self.viewSize.height / 2) {
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
     */
    //CCLOG(@"tranLoc: %@", NSStringFromCGPoint(tranLoc));
    //CCLOG(@"tranLoc.x: %f, tranLoc.y: %f", tranLoc.x, tranLoc.y);
    CCLOG(@"touchMoved!");
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint endPoint = [touch locationInNode:self];
    if (self.isMoved) {
        CGPoint tranLoc = ccpSub(endPoint, self.beganPoint);
        CCLOG(@"tranloc: %@", NSStringFromCGPoint(tranLoc));
        if (self.beganPoint.y < self.viewSize.height / 2) {
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

-(void)changeSpriteStyle {
    [newTrain removeFromParent];
    newTrain = [[Train alloc] init];
    newTrain = [newTrain create:0.5f ySet:0.8f];
    
    [self addChild:newTrain z:9];
}

-(void)onRightTouchSlide {
    int temp = [Train getCount];
    temp ++;
    if (temp >= 3) {
        temp = 0;
    }
    [Train setCount:temp];
    CCLOG(@"Next Change, Count: %d", [Train getCount]);
    
    //CCAction *rightMove = [CCActionMoveBy actionWithDuration:2.0f position:CGPointMake(50.0, 0)];
    //CCAction *spriteFadeOut = [CCActionFadeOut actionWithDuration:2.0f];
    //CCAction *rightAction = [CCActionSpawn actionWithArray:@[rightMove, spriteFadeOut]];
    //[train runAction:rightMove];
    
    [train removeFromParent];
    train = [[Train alloc] init];
    train = [train create:0.5f ySet:0.3f];
    [self addChild:train z:9];
}

-(void)onLeftTouchSlide {
    int temp = [Train getCount];
    temp --;
    if (temp < 0) {
        temp = 2;
    }
    [Train setCount:temp];
    CCLOG(@"Last Change, Count: %d", [Train getCount]);
    
    [train removeFromParent];
    train = [[Train alloc] init];
    train = [train create:0.5f ySet:0.3f];
    [self addChild:train z:9];
}
@end





