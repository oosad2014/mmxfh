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

//#define LEFT 0
//#define RITHT 1

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
    self.viewSize = [CCDirector sharedDirector].viewSize;
    self.userInteractionEnabled = YES; // 注册触屏事件
    // 暂时不知道为什么必须定义一个CCNodeColor才能使用触屏功能
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:27.0f/255.0f green:185.0f/255.0f blue:239.0f/255.0f alpha:1.0f]];
    [self addChild:background];
    
    sceneHeadNow = 1; // 默认为第一页
    sceneTrackNow = 1;
    sceneGoodsNow = 1;
    spriteSelected = NO; // 默认没有东西选中
    
    // Head
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
    
    // Goods
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
    
    // PlayButton
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
    
    boxHead = [CCSprite spriteWithImageNamed:@"white_square.png"];
    self.boxHead.positionType = CCPositionTypeNormalized;
    [self.boxHead setPosition:ccp(0.35f, 0.8f)];
    [self addChild:self.boxHead z:8];
    
    boxGoods = [CCSprite spriteWithImageNamed:@"white_square.png"];
    self.boxGoods.positionType = CCPositionTypeNormalized;
    [self.boxGoods setPosition:ccp(0.5f, 0.85f)];
    [self addChild:self.boxGoods z:8];
    
    boxTrack = [CCSprite spriteWithImageNamed:@"white_square.png"];
    self.boxTrack.positionType = CCPositionTypeNormalized;
    [self.boxTrack setPosition:ccp(0.5f, 0.6f)];
    [self addChild:self.boxTrack z:8];
}
// -----------------------------------------------------------------

- (void)onBackButtonClicked:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[FirstScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
}

- (void)onPlayButtonClicked:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[TestTrainScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
}

-(void)insideTrainHeadScene {
    [self removeTrainGoodsScene];
    [trainGoodsBtn setEnabled:YES];
    [self removeTrackScene];
    [trackBtn setEnabled:YES];
    trainNow = train_Head; // 当前为Head选择页面
    CCAction *fadeIn = [CCActionFadeIn actionWithDuration:1.0f];
    for (TrainHead *head in trainHeadArray) {
        [self addChild:head z:9];
        [head runAction:[fadeIn copy]];
    }
    [trainHeadBtn setEnabled:NO];
}

-(void)insideTrainGoodsScene {
    [self removeTrainHeadScene];
    [trainHeadBtn setEnabled:YES];
    [self removeTrackScene];
    [trackBtn setEnabled:YES];
    trainNow = train_Goods; // 当前为Goods选择页面
    CCAction *fadeIn = [CCActionFadeIn actionWithDuration:1.0f];
    for (TrainGoods *goods in trainGoodsArray) {
        [self addChild:goods z:9];
        [goods runAction:[fadeIn copy]];
    }
    [trainGoodsBtn setEnabled:NO];
}

-(void)insideTrackScene {
    [self removeTrainGoodsScene];
    [trainGoodsBtn setEnabled:YES];
    [self removeTrainHeadScene];
    [trainHeadBtn setEnabled:YES];
    trainNow = train_Track; // 当前为Track选择页面
    CCAction *fadeIn = [CCActionFadeIn actionWithDuration:1.0f];
    for (Track *track in trackArray) {
        [self addChild:track z:9];
        [track runAction:[fadeIn copy]];
    }
    [trackBtn setEnabled:NO];
}

-(void)removeTrainHeadScene {
    for (TrainHead *head in trainHeadArray) {
        [head removeFromParent];
    }
}

-(void)removeTrainGoodsScene {
    for (TrainGoods *goods in trainGoodsArray) {
        [goods removeFromParent];
    }
}

