//
//  Newtest.m
//
//  Created by : dpc
//  Project    : MMXTH
//  Date       : 17/3/4
//
//  Copyright (c) 2017年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "Newtest.h"
#import "Train.h"
#import "TrainHead.h"
#import "TrainGoods.h"
#import "Track.h"
#import "PauseScene.h"


// -----------------------------------------------------------------

@implementation Newtest

static CGPoint trainPoint;
static id move2;

static BOOL selOrNot = YES;
@synthesize pauseLayer;


@synthesize pauseButton;
@synthesize pauseTexture;

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

- (Newtest *)init {
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    
    CCNodeColor *bg = [CCNodeColor nodeWithColor:[CCColor blackColor]];
    
    pauseLayer =  [CCNodeColor nodeWithColor:[CCColor colorWithWhite:1.f alpha:0] width:30 height:30];
    [pauseLayer setPositionType:CCPositionTypeNormalized];
    [pauseLayer setPosition:ccp(0.9f, 0.05f)];
    
    [self addChild:bg z:1];
     [self addChild:pauseLayer z: 2];
    
    [self setUserInteractionEnabled:YES]; // 触屏
    [self setMultipleTouchEnabled:YES]; // 多点触控
    
    //暂停
    pauseLayer =  [CCNodeColor nodeWithColor:[CCColor colorWithWhite:1.f alpha:0] width:30 height:30];
    [pauseLayer setPositionType:CCPositionTypeNormalized];
    [pauseLayer setPosition:ccp(0.9f, 0.05f)];

    
    //纹理素材
    CCTexture * texture1=[CCTexture textureWithFile:@"goal.png"];
    otherGoods = [CCTexture textureWithFile:@"树2.png"];
    trackVertical = [CCTexture textureWithFile:@"铁轨横向.png"];
    trackHorizontal = [CCTexture textureWithFile:@"铁轨竖直.png"];
    //CCTexture * track2=[CCTexture textureWithFile:@"铁轨6.png"];
    
    //铁轨数组
    trackArray = [NSMutableArray arrayWithCapacity:10]; // 10 * 10网格
    for (int i=0; i<10; i++) {
        NSMutableArray *internArray = [NSMutableArray arrayWithCapacity:10];
        for (int j=0; j<10; j++) {
            [internArray addObject:[NSValue valueWithCGPoint:CGPointMake([self Floor:0.05 + i * 0.1 Pcs:2], [self Floor:0.05 + j * 0.1 Pcs:2])]];
        }
        
        [trackArray addObject:internArray];
    }
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
    [tree3 setPosition:CGPointMake(0.8f, 0.6f)];
    [self addChild:tree3 z:12];
    
    //放置终点

    Checkpoint=[[TrainHead alloc] init];
    Checkpoint=[Checkpoint create:0.85 ySet:0.5];
    [Checkpoint setTexture:texture1];
    [Checkpoint setScaleY:2.0f];
    [self addChild:Checkpoint z:2];
    
    //放置铁轨和列车
      posArray = [NSMutableArray arrayWithCapacity: 0]; // 初始化可变数组
    for (int i=0; i<[trackNowArray count]; i++) {
        CCSprite *track = [CCSprite spriteWithTexture:trackVertical];
        [track setScaleX:self.contentSize.width * 0.1 / track.boundingBox.size.width];
        [track setScaleY:self.contentSize.height * 0.1 / track.boundingBox.size.height];
        [track setPositionType:CCPositionTypeNormalized];
        [track setPosition:[trackNowArray[i] CGPointValue]];
        [self addChild:track z:10];
    }
    
   trainhead = [CCSprite spriteWithImageNamed:@"火车车厢.png"];
    [trainhead setScaleX:self.contentSize.width * 0.1 /trainhead.boundingBox.size.width];
    [trainhead  setScaleY:self.contentSize.height * 0.1 / trainhead.boundingBox.size.height];
    [trainhead setPositionType:CCPositionTypeNormalized];
    [trainhead setPosition:CGPointMake(0.05f, 0.5f)]; // 火车在整数上跑，铁轨在.5f上铺
    [self addChild:trainhead z:11];
    
    //位置更新
    [self schedule:@selector (updatetrain) interval:0.01];
    [self schedule:@selector (judgehead) interval:0.05];
    [self initScene];
    
    
    return self;
    /*trainup=[[TrainHead alloc] init];
    trainup=[trainup create:0.5f ySet:0.60f];
    [trainup setTexture:texture];
    [trainup setVisible:0];
    [self addChild:trainup z:2];
    
    traindown=[[TrainHead alloc] init];
    traindown=[ traindown create:0.5f ySet:0.40f];
    [traindown setTexture:texture];
    [traindown setVisible:0];
    [self addChild:traindown z:2];
    
    trainhead = [CCSprite spriteWithImageNamed:@"火车车厢.png"];
    [trainhead setScaleX:0.03];
    [trainhead setScaleY:0.03];
    [trainhead setPositionType:CCPositionTypeNormalized];
    CGPoint trainPos;
    trainPos.x=0.2;
    trainPos.y=0.5;
    [trainhead setPosition:trainPos];
    [self addChild:trainhead z:9];
    */
    
    
    /*winpoint=[[TrainHead alloc] init];
    winpoint=[winpoint create:0.75 ySet:0.9];
    [winpoint setTexture:texture1];
  
    [self addChild:winpoint z:2];
    
    losepoint=[[TrainHead alloc] init];
    losepoint=[losepoint create:0.75 ySet: 0.1];
    [losepoint setTexture:texture1];
    
    [self addChild:losepoint z:2];
    
    Track *track0;
    track0=[[Track alloc] init];
    track0=[track0 create:0.3 ySet:0.455];
    [track0 setTexture:track1];
    [track0 setScaleY:0.35];
    [track0 setScaleX:4.0];
    [self addChild:track0 z:2];
    //Track *track00;
    /*track00=[[Track alloc] init];
    track00=[track00 create:0.5 ySet:0.475];
    [track00 setTexture:track2];
    [track00 setScaleY:0.1];
    [track00 setScaleX:3.0];
    [self addChild:track00 z:2];*/
    
    
    

    
    
}
- (void)initScene {
   /* CCButton *preViewButton=[CCButton buttonWithTitle:@"preview" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]];
    
    [preViewButton setTarget: self selector:@selector(onpreButtonClicked:)];
    preViewButton.positionType = CCPositionTypeNormalized;
    preViewButton.position = ccp(0.85f, 0.85f);
    preViewButton.color=[CCColor redColor];
    
    [self addChild:preViewButton z:2];*/
    
//背景更新
    CCSprite *background = [CCSprite spriteWithImageNamed:@"高仿师姐地图.png"]; // 通过纹理建立背景
    [background setPosition:ccp(0.5f, 0.5f)];
    [background setPositionType:CCPositionTypeNormalized];
    [background setScale:self.contentSize.width / background.contentSize.width];
    [self addChild:background z:1];
    
    self.node = [CCDrawNode node]; // 初始化绘画节点

    
    
   
}

