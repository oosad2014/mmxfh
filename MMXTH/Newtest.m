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
@synthesize statearray;
@synthesize meshData;

// -----------------------------------------------------------------
typedef enum {
    DIR_UP = 0,
    DIR_DOWN,
    DIR_LEFT,
    DIR_RIGHT,
    DIR_STATE
}state;
typedef enum {
    TRAIN_DIRECTION_UP = 1,
    TRAIN_DIRECTION_DOWN,
    TRAIN_DIRECTION_LEFT,
    TRAIN_DIRECTION_RIGHT
}direction;
int trainDirection;
CCTexture * track1;
CCTexture * track2;
CCTexture * track3;
CCTexture * track4;
CCTexture * track5;
CCTexture * track6;
 CGPoint _trainLoc;
float _trainSpeedDuration;
bool isPresentSelected;
+ (id)scene {
    return [[self alloc] init];
}


- (Newtest *)init {
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    isPresentSelected = false;
    statearray=[NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
    
    meshData=[[NSMutableArray alloc] init];
   
    CCLOG(@"%lu",(unsigned long)statearray.count);
    CCNodeColor *bg = [CCNodeColor nodeWithColor:[CCColor blackColor]];
    
      _trainLoc = CGPointMake(1, 5);
    _preLoc = CGPointMake(0, 0);
    _nextLoc = CGPointMake(0, 0);
    trainDirection=TRAIN_DIRECTION_RIGHT;
    
    _trainSpeedDuration=0.1f;
    
   isTraveling = NO;
     isPaused = NO;
    
  
    
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
    
    CCTexture * treet1=[CCTexture textureWithFile:@"树1.png"];
     CCTexture * treet2=[CCTexture textureWithFile:@"树2.png"];
     CCTexture * treet3=[CCTexture textureWithFile:@"树1+.png"];
    
    trackVertical = [CCTexture textureWithFile:@"铁轨横向.png"];
    trackHorizontal = [CCTexture textureWithFile:@"铁轨竖直.png"];
    //CCTexture * track2=[CCTexture textureWithFile:@"铁轨6.png"];
    
    track1=[CCTexture textureWithFile:@"rail-down-left1.png"];
      track2=[CCTexture textureWithFile:@"rail-down-right1.png"];
     track3=[CCTexture textureWithFile:@"rail-left-right1.png"];
     track4=[CCTexture textureWithFile:@"rail-up-down1.png"];
      track5=[CCTexture textureWithFile:@"rail-up-left1.png"];
      track6=[CCTexture textureWithFile:@"rail-up-right1.png"];
    
    
    
    
    //铁轨数组
  
    
    for (int i=0; i<24; i++) {
        
        NSMutableArray *rowArray = [[NSMutableArray alloc] init];
        for (int j=0; j<14; j++) {
            NSMutableArray *copy=[statearray mutableCopy];
            [rowArray addObject:copy];
            
        }
        [self.meshData addObject:rowArray];
        //CCLOG(@"meshArray = %@",[meshData lastObject]);
    }
    
    _tile = CGSizeMake(self.contentSize.width/24, self.contentSize.height/14);
    CCLOG(@" tile is %f" ,_tile);
    
    // 放置树
  
    
    CCButton *button1 = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"icon/pause_click.png"]];
     [button1 setScale:(self.contentSize.width / button1.contentSize.width * 0.05f)];
    [button1 setPositionType:CCPositionTypeNormalized];
    [button1 setTarget:self selector:@selector(onMoeRetryClicked:)];
    [button1 setPosition:ccp(0.85f, 0.85f)];
    [self addChild:button1 z:12];
    CCButton *button2 = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"icon/retry_normal.png"]];
    [button2 setScale:(self.contentSize.width / button1.contentSize.width * 0.05f)];
    [button2 setPositionType:CCPositionTypeNormalized];
    [button2 setTarget:self selector:@selector(onTravelModeClicked:)];
    [button2 setPosition:ccp(0.75f, 0.85f)];
    [self addChild:button2 z:12];

    _train = [CCSprite spriteWithImageNamed:@"车.png"];
    [_train setScaleX:self.contentSize.width * 0.1 / _train.boundingBox.size.width];
    [_train  setScaleY:self.contentSize.height * 0.1 / _train.boundingBox.size.height];
    
    [_train setPosition:CGPointMake((_trainLoc.x-1)*_tile.width+_tile.width/2.0f, (_trainLoc.y-1)*_tile.height+_tile.height/2.0f)];
    [self addChild:_train z:11];
    CCLOG(@"what? %d %d",(int)[_train position].x,(int)[_train position].y);
    //放置终点