-(void)removeTrackScene {
    for (Track *track in trackArray) {
        [track removeFromParent];
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
    
    CCAction *action = [CCActionMoveBy actionWithDuration:0.0f position:tranLoc];
    
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
    
    CCLOG(@"touchMoved!");
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint endPoint = [touch locationInNode:self];
    if (self.isMoved) {
        CGPoint tranLoc = ccpSub(endPoint, self.beganPoint);
        //CCLOG(@"tranloc: %@", NSStringFromCGPoint(tranLoc));
        BOOL getOfMove = NO;
        
        // Actions
        CCAction *moveEnd = [CCActionMoveTo actionWithDuration:0 position:self.boxHead.position];
        CCAction *little = [CCActionScaleTo actionWithDuration:0 scale:1.0f];
        CCAction *remove = [CCActionRemove action];
        CCAction *onSel = [CCActionCallFunc actionWithTarget:self selector:@selector(onSpriteForSel)];
        CCAction * action = [CCActionSequence actionWithArray:@[moveEnd, little, remove, onSel]];
        
        switch (trainNow) {
            case train_Head:
                if ([self spriteGetOrNot:endPoint]) {
                    CCLOG(@"Head Get!");
                    getOfMove = YES;
                    selTrainHead= [selTrainHead createWithExists:newTrainHead];
                    spriteSelected = NO;
                    CCLOG(@"spriteSelect: NO!");
                    [newTrainHead runAction:[action copy]];
                }
                else {
                    [newTrainHead removeFromParent];
                    spriteSelected = NO;
                    CCLOG(@"spriteSelect: NO!");
                }
                break;
            case train_Goods:
                if ([self spriteGetOrNot:endPoint]) {
                    CCLOG(@"Goods Get!");
                    getOfMove = YES;
                    selTrainGoods = [selTrainGoods createWithExists:newTrainGoods];
                    spriteSelected = NO;
                    CCLOG(@"spriteSelect: NO!");
                    [newTrainGoods runAction:[action copy]];
                }
                else {
                    [newTrainGoods removeFromParent];
                    spriteSelected = NO;
                    CCLOG(@"spriteSelect: NO!");
                }
                break;
            case train_Track:
                if ([self spriteGetOrNot:endPoint]) {
                    CCLOG(@"Track Get!");
                    getOfMove = YES;
                    selTrainTrack = [selTrainTrack createWithExists:newTrainTrack];
                    spriteSelected = NO;
                    CCLOG(@"spriteSelect: NO!");
                    [newTrainTrack runAction:[action copy]];
                }
                else {
                    [newTrainTrack removeFromParent];
                    spriteSelected = NO;
                    CCLOG(@"spriteSelect: NO!");
                }
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
    switch (trainNow) {
        case train_Head:
            for (TrainHead *head in trainHeadArray) {
                if (CGRectContainsPoint(head.boundingBox, posSelected)) {
                    spriteSelected = YES; // 设置有精灵选中，可以进行接下来的操作
                    CCLOG(@"spriteSelect: YES");
                    CCLOG(@"火车头已选择%@图片！", head);
                    newTrainHead = [newTrainHead createWithExists:head];
                    [self addChild:newTrainHead z:10];
                    
                    CCAction *bigger = [CCActionScaleTo actionWithDuration:0 scale:1.2f];
                    [newTrainHead runAction:bigger];
                    
                    break;
                }
            }
            break;
        case train_Goods:
            for (TrainGoods *goods in trainGoodsArray) {
                if (CGRectContainsPoint(goods.boundingBox, posSelected)) {
                    spriteSelected = YES; // 设置有精灵选中，可以进行接下来的操作
                    CCLOG(@"spriteSelect: YES");
                    CCLOG(@"火车货物已选择%@图片！", goods);
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
                    spriteSelected = YES; // 设置有精灵选中，可以进行接下来的操作
                    CCLOG(@"spriteSelect: YES");
                    CCLOG(@"火车铁轨已选择%@图片！", track);
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

-(void)onRightTouchSlide {
    switch (trainNow) {
        case train_Head:
            if (sceneHeadNow > 1) {
                CCAction *moveRight = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(1.0f, 0)];
                for (TrainHead *head in trainHeadArray) {
                    [head runAction:[moveRight copy]];
                }
                sceneHeadNow -= 1;
                CCLOG(@"scene: %d", sceneHeadNow);
            }
            break;
        case train_Goods:
            if (sceneGoodsNow > 1) {
                CCAction *moveRight = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(1.0f, 0)];
                for (TrainGoods *goods in trainGoodsArray) {
                    [goods runAction:[moveRight copy]];
                }
                sceneGoodsNow -= 1;
                CCLOG(@"scene: %d", sceneGoodsNow);
            }
            break;
        case train_Track:
            if (sceneTrackNow > 1) {
                CCAction *moveRight = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(1.0f, 0)];
                for (Track *track in trackArray) {
                    [track runAction:[moveRight copy]];
                }
                sceneTrackNow -= 1;
                CCLOG(@"scene: %d", sceneTrackNow);
            }
            break;
        default:
            break;
    }
}

-(void)onLeftTouchSlide {
    switch (trainNow) {
        case train_Head:
            if ([trainHeadArray count] % 3 == 0 && sceneHeadNow < [trainHeadArray count] / 3) {
                CCAction *moveLeft = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(-1.0f, 0)];
                for (TrainHead *head in trainHeadArray) {
                    [head runAction:[moveLeft copy]];
                }
                sceneHeadNow += 1;
                CCLOG(@"scene: %d", sceneHeadNow);
            }
            else if ([trainHeadArray count] % 3 != 0 && sceneHeadNow <= [trainHeadArray count] / 3) {
                CCAction *moveLeft = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(-1.0f, 0)];
                for (TrainHead *head in trainHeadArray) {
                    [head runAction:[moveLeft copy]];
                }
                sceneHeadNow += 1;
                CCLOG(@"scene: %d", sceneHeadNow);
            }
            break;
        case train_Goods:
            if ([trainGoodsArray count] % 3 == 0 && sceneGoodsNow < [trainGoodsArray count] / 3) {
                CCAction *moveLeft = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(-1.0f, 0)];
                for (TrainGoods *goods in trainGoodsArray) {
                    [goods runAction:[moveLeft copy]];
                }
                sceneHeadNow += 1;
                CCLOG(@"scene: %d", sceneHeadNow);
            }
            else if ([trainGoodsArray count] % 3 != 0 && sceneGoodsNow <= [trainGoodsArray count] / 3) {
                CCAction *moveLeft = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(-1.0f, 0)];
                for (TrainGoods *goods in trainGoodsArray) {
                    [goods runAction:[moveLeft copy]];
                }
                sceneGoodsNow += 1;
                CCLOG(@"scene: %d", sceneGoodsNow);
            }
            break;
        case train_Track:
            if ([trackArray count] % 3 == 0 && sceneTrackNow < [trackArray count] / 3) {
                CCAction *moveLeft = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(-1.0f, 0)];
                for (Track *track in trackArray) {
                    [track runAction:[moveLeft copy]];
                }
                sceneTrackNow += 1;
                CCLOG(@"scene: %d", sceneTrackNow);
            }
            else if ([trackArray count] % 3 != 0 && sceneTrackNow <= [trackArray count] / 3) {
                CCAction *moveLeft = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(-1.0f, 0)];
                for (Track *track in trackArray) {
                    [track runAction:[moveLeft copy]];
                }
                sceneTrackNow += 1;
                CCLOG(@"scene: %d", sceneTrackNow);
            }
            break;
        default:
            break;
    }
}