- (void)drawLine: (CGPoint)curPoint PrevPoint: (CGPoint)prevPoint {
    float lineWidth = 2.0; // 画笔线宽
    
    [node drawSegmentFrom:curPoint to:prevPoint radius:lineWidth color:[CCColor redColor]]; // 画直线
}

//终点判定
-(void) judgehead
{
    if ((trainPoint.x-[Checkpoint position].x<0.05)&&(trainPoint.x-[Checkpoint position].x>-0.05)&&(trainPoint.y-[Checkpoint position].y<0.05)&&(trainPoint.y-[Checkpoint position].y>-0.05))
    {   //[trainhead stopAction:move2];
       // [trainhead setVisible:0];
       // [trainup setVisible:1];
      //  [traindown setVisible:1];
        CCLOG(@"win?");
       pauseTexture = [CCRenderTexture renderTextureWithWidth:self.contentSize.width height:self.contentSize.height];
        
        // 相关操作（记住就好）
        [pauseTexture begin];
        [self visit];
        [pauseTexture end];
        
        // 加载暂停界面
        [[CCDirector sharedDirector] pushScene:[[PauseScene scene] initWithParameter:pauseTexture] withTransition: [CCTransition transitionPushWithDirection:CCTransitionDirectionInvalid duration:1.0f]];
        selOrNot = NO;
    }
   /* else{
        [trainhead setVisible:1];
        [trainup setVisible:0];
        [traindown setVisible:0];
    }
    if((trainPoint.x-[winpoint position].x<0.05)&&(trainPoint.x-[winpoint position].x>-0.05)&&(trainPoint.y-[winpoint position].y<0.05)&&(trainPoint.y-[winpoint position].y>-0.05))
    {
        CCLOG(@"win");
    }
    if((trainPoint.x-[losepoint position].x<0.05)&&(trainPoint.x-[losepoint position].x>-0.05)&&(trainPoint.y-[losepoint position].y<0.05)&&(trainPoint.y-[losepoint position].y>-0.05))
    {
        CCLOG(@"lose");
    }*/
}
//刷新位置
-(void) updatetrain
{
    trainPoint=[trainhead position];
}

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



