//
//  SecondScene.m
//
//  Created by : Mac
//  Project    : MMXTH
//  Date       : 16/9/17
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


// -----------------------------------------------------------------

@implementation SecondScene

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
    CCSprite9Slice *BackGround = [CCSprite9Slice spriteWithImageNamed:@"timeField.png"];
    BackGround.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
    BackGround.scaleX = self.contentSize.width/BackGround.contentSize.width;
    BackGround.scaleY = self.contentSize.height/BackGround.contentSize.height;

    [self addChild:BackGround];
    
    
    // BackButton
    CCButton *backButton = [CCButton buttonWithTitle:@"Back" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]];
    [backButton setTarget:self selector:@selector(onBackButtonClicked:)];
 
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.50f, 0.10f);
    backButton.color=[CCColor redColor];

    
    // CGSize screenSize = [CCDirector sharedDirector].viewSize;
    [backButton setPosition:ccp(0.15f, 0.85f)];
    
    [self addChild:backButton z:9];
  
    
    train = [[Train alloc] init];
    train = [train create:0.5f ySet:0.15f];
    //train.positionType = CCPositionTypeNormalized;
    //[train setPosition:ccp([train getRow], [train getColumn])];
    
    [self addChild:train z:9];
    
    [self insideScene];
}
// -----------------------------------------------------------------

- (void)onBackButtonClicked:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[FirstScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
}

-(void)insideScene {
    CCButton *leftBtn = [CCButton buttonWithTitle:@"上一个" fontName:@"ArialMT" fontSize:20];
    leftBtn.positionType = CCPositionTypeNormalized;
    leftBtn.position = ccp(0.2f, 0.15f);
    leftBtn.color=[CCColor blackColor];
    [leftBtn setTarget:self selector:@selector(onLastButtonClicked:)];
    CCButton *rightBtn = [CCButton buttonWithTitle:@"下一个" fontName:@"ArialMT" fontSize:20];
    rightBtn.positionType = CCPositionTypeNormalized;
    rightBtn.position = ccp(0.8f, 0.15f);
    rightBtn.color=[CCColor blackColor];
    [rightBtn setTarget:self selector:@selector(onNextButtonClicked:)];
    
    [self addChild:leftBtn z:9];
    [self addChild:rightBtn z:9];
}

-(void)onLastButtonClicked:(id)sender {
    int temp = [Train getCount];
    temp --;
    if(temp<0)
        temp=3;
    [Train setCount:temp];
    CCLOG(@"Last Change, Count: %d", [Train getCount]);
    
    [train removeFromParent];
    train = [[Train alloc] init];
    train = [train create:0.5f ySet:0.15f];
    [self addChild:train z:9];
}

-(void)onNextButtonClicked:(id)sender {
    int temp = [Train getCount];
    temp ++;
    if(temp>2)
        temp=0;
    [Train setCount:temp];
    CCLOG(@"Next Change, Count: %d", [Train getCount]);
    
    [train removeFromParent];
    train = [[Train alloc] init];
    train = [train create:0.5f ySet:0.15f];
    [self addChild:train z:9];
}

#pragma mark--------------------------------------------------------------
#pragma mark - Touch Handler
#pragma mark--------------------------------------------------------------

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    // 获取点击坐标
    CGPoint touchLocation = [touch locationInNode:self];
    CCLOG(@"touchBegan!");
    //CCLOG(@"Location:%@", NSStringFromCGPoint(touchLocation));
    [self spriteSelectedOrNot:touchLocation];
}

-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CCLOG(@"touchMoved!");
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
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
    newTrain = [newTrain create:0.5f ySet:0.6f];
    
    [self addChild:newTrain z:9];
}
@end




