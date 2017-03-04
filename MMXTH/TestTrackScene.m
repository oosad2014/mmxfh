//
//  TestTrackScene.m
//
//  Created by : mac
//  Project    : MMXTH
//  Date       : 16/11/23
//
//  Copyright (c) 2016年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "TestTrackScene.h"
#import "Train.h"
#import "TrainHead.h"
#import "TrainGoods.h"

#define FAST 250
#define NORMAL 50
#define SLOW 10

static CGPoint trainPoint;
static id move2;

static BOOL selOrNot = YES;
// -----------------------------------------------------------------

@implementation TestTrackScene

@synthesize posArray;
@synthesize node;

// -----------------------------------------------------------------

+ (id)scene {
    return [[self alloc] init];
}

- (TestTrackScene *)init {
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    CCNodeColor *bg = [CCNodeColor nodeWithColor:[CCColor blackColor]];
    [self addChild:bg];
    
    [self setUserInteractionEnabled:YES]; // 触屏
    [self setMultipleTouchEnabled:YES]; // 多点触控
    
    
    CCTexture * texture=[CCTexture textureWithFile:@"dead.png"];
    CCTexture * texture1=[CCTexture textureWithFile:@"button.png"];
    
    Trainup=[[TrainHead alloc] init];
    Trainup=[Trainup create:0.5f ySet:0.60f];
    [Trainup setTexture:texture];
    [Trainup setVisible:0];
    [self addChild:Trainup z:2];
    
    traindown=[[TrainHead alloc] init];
    traindown=[ traindown create:0.5f ySet:0.40f];
    [traindown setTexture:texture];
    [traindown setVisible:0];
    [self addChild:traindown z:2];
    
    Checkpoint=[[TrainHead alloc] init];
    Checkpoint=[Checkpoint create:0.5 ySet:0.5];
    [Checkpoint setTexture:texture1];
    [Checkpoint setScaleX:1.5];
    [self addChild:Checkpoint z:2];
    
    posArray = [NSMutableArray arrayWithCapacity: 0]; // 初始化可变数组
    
    [self schedule:@selector (updatetrain) interval:0.01];
    [self schedule:@selector (judgehead) interval:0.05];
    [self initScene];
    return self;
}

- (void)initScene {
    
    CCSprite *background = [CCSprite spriteWithImageNamed:@"backGround.png"]; // 通过纹理建立背景
    [background setPosition:ccp(0.5f, 0.5f)];
    [background setPositionType:CCPositionTypeNormalized];
    [background setScale:self.contentSize.width / background.contentSize.width];
    [self addChild:background z:1];
     
    self.node = [CCDrawNode node]; // 初始化绘画节点
    [self addChild:self.node z:10];
}

- (void)drawLine: (CGPoint)curPoint PrevPoint: (CGPoint)prevPoint {
    float lineWidth = 2.0; // 画笔线宽
    
    [node drawSegmentFrom:curPoint to:prevPoint radius:lineWidth color:[CCColor redColor]]; // 画直线
}


//进入车站的时显示上下选择和隐藏火车
-(void) judgehead
{
    if ((trainPoint.x-[Checkpoint position].x<0.05)&&(trainPoint.x-[Checkpoint position].x>-0.05)&&(trainPoint.x-[Checkpoint position].y<0.05)&&(trainPoint.y-[Checkpoint position].y>-0.05))
    {   [trainhead stopAction:move2];
        [trainhead setVisible:0];
        [Trainup setVisible:1];
        [traindown setVisible:1];
        selOrNot = NO;
    }
    else{
        [trainhead setVisible:1];
        [Trainup setVisible:0];
        [traindown setVisible:0];
    }
}
//日常更新位置
-(void) updatetrain
{
    trainPoint=[trainhead position];
}