//    Checkpoint=[[TrainHead alloc] init];
//    Checkpoint=[Checkpoint create:0.85 ySet:0.5];
//    [Checkpoint setTexture:texture1];
//    [Checkpoint setScaleY:2.0f];
//    [self addChild:Checkpoint z:2];
    
       CCTexture *new=[CCTexture textureWithFile:@"终点.png"];
    CCSprite *goal=[CCSprite spriteWithTexture:new];
    goal.scaleY = _tile.height/goal.contentSize.height;
    goal.scaleX = _tile.width/goal.contentSize.width;
    
    [goal setPosition:CGPointMake(22*_tile.width+_tile.width/2.0f, 12*_tile.height+_tile.height/2.0f)];
    [[[self.meshData objectAtIndex:22] objectAtIndex:12] replaceObjectAtIndex:DIR_STATE withObject:@2];
    [self addChild:goal z:11];
    
    CCTexture *new2=[CCTexture textureWithFile:@"井.png"];
    CCSprite *za=[CCSprite spriteWithTexture:new2];
    za.scaleY = _tile.height/za.contentSize.height;
    za.scaleX = _tile.width/za.contentSize.width;
    
    [za setPosition:CGPointMake(12*_tile.width+_tile.width/2.0f, 5*_tile.height+_tile.height/2.0f)];
    [[[self.meshData objectAtIndex:12] objectAtIndex:5] replaceObjectAtIndex:DIR_STATE withObject:@3];
    [self addChild:za z:11];

    
    //位置更新
//    [self schedule:@selector (updatetrain) interval:0.01];
//    [self schedule:@selector (judgehead) interval:0.05];
    [self schedule:@selector (log) interval:1];
    [self initScene];
    
    
    return self;
   
    
}
- (void)initScene {

    
//背景更新
    CCSprite *background = [CCSprite spriteWithImageNamed:@"草地.png"]; // 通过纹理建立背景
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
    
    }

}
-(void) log
{
    CCLOG(@"%f,%f",_trainLoc.x,_trainLoc.y);
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




- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
      CGPoint touchLoc = [touch locationInNode:self];
    _preLoc = CGPointMake((int)(touchLoc.x/_tile.width), (int)(touchLoc.y/_tile.height));
}
//触屏开始
- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {

        CGPoint touchLoc = [touch locationInNode:self];
    
        _nextLoc = CGPointMake((int)(touchLoc.x/_tile.width), (int)(touchLoc.y/_tile.height));
        //start to draw the line
        if (!isPresentSelected) {
            CGPoint diff = ccpSub(_nextLoc, _preLoc);
            if (diff.x!=0 | diff.y!=0) {
                //select the present point
                _presentLoc = _nextLoc;
                isPresentSelected = true;
                if (fabs(diff.x)>fabs(diff.y)) {
                    if (diff.x > 0) {
                        //presentLoc is rightward
                        [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] replaceObjectAtIndex:DIR_LEFT withObject:@1];
                        
                        CCLOG(@"judgeleft");
                    }
                    else{
                        //presentLoc is leftward
                        [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] replaceObjectAtIndex:DIR_RIGHT withObject:@1];
                        CCLOG(@"judgeright");
                    }
                }
                else{
                    if (diff.y > 0) {
                        //presentLoc is upward
                        [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] replaceObjectAtIndex:DIR_DOWN withObject:@1];
                        CCLOG(@"judgedown");
                    }
                    else{
                        //presentLoc is downward
                        [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] replaceObjectAtIndex:DIR_UP withObject:@1];
                        CCLOG(@"judgeup");
                    }
                    
                }
            }}
        else{
            CCLOG(@"choice two");
            CGPoint diff = ccpSub(_nextLoc, _presentLoc);
            if (diff.x!=0 | diff.y!=0) {
                if (fabs(diff.x)>fabs(diff.y)) {
                    if (diff.x > 0) {
                        [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] replaceObjectAtIndex:DIR_RIGHT withObject:@1];
                        CCLOG(@"right");
                    }
                    else{
                        //nextLoc is leftward
                        
                        [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] replaceObjectAtIndex:DIR_LEFT withObject:@1];
                        CCLOG(@"left");
                    }
                }
                else{
                    if (diff.y > 0) {
                        //nextLoc is upward
                        [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] replaceObjectAtIndex:DIR_UP withObject:@1];
                        CCLOG(@"up");
                    }
                    else{
                        //nextLoc is downward
                        [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] replaceObjectAtIndex:DIR_DOWN withObject:@1];
                        CCLOG(@"down");
                    }
                }
                
                
                //When isEdited == NO,build the rail
                CCLOG(@"targetbefore inpu %d ,%d",(int)_presentLoc.x,(int)_presentLoc.y);
                if ([[[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] objectAtIndex:DIR_STATE] isEqualToValue:@0]) {
                    CCLOG(@"mesh input %@",[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y]);
                    [self createRailTargetX:(int)_presentLoc.x TargetY:(int)_presentLoc.y];
                    CCLOG(@"pos %f , %f \n",_presentLoc.x,_presentLoc.y);
                    
                    _preLoc = _presentLoc;
                    _presentLoc = _nextLoc;
                    CCLOG(@"iguessdraw");
                }
                isPresentSelected = false;
            
        }
        
    }
 }

