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


// -----------------------------------------------------------------

@implementation Newtest

static CGPoint trainPoint;
static id move2;

static BOOL selOrNot = YES;


// -----------------------------------------------------------------

+ (id)scene {
    return [[self alloc] init];
}

- (Newtest *)init {
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    
    CCNodeColor *bg = [CCNodeColor nodeWithColor:[CCColor blackColor]];
    [self addChild:bg];
    
    [self setUserInteractionEnabled:YES]; // 触屏
    [self setMultipleTouchEnabled:YES]; // 多点触控
    
    
    CCTexture * texture=[CCTexture textureWithFile:@"dead.png"];
    CCTexture * texture1=[CCTexture textureWithFile:@"goal.png"];
    CCTexture * track1=[CCTexture textureWithFile:@"铁轨4.png"];
    CCTexture * track2=[CCTexture textureWithFile:@"铁轨6.png"];
    
    trainup=[[TrainHead alloc] init];
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
    
    Checkpoint=[[TrainHead alloc] init];
    Checkpoint=[Checkpoint create:0.5 ySet:0.5];
    [Checkpoint setTexture:texture1];
        [self addChild:Checkpoint z:2];
    
    winpoint=[[TrainHead alloc] init];
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
    Track *track00;
    /*track00=[[Track alloc] init];
    track00=[track00 create:0.5 ySet:0.475];
    [track00 setTexture:track2];
    [track00 setScaleY:0.1];
    [track00 setScaleX:3.0];
    [self addChild:track00 z:2];*/
    
    
    

    
    [self schedule:@selector (updatetrain) interval:0.01];
    [self schedule:@selector (judgehead) interval:0.05];
    [self initScene];
    
    
    return self;
}
- (void)initScene {
    CCButton *preViewButton=[CCButton buttonWithTitle:@"preview" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]];
    
    [preViewButton setTarget: self selector:@selector(onpreButtonClicked:)];
    preViewButton.positionType = CCPositionTypeNormalized;
    preViewButton.position = ccp(0.85f, 0.85f);
    preViewButton.color=[CCColor redColor];
    
    [self addChild:preViewButton z:2];
    

    CCSprite *background = [CCSprite spriteWithImageNamed:@"backGround2.png"]; // 通过纹理建立背景
    [background setPosition:ccp(0.5f, 0.5f)];
    [background setPositionType:CCPositionTypeNormalized];
    [background setScale:self.contentSize.width / background.contentSize.width];
    [self addChild:background z:1];
    
    
   
}
-(void) judgehead
{
    if ((trainPoint.x-[Checkpoint position].x<0.05)&&(trainPoint.x-[Checkpoint position].x>-0.05)&&(trainPoint.y-[Checkpoint position].y<0.05)&&(trainPoint.y-[Checkpoint position].y>-0.05))
    {   [trainhead stopAction:move2];
        [trainhead setVisible:0];
        [trainup setVisible:1];
        [traindown setVisible:1];
        CCLOG(@"win?");
        selOrNot = NO;
    }
    else{
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
    }
}
-(void) updatetrain
{
    trainPoint=[trainhead position];
}


// 此函数用来确认火车图片被选择，并进行相应操作
-(void)spriteSelectedOrNot:(CGPoint)pos {
    CGPoint posSelected = pos;
    
    if (CGRectContainsPoint(traindown.boundingBox, posSelected)&&traindown.visible==1) {
        CCLOG(@"[Log] 火车已选择下！");
        
        [self setmove1];
    }
    if (CGRectContainsPoint(trainup.boundingBox, posSelected)&&trainup.visible==1) {
        CCLOG(@"[Log] 火车已选择上");
        [self setmove2];
    }
}

//选择向下
-(void)setmove1
{
    
    [trainhead setPosition:CGPointMake(0.57,0.46)];
    move2=[CCActionMoveBy actionWithDuration:4 position:CGPointMake(0.2, -0.4)];
    
    [trainhead runAction:move2];
    selOrNot = YES;
}
//选择向上
-(void)setmove2
{
    [trainhead setPosition:CGPointMake(0.57,0.54)];
    move2=[CCActionMoveBy actionWithDuration:4 position:CGPointMake(0.2, 0.4)];
    
    [trainhead runAction:move2];
    selOrNot = YES;
    
}
-(void) onpreButtonClicked:(id) sender
{
    [trainhead setPosition:(CGPointMake(0.2, 0.5))];
    CCAction *move3=[CCActionMoveBy actionWithDuration: 4 position:CGPointMake(0.3,0)];
    [trainhead runAction:move3];
    
    
};
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CCLOG(@"[Log] touchBegin");
   
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CCLOG(@"[Log] touchMove");
}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CCLOG(@"[Log] touchEnd");
    CGPoint endPos = [touch locationInNode:self];
    [self spriteSelectedOrNot:endPos];
    
}

- (void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CCLOG(@"[Log] touchCancel");
    
}




// -----------------------------------------------------------------

@end