#pragma mark--------------------------------------------------------------
#pragma mark - Touch Handler
#pragma mark--------------------------------------------------------------

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CCLOG(@"[Log] touchBegin");
    CGPoint beginPos = [touch locationInNode:self];
    CCLOG(@"[Log] Begin Pos ----> %@", NSStringFromCGPoint(beginPos));
    if (selOrNot) {
        [posArray addObject: [NSValue valueWithCGPoint:beginPos]]; // 将CGPoint转换成NSValue储存到数组中
    }
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CCLOG(@"[Log] touchMove");
    CGPoint nowPos = [touch locationInNode:self]; // 获取当前坐标
    
    CGPoint oldPos = [touch previousLocationInView:touch.view]; // 获取上一次点的坐标（基于View）
    oldPos = [[CCDirector sharedDirector] convertToGL:oldPos];
    oldPos = [self convertToNodeSpace:oldPos];
    
    [self drawLine:oldPos PrevPoint: nowPos]; // 连接所有的相邻点
    
    if (selOrNot) {
        [posArray addObject:[NSValue valueWithCGPoint:nowPos]];
    }
    
    CCLOG(@"[Log] oldPos: %@", NSStringFromCGPoint(oldPos));
    CCLOG(@"[Log] nowPos: %@", NSStringFromCGPoint(nowPos));
}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CCLOG(@"[Log] touchEnd");
    CGPoint endPos = [touch locationInNode:self];
    CCLOG(@"[Log] End Pos ----> %@", NSStringFromCGPoint(endPos));
    
    if (selOrNot) {
        CCLOG(@"[Log] Visible");
        [posArray addObject: [NSValue valueWithCGPoint:endPos]]; // 将CGPoint转换成NSValue储存到数组中(可不要)
        [trainhead stopAllActions];
        [trainhead removeFromParentAndCleanup:YES];
        trainhead = [CCSprite spriteWithImageNamed:@"火车车厢.png"];
        [trainhead setScaleX:0.01];
        [trainhead setScaleY:0.01];
        [trainhead setPositionType:CCPositionTypeNormalized];
        CGPoint trainPos = [[posArray objectAtIndex:0] CGPointValue];
        trainPos.x = trainPos.x / self.contentSize.width;
        trainPos.y = trainPos.y / self.contentSize.height;
        [trainhead setPosition:trainPos];
        [self addChild:trainhead z:9];
        
        CGPoint lastPos = [[posArray objectAtIndex:0] CGPointValue];
        CGPoint nowPos;
        NSMutableArray *actionArray = [NSMutableArray arrayWithCapacity:[posArray count]-1];
        for (int i=1; i<[posArray count]; i++) {
            nowPos = [[posArray objectAtIndex:i] CGPointValue];
            CGPoint move1 = ccpSub(nowPos , lastPos);
            move1.x /= self.contentSize.width;
            move1.y /= self.contentSize.height;
            id moveBy = [CCActionMoveBy actionWithDuration:(ccpDistance(nowPos, lastPos) / FAST) position:move1];
            [actionArray addObject:[moveBy copy]];
            lastPos = nowPos;
        }
        move2 = [CCActionSequence actionWithArray:actionArray]; // 连接所有的动作
        [trainhead runAction:move2];
        [posArray removeAllObjects]; // 重置数组
    } else {
        CCLOG(@"[Log] Disvisible");
            [self spriteSelectedOrNot:endPos];
    }
}

- (void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CCLOG(@"[Log] touchCancel");
    
}



// 此函数用来确认火车图片被选择，并进行相应操作
-(void)spriteSelectedOrNot:(CGPoint)pos {
    CGPoint posSelected = pos;
    if (CGRectContainsPoint(traindown.boundingBox, posSelected)) {
        CCLOG(@"[Log] 火车已选择下！");
        
        [self setmove1];
    }
    if (CGRectContainsPoint(Trainup.boundingBox, posSelected)) {
        CCLOG(@"[Log] 火车已选择上");
        [self setmove2];
    }
}

//选择向下
-(void)setmove1
{
    
    [trainhead setPosition:CGPointMake(0.55,0.47)];
    move2=[CCActionMoveBy actionWithDuration:4 position:CGPointMake(0.2, -0.4)];

    [trainhead runAction:move2];
    selOrNot = YES;
}
//选择向上
-(void)setmove2
{
    [trainhead setPosition:CGPointMake(0.55,0.53)];
    move2=[CCActionMoveBy actionWithDuration:4 position:CGPointMake(0.2, 0.4)];
    
    [trainhead runAction:move2];
    selOrNot = YES;
    
}
// -----------------------------------------------------------------

@end