//触屏结束
- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
isPresentSelected = false;

    
}

- (void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CCLOG(@"[Log] touchCancel");
    
}


-(void)createRailTargetX:(int)targetX TargetY:(int)targetY{
    [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] replaceObjectAtIndex:DIR_STATE withObject:@1];
    CCLOG(@"taget %d %d ",targetX,targetY);
    NSObject *up=[[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] objectAtIndex: DIR_UP];
    NSObject *down=[[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] objectAtIndex: DIR_DOWN];
   NSObject *left=[[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] objectAtIndex: DIR_LEFT];
    NSObject*right=[[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] objectAtIndex: DIR_RIGHT];
    //NSInteger state=[[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] objectAtIndex: DIR_STATE];
    CCLOG(@"left %@ right %@ up %@ down %@",left,right,up,down);
    NSString *temp=@"train.png";
    CCSprite *track=[[CCSprite alloc]init];
    if ([right isEqual:@1] && [left isEqual:@1]){
       temp=@"rail-left-right1.png";
        CCLOG(@"%@",temp);
        
    }
    else if ([up isEqual:@1] &&[down isEqual:@1]){
           temp=@"rail-up-down1.png";
          CCLOG(@"%@",temp);
        
    }
    else if ([up isEqual:@1] && [left isEqual:@1]){
          temp=@"rail-up-left1.png";
          CCLOG(@"%@",temp);
    }
    else if ([up isEqual:@1]&& [right isEqual:@1]){
       temp=@"rail-up-right1.png";
          CCLOG(@"%@",temp);
    }
    else if ([down isEqual:@1]&&[left isEqual:@1]){
              temp=@"rail-down-left1.png";
          CCLOG(@"%@",temp);
    }
    else if ([down isEqual:@1] && [right isEqual:@1]){
        temp=@"rail-down-right1.png";
          CCLOG(@"%@",temp);
    }
    else{
        [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] replaceObjectAtIndex:DIR_STATE withObject:@0];
       
    }
    if(![temp isEqualToString:@"train.png"]){
    CCTexture *new=[CCTexture textureWithFile:temp];
   track=[CCSprite spriteWithTexture:new];
        
        track.scaleY = _tile.height/track.contentSize.height;
    track.scaleX = _tile.width/track.contentSize.width;
    [track setPosition:CGPointMake(targetX*_tile.width+_tile.width/2.0f, targetY*_tile.height+_tile.height/2.0f)
];
        [self addChild:track z:12];}
   
    //[self addChild:Atrack z:2];
            CCLOG(@"scaleX scale Y %f %f \n",track.scaleX,track.scaleY);
            CCLOG(@"targetX targetY %d %d \n",targetX,targetY);
            CCLOG(@"postionX positionY %f %f \n",track.position.x,track.position.y);
    
    
    
        }

