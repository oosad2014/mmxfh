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
static id move;
static BOOL selOrNot = YES;
// -----------------------------------------------------------------

@implementation TestTrackScene

@synthesize posArray;
@synthesize node;
@synthesize trackVertical;
@synthesize trackHorizontal;
@synthesize otherGoods;
@synthesize trackNowArray;
@synthesize trackArray;

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
    
    _dataManager = [DataManager sharedManager]; // 获取单例
    
//    CCTexture * texture=[CCTexture textureWithFile:@"dead.png"];
//    CCTexture * texture1=[CCTexture textureWithFile:@"button.png"];
    
    otherGoods = [CCTexture textureWithFile:@"树2.png"];
    trackVertical = [CCTexture textureWithFile:@"铁轨横向.png"];
    trackHorizontal = [CCTexture textureWithFile:@"铁轨竖直.png"];
    
    // 全部铁轨格子
    trackArray = [NSMutableArray arrayWithCapacity:10]; // 10 * 10网格
    for (int i=0; i<10; i++) {
        NSMutableArray *internArray = [NSMutableArray arrayWithCapacity:10];
        for (int j=0; j<10; j++) {
            [internArray addObject:[NSValue valueWithCGPoint:CGPointMake([self Floor:0.05 + i * 0.1 Pcs:2], [self Floor:0.05 + j * 0.1 Pcs:2])]];
        }
        
        [trackArray addObject:internArray];
    }
    
    // 当前已铺铁轨
    trackNowArray = [NSMutableArray arrayWithCapacity:10];
    for (int i=0; i<9; i++) {
        [trackNowArray addObject:[NSValue valueWithCGPoint:CGPointMake(0.05f + i * 0.1f, 0.45f)]];
    }
    
    // 放置树
    CCSprite *tree1 = [CCSprite spriteWithTexture:otherGoods];
    [tree1 setScaleX:self.contentSize.width * 0.1 / tree1.boundingBox.size.width];
    [tree1 setScaleY:self.contentSize.height * 0.2 / tree1.boundingBox.size.height];
    [tree1 setPositionType:CCPositionTypeNormalized];
    [tree1 setPosition:CGPointMake(0.3f, 0.2f)];
    [self addChild:tree1 z:12];
    
    CCSprite *tree2 = [CCSprite spriteWithTexture:otherGoods];
    [tree2 setScaleX:self.contentSize.width * 0.1 / tree2.boundingBox.size.width];
    [tree2 setScaleY:self.contentSize.height * 0.2 / tree2.boundingBox.size.height];
    [tree2 setPositionType:CCPositionTypeNormalized];
    [tree2 setPosition:CGPointMake(0.4f, 0.1f)];
    [self addChild:tree2 z:12];
    
    CCSprite *tree3 = [CCSprite spriteWithTexture:otherGoods];
    [tree3 setScaleX:self.contentSize.width * 0.1 / tree3.boundingBox.size.width];
    [tree3 setScaleY:self.contentSize.height * 0.2 / tree3.boundingBox.size.height];
    [tree3 setPositionType:CCPositionTypeNormalized];
    [tree3 setPosition:CGPointMake(0.8f, 0.5f)];
    [self addChild:tree3 z:12];
    
//    CCSprite *track1 = [CCSprite spriteWithTexture:trackVertical];
//    [track1 setScaleX:self.contentSize.width * 0.1 / track1.boundingBox.size.width];
//    [track1 setScaleY:self.contentSize.height * 0.1 / track1.boundingBox.size.height];
//    [track1 setPositionType:CCPositionTypeNormalized];
//    [track1 setPosition:CGPointMake(0.15f, 0.15f)];
//    [self addChild:track1 z:10];
//    
//    CCSprite *track2 = [CCSprite spriteWithTexture:trackVertical];
//    [track2 setScaleX:self.contentSize.width * 0.1 / track2.boundingBox.size.width];
//    [track2 setScaleY:self.contentSize.height * 0.1 / track2.boundingBox.size.height];
//    [track2 setPositionType:CCPositionTypeNormalized];
//    [track2 setPosition:CGPointMake(0.25f, 0.15f)];
//    [self addChild:track2 z:10];
 