-(BOOL)spriteGetOrNot:(CGPoint)pos {
    CGPoint posEnd = pos;
    if (!spriteSelected) {
        return NO;
    }
    switch (trainNow) {
        case train_Head:
            if (CGRectContainsPoint(boxHead.boundingBox, posEnd)) {
                CCLOG(@"火车头已到达boxHead！");
                boxHead.opacity = 0; // 隐藏
                [selTrainHead removeFromParent];
                return YES;
            }
            break;
        case train_Goods:
            if (CGRectContainsPoint(boxGoods.boundingBox, posEnd)) {
                CCLOG(@"火车货物已到达boxHead！");
                boxGoods.opacity = 0; // 隐藏
                [selTrainGoods removeFromParent];
                return YES;
            }
            break;
        case train_Track:
            if (CGRectContainsPoint(boxTrack.boundingBox, posEnd)) {
                CCLOG(@"火车铁轨已到达boxHead！");
                boxTrack.opacity = 0; // 隐藏
                [selTrainTrack removeFromParent];
                return YES;
            }
            break;
        default:
            break;
    }
    return NO;
}

-(void)onSpriteForSel {
    switch (trainNow) {
        case train_Head:
            [selTrainHead setRow:boxHead.position.x];
            [selTrainHead setColumn:boxHead.position.y];
            [selTrainHead setPosition:[boxHead position]];
            
            [self addChild:selTrainHead z:9];
            CCLOG(@"selTrainHead Set!");
            break;
        case train_Goods:
            [selTrainGoods setRow:boxGoods.position.x];
            [selTrainGoods setColumn:boxGoods.position.y];
            [selTrainGoods setPosition:[boxGoods position]];
            
            [self addChild:selTrainGoods z:9];
            CCLOG(@"selTrainGoods Set!");
            break;
        case train_Track:
            [selTrainTrack setRow:boxTrack.position.x];
            [selTrainTrack setColumn:boxTrack.position.y];
            [selTrainTrack setPosition:[boxTrack position]];
            
            [self addChild:selTrainTrack z:9];
            CCLOG(@"selTrainTrack Set!");
            break;
        default:
            break;
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

+ (TrainHead *)getTrainHeadSel {
    return selTrainHead;
}

+ (TrainGoods *)getTrainGoodsSel {
    return selTrainGoods;
}

+ (Track *)getTrackSel {
    return selTrainTrack;
}

@end