-(void)onTrainTravelAction{
    switch (trainDirection) {
            int n=1;
        case TRAIN_DIRECTION_UP:
        {
            
            CCAction *goUp = [CCActionMoveBy actionWithDuration:_trainSpeedDuration position:CGPointMake(0.0f, _tile.height)];
            ++n;
            [self->_train runAction:goUp];
            
            
            if([[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_UP] isEqual:@1]&&[[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_DOWN] isEqual:@1]){
                
                _trainLoc.y += 1.0f;
                _train.zOrder-=1;
            }
            else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_DOWN] isEqual:@1]&&[[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_LEFT] isEqual:@1]){
                
                trainDirection = TRAIN_DIRECTION_LEFT;
                _trainLoc.y += 1.0f;
                _train.zOrder-=1;
            }
            else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_DOWN] isEqual:@1]&&[[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_RIGHT] isEqual:@1]){
                
                trainDirection = TRAIN_DIRECTION_RIGHT;
                _trainLoc.y += 1.0f;
                _train.zOrder-=1;
            }
            else{
                if([[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@2]){
                    
                    [self gameFinished:YES];
                }
                else if([[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@3])
                {[self gameFinished:NO];
                    [self setAction:_train];
                    CCLOG(@"bong");
                }
                else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@0])
                {[self gameFinished:NO];
                    CCLOG(@"nowhere");
                }
                
            }
            break;
        }
        case TRAIN_DIRECTION_DOWN:
        {
            CCAction *goDown = [CCActionMoveBy actionWithDuration:_trainSpeedDuration position:CGPointMake(0.0f, -_tile.height)];
            
            [self->_train runAction:goDown];

            ++n;
            
            
            if([[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y-2] objectAtIndex:DIR_STATE] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y-2] objectAtIndex:DIR_UP] isEqual:@1]&& [[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y-2] objectAtIndex:DIR_DOWN] isEqual:@1]){
                
                _trainLoc.y -= 1.0f;
                _train.zOrder+=1;
            }
            else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y-2] objectAtIndex:DIR_STATE] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y-2] objectAtIndex:DIR_UP] isEqual:@1]&& [[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y-2] objectAtIndex:DIR_LEFT] isEqual:@1]){
                trainDirection = TRAIN_DIRECTION_LEFT;
                _trainLoc.y -= 1.0f;
                _train.zOrder+=1;
            }
            else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y-2] objectAtIndex:DIR_STATE] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y-2] objectAtIndex:DIR_UP] isEqual:@1]&& [[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y-2] objectAtIndex:DIR_RIGHT] isEqual:@1]){
                
                trainDirection = TRAIN_DIRECTION_RIGHT;
                _trainLoc.y -= 1.0f;
                _train.zOrder+=1;
            }
            else{
                if([[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@2]){
                    
                    [self gameFinished:YES];
                }
                else if([[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@3])
                {[self gameFinished:NO];
                    CCLOG(@"bong");
                    [self setAction:_train];
                }
                else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@0])
                {[self gameFinished:NO];
                    
                    CCLOG(@"nowhere");
                }
                
            }
            break;
        }
        case TRAIN_DIRECTION_LEFT:
        {
            CCAction *goLeft = [CCActionMoveBy actionWithDuration:_trainSpeedDuration position:CGPointMake(-_tile.width, 0)];
            [self->_train runAction:goLeft];

            ++n;
            
            if([[[[self.meshData objectAtIndex:(int)_trainLoc.x-2] objectAtIndex:(int)_trainLoc.y-1] objectAtIndex:DIR_STATE] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_trainLoc.x-2] objectAtIndex:(int)_trainLoc.y-1] objectAtIndex:DIR_LEFT] isEqual:@1]&& [[[[self.meshData objectAtIndex:(int)_trainLoc.x-2] objectAtIndex:(int)_trainLoc.y-1] objectAtIndex:DIR_RIGHT] isEqual:@1]){
                
                _trainLoc.x-=1.0f;
            }
            else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x-2] objectAtIndex:(int)_trainLoc.y-1] objectAtIndex:DIR_STATE] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_trainLoc.x-2] objectAtIndex:(int)_trainLoc.y-1] objectAtIndex:DIR_DOWN] isEqual:@1]&& [[[[self.meshData objectAtIndex:(int)_trainLoc.x-2] objectAtIndex:(int)_trainLoc.y-1] objectAtIndex:DIR_RIGHT] isEqual:@1]){
                
                trainDirection = TRAIN_DIRECTION_DOWN;
                _trainLoc.x-=1.0f;
            }
            else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x-2] objectAtIndex:(int)_trainLoc.y-1] objectAtIndex:DIR_STATE] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_trainLoc.x-2] objectAtIndex:(int)_trainLoc.y-1] objectAtIndex:DIR_UP] isEqual:@1]&& [[[[self.meshData objectAtIndex:(int)_trainLoc.x-2] objectAtIndex:(int)_trainLoc.y-1] objectAtIndex:DIR_RIGHT] isEqual:@1]){
                
                trainDirection = TRAIN_DIRECTION_UP;
                _trainLoc.x-=1.0f;
            }
            else{
                if([[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@2]){
                    
                    [self gameFinished:YES];
                }
                else if([[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@3])
                {[self gameFinished:NO];
                    CCLOG(@"bong");
                    [self setAction:_train];
                    
                }
                else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@0])
                {[self gameFinished:NO];
                    CCLOG(@"nowhere");
                }
                
            }
            break;
        }
        case TRAIN_DIRECTION_RIGHT:
        {
            
            CCAction *goRight = [CCActionMoveBy actionWithDuration:_trainSpeedDuration position:CGPointMake(_tile.width, 0)];
            [self->_train runAction:goRight];
     
            ++n;
            
            if([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y-1] objectAtIndex:DIR_STATE] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y-1] objectAtIndex:DIR_LEFT] isEqual:@1]&&[[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y-1] objectAtIndex:DIR_RIGHT] isEqual:@1]){
                
                _trainLoc.x+=1.0f;
            }
            else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y-1] objectAtIndex:DIR_STATE] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y-1] objectAtIndex:DIR_DOWN] isEqual:@1]&&[[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y-1] objectAtIndex:DIR_LEFT] isEqual:@1]){
                
                trainDirection = TRAIN_DIRECTION_DOWN;
                _trainLoc.x+=1.0f;
            }
            else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y-1] objectAtIndex:DIR_STATE] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y-1] objectAtIndex:DIR_UP] isEqual:@1]&&[[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y-1] objectAtIndex:DIR_LEFT] isEqual:@1]){
                
                trainDirection = TRAIN_DIRECTION_UP;
                _trainLoc.x+=1.0f;
            }
            else{
                if([[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@2]){
                    
                    [self gameFinished:YES];
                }
                else if([[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@3])
                { CCLOG(@"bong");
                    [self gameFinished:NO];
                    [self setAction:_train];
                }
                else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x-1] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@0])
                {[self gameFinished:NO];
                        CCLOG(@"nowhere");
                }
                
            }


            break;
        }
        default:
            break;
    }
    if(!isPaused)self.timer =[NSTimer scheduledTimerWithTimeInterval:_trainSpeedDuration target:self selector:@selector(onTrainTravelAction) userInfo:nil repeats:NO];
}//onTrain