// 此处为判断
//    Trainup=[[TrainHead alloc] init];
//    Trainup=[Trainup create:0.5f ySet:0.60f];
//    [Trainup setTexture:texture];
//    [Trainup setVisible:0];
//    [self addChild:Trainup z:2];
//    
//    traindown=[[TrainHead alloc] init];
//    traindown=[ traindown create:0.5f ySet:0.40f];
//    [traindown setTexture:texture];
//    [traindown setVisible:0];
//    [self addChild:traindown z:2];
//    
//    Checkpoint=[[TrainHead alloc] init];
//    Checkpoint=[Checkpoint create:0.5 ySet:0.5];
//    [Checkpoint setTexture:texture1];
//    [Checkpoint setScaleX:1.5];
//    [self addChild:Checkpoint z:2];
    
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
    {   [trainhead stopAction:move];
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
// 此枚举用于判断铁轨在中心点的区域
typedef enum _PosFromCoordinate {
    LeftUp = 0,
    LeftDown,
    RightUp,
    RightDown
} PosFromCoordinate;

// 此结构用于判断中心点位置
struct Coordinates {
    int x;
    int y;
};

// 取小数点后几位
- (double)Floor:(double)num Pcs:(int)pcs {
    return floor(num * pow(10, pcs)) / pow(10, pcs);
}

- (struct Coordinates)getCoordinate:(CGPoint)touchPos {
    struct Coordinates coor;
    CGPoint posManaged = CGPointMake(
                                     [self Floor:(touchPos.x / self.contentSize.width) Pcs:1],
                                     [self Floor:(touchPos.y / self.contentSize.height) Pcs:1]
                                     );
    
    coor.x = posManaged.x * 10;
    coor.y = posManaged.y * 10;
    
    return coor;
}


- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CCLOG(@"[Log] touchBegin");
    CGPoint beginPos = [touch locationInNode:self];
    CCLOG(@"[Log] Begin Pos ----> %@", NSStringFromCGPoint(beginPos));
    // 手绘用，暂时屏蔽
//    struct Coordinates coor = [self getCoordinate:beginPos];
//    [trackNowArray addObject:trackArray[coor.x][coor.y]];
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
    
    //[self drawLine:oldPos PrevPoint: nowPos]; // 连接所有的相邻点
    
    if (selOrNot) {
        [posArray addObject:[NSValue valueWithCGPoint:nowPos]];
    }
    // 手绘用，暂时屏蔽
//    struct Coordinates coor = [self getCoordinate:nowPos];
//    [trackNowArray addObject:trackArray[coor.x][coor.y]];
    
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
//        [trainhead stopAllActions];
//        [trainhead removeFromParentAndCleanup:YES];
//        trainhead = [CCSprite spriteWithImageNamed:@"train.png"];
//        [trainhead setPositionType:CCPositionTypeNormalized];
//        CGPoint trainPos = [[posArray objectAtIndex:0] CGPointValue];
//        trainPos.x = trainPos.x / self.contentSize.width;
//        trainPos.y = trainPos.y / self.contentSize.height;
//        [trainhead setPosition:trainPos];
//        [self addChild:trainhead z:9];
//
//        CGPoint lastPos = [[posArray objectAtIndex:0] CGPointValue];
//        CGPoint nowPos;
//        NSMutableArray *actionArray = [NSMutableArray arrayWithCapacity:[posArray count]-1];
//        for (int i=1; i<[posArray count]; i++) {
//            nowPos = [[posArray objectAtIndex:i] CGPointValue];
//            CGPoint move = ccpSub(nowPos , lastPos);
//            move.x /= self.contentSize.width;
//            move.y /= self.contentSize.height;
//            id moveBy = [CCActionMoveBy actionWithDuration:(ccpDistance(nowPos, lastPos) / FAST) position:move];
//            [actionArray addObject:[moveBy copy]];
//            lastPos = nowPos;
//        }
//        move = [CCActionSequence actionWithArray:actionArray]; // 连接所有的动作
//        [trainhead runAction:move]; // 跑动的，暂时屏蔽
        [posArray removeAllObjects]; // 重置数组
    } else {
        CCLOG(@"[Log] Disvisible");
            [self spriteSelectedOrNot:endPos];
    }
    
    // 铺铁轨
    for (int i=0; i<[trackNowArray count]; i++) {
        CCSprite *track = [CCSprite spriteWithTexture:trackVertical];
        [track setScaleX:self.contentSize.width * 0.1 / track.boundingBox.size.width];
        [track setScaleY:self.contentSize.height * 0.1 / track.boundingBox.size.height];
        [track setPositionType:CCPositionTypeNormalized];
        [track setPosition:[trackNowArray[i] CGPointValue]];
        [self addChild:track z:10];
    }
    
    CCSprite *trainStart = [self getTrainFromFile];
    [trainStart setScaleX:self.contentSize.width * 0.1 / trainStart.boundingBox.size.width];
    [trainStart setScaleY:self.contentSize.height * 0.1 / trainStart.boundingBox.size.height];
    [trainStart setPositionType:CCPositionTypeNormalized];
    [trainStart setPosition:CGPointMake(0.05f, 0.5f)]; // 火车在整数上跑，铁轨在.5f上铺
    [self addChild:trainStart z:11];
    
    CGPoint lastPos = [[trackNowArray objectAtIndex:0] CGPointValue];
    CGPoint nowPos;
    NSMutableArray *actionArray = [NSMutableArray arrayWithCapacity:[trackNowArray count]-1];
    for (int i=1; i<[trackNowArray count]; i++) {
        nowPos = [[trackNowArray objectAtIndex:i] CGPointValue];
        CGPoint move = ccpSub(nowPos , lastPos);
        id moveBy = [CCActionMoveBy actionWithDuration:0.2f position:move];
        [actionArray addObject:[moveBy copy]];
        lastPos = nowPos;
    }
    move = [CCActionSequence actionWithArray:actionArray]; // 连接所有的动作
    [trainStart runAction:move];
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

- (CCSprite *)getTrainFromFile {
    NSDictionary *dic = [_dataManager documentDicWithName:@"TrainNow"];
    CCSprite *train = [CCSprite spriteWithImageNamed:[dic objectForKey:@"TrainSelected"]];
    return train;
}

//选择向下
-(void)setmove1
{
    
    [trainhead setPosition:CGPointMake(0.55,0.47)];
    move=[CCActionMoveBy actionWithDuration:4 position:CGPointMake(0.2, -0.4)];

    [trainhead runAction:move];
    selOrNot = YES;
}
//选择向上
-(void)setmove2
{
    [trainhead setPosition:CGPointMake(0.55,0.53)];
    move=[CCActionMoveBy actionWithDuration:4 position:CGPointMake(0.2, 0.4)];
    
    [trainhead runAction:move];
    selOrNot = YES;
    
}
// -----------------------------------------------------------------

@end