// 此函数没啥用
//-(void)spriteSelectedOrNot:(CGPoint)pos {
//    /*CGPoint posSelected = pos;
//    
//    if (CGRectContainsPoint(traindown.boundingBox, posSelected)&&traindown.visible==1) {
//        CCLOG(@"[Log] 火车已选择下！");
//        
//        [self setmove1];
//    }
//    if (CGRectContainsPoint(trainup.boundingBox, posSelected)&&trainup.visible==1) {
//        CCLOG(@"[Log] 火车已选择上");
//        [self setmove2];
//    }*/
//}

//
//-(void)setmove1
//{
//    
//    [trainhead setPosition:CGPointMake(0.57,0.46)];
//    move2=[CCActionMoveBy actionWithDuration:4 position:CGPointMake(0.2, -0.4)];
//    
//    [trainhead runAction:move2];
//    selOrNot = YES;
//}
//选择向上
//-(void)setmove2
//{
//    [trainhead setPosition:CGPointMake(0.57,0.54)];
//    move2=[CCActionMoveBy actionWithDuration:4 position:CGPointMake(0.2, 0.4)];
//    
//    [trainhead runAction:move2];
//    selOrNot = YES;
//    
//}
//-(void) onpreButtonClicked:(id) sender
//{
//    [trainhead setPosition:(CGPointMake(0.2, 0.5))];
//    CCAction *move3=[CCActionMoveBy actionWithDuration: 4 position:CGPointMake(0.3,0)];
//    [trainhead runAction:move3];
//    
//    
//};
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
//触屏开始
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
//触屏结束
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
       // [self spriteSelectedOrNot:endPos];
    }
    
    // 铺铁轨
    
    
    CGPoint lastPos = [[trackNowArray objectAtIndex:0] CGPointValue];
    CGPoint nowPos;
    [trainhead setPosition:CGPointMake(0.05f, 0.5f)];
    NSMutableArray *actionArray = [NSMutableArray arrayWithCapacity:[trackNowArray count]-1];
    for (int i=1; i<[trackNowArray count]; i++) {
        nowPos = [[trackNowArray objectAtIndex:i] CGPointValue];
        CGPoint move = ccpSub(nowPos , lastPos);
        id moveBy = [CCActionMoveBy actionWithDuration:0.5f position:move];
        [actionArray addObject:[moveBy copy]];
        lastPos = nowPos;
    }
    move2 = [CCActionSequence actionWithArray:actionArray]; // 连接所有的动作
    [trainhead runAction:move2];
}

- (void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CCLOG(@"[Log] touchCancel");
    
}





// -----------------------------------------------------------------

@end