-(void)onMoeRetryClicked:(id)sender{
   
    [[OALSimpleAudio sharedInstance] stopEverything];
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[Newtest scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:0.5f]];
}

-(void)onTravelModeClicked:(id)sender{
    
    //sound effect
    
    if (!isTraveling) {

        [self onTrainTravelAction];
        isTraveling = YES;
    }
}

-(void)gameFinished:(BOOL)isClear{
    isPaused=YES;
    if(isClear)
    {
    pauseTexture = [CCRenderTexture renderTextureWithWidth:self.contentSize.width height:self.contentSize.height];
    
    // 相关操作（记住就好）
    [pauseTexture begin];
    [self visit];
    [pauseTexture end];
    
    // 加载暂停界面
    [[CCDirector sharedDirector] pushScene:[[PauseScene scene] initWithParameter:pauseTexture] withTransition: [CCTransition transitionPushWithDirection:CCTransitionDirectionInvalid duration:1.0f]];
    CCLOG(@"by finish func");
    }
    else {
        CCLOG(@"Lose");
    }
  
    
}

-(void) setAction:(CCSprite *) m_actor
{
   
    
    id rotate=[CCActionRotateBy actionWithDuration:0.5 angle:360];
    id scale=[CCActionScaleBy actionWithDuration:0.5 scale:0.7];
    id moveto=[CCActionMoveTo actionWithDuration:5 position:CGPointMake(1*_tile.width+_tile.width/2.0f, 12*_tile.height+_tile.height/2.0f)];
 
    id moveset=[CCActionSpawn actions: rotate,scale,nil];
    //循环这个并行的组合序列
    id repeatAct = [CCActionRepeat actionWithAction:moveset times:8];
    id bingxingAct=[CCActionSpawn actions: repeatAct,moveto,nil];
    [m_actor runAction:bingxingAct];
    //启动action
    
}



@end





