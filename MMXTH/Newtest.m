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
    [trainhead setScaleX:0.01];
    [trainhead setScaleY:0.01];
    [trainhead setPositionType:CCPositionTypeNormalized];
    CGPoint trainPos;
    trainPos.x=0.2;
    trainPos.y=0.5;
    [trainhead setPosition:trainPos];
    [self addChild:trainhead z:9];
    
    Checkpoint=[[TrainHead alloc] init];
    Checkpoint=[Checkpoint create:0.5 ySet:0.5];
    [Checkpoint setTexture:texture1];
    [Checkpoint setScaleX:1.5];
    [self addChild:Checkpoint z:2];
    
    CCButton

    
    [self schedule:@selector (updatetrain) interval:0.01];
    [self schedule:@selector (judgehead) interval:0.05];
    [self initScene];
    
    
    return self;
}
- (void)initScene {
    
    CCSprite *background = [CCSprite spriteWithImageNamed:@"backGround2.png"]; // 通过纹理建立背景
    [background setPosition:ccp(0.5f, 0.5f)];
    [background setPositionType:CCPositionTypeNormalized];
    [background setScale:self.contentSize.width / background.contentSize.width];
    [self addChild:background z:1];
    
    
   
}
-(void) judgehead
{
    if ((trainPoint.x-[Checkpoint position].x<0.05)&&(trainPoint.x-[Checkpoint position].x>-0.05)&&(trainPoint.x-[Checkpoint position].y<0.05)&&(trainPoint.y-[Checkpoint position].y>-0.05))
    {   [trainhead stopAction:move2];
        [trainhead setVisible:0];
        [trainup setVisible:1];
        [traindown setVisible:1];
        selOrNot = NO;
    }
    else{
        [trainhead setVisible:1];
        [trainup setVisible:0];
        [traindown setVisible:0];
    }
}
-(void) updatetrain
{
    trainPoint=[trainhead position];
}


// 此函数用来确认火车图片被选择，并进行相应操作
-(void)spriteSelectedOrNot:(CGPoint)pos {
    CGPoint posSelected = pos;
    if (CGRectContainsPoint(traindown.boundingBox, posSelected)) {
        CCLOG(@"[Log] 火车已选择下！");
        
        [self setmove1];
    }
    if (CGRectContainsPoint(trainup.boundingBox, posSelected)) {
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
-(void) onpreButtonClicked:(id) sender
{
  
    
    
};


// -----------------------------------------------------------------

@end





