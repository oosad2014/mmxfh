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
@synthesize goodsarray;
@synthesize collectionsarray;
@synthesize kindsarray;
@synthesize scenekinds;
@synthesize collectgroup;

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
typedef enum
{
    DRAW_MODE = 1,
    REMOVE_MODE
    
    
}mode;
int trainDirection;
CCTexture * track1;
CCTexture * track2;
CCTexture * track3;
CCTexture * track4;
CCTexture * track5;
CCTexture * track6;
CCTexture *temp1;
CCSprite *Spoint;

+ (id)scene {
    return [[self alloc] init];
}


- (Newtest *)init {
    self = [super init];
     NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"GuangZhouMap" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSAssert(self, @"Unable to create class %@", [self class]);
    
    isPresentSelected = false;
    
    statearray=[NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
    
    self.meshData=[[NSMutableArray alloc] init];
     self.railGroup = [[NSMutableArray alloc] init];
    self.goodsarray=[[NSMutableArray alloc] init];
    self.collectionsarray=[[NSMutableArray alloc] init];
    self.kindsarray=[[NSMutableArray alloc] init];
    self.scenekinds=[[NSMutableArray alloc] init];
     self.collectgroup=[[NSMutableArray alloc] init];
    
    _row=[[dictionary objectForKey:@"MapRow"] intValue];
    _column=[[dictionary objectForKey:@"MapCol"] intValue];

    CCNodeColor *bg = [CCNodeColor nodeWithColor:[CCColor blackColor]];
    _trainLoc.x=[[[dictionary objectForKey:@"TrainLocation"] objectAtIndex:0] doubleValue];
    _trainLoc.y=[[[dictionary objectForKey:@"TrainLocation"] objectAtIndex:1] doubleValue];
    _goal.x=[[[dictionary objectForKey:@"TrainGoal"] objectAtIndex:0] doubleValue];
    _goal.y=[[[dictionary objectForKey:@"TrainGoal"] objectAtIndex:1] doubleValue];
    _preLoc = CGPointMake(0, 0);
    _nextLoc = CGPointMake(0, 0);
    trainDirection=TRAIN_DIRECTION_RIGHT;
    
    _trainSpeedDuration=0.1f;
    
   isTraveling = NO;
     isPaused = NO;
    gamemode=DRAW_MODE;
    
    for (int i=0; i<[[dictionary objectForKey:@"GoodsKind"] count]; i++) {
        NSString *kind=[[dictionary objectForKey:@"GoodsKind"] objectAtIndex:i];
        [self.kindsarray addObject:kind];
        
       
    }
    
    for (int i=0; i<[[dictionary objectForKey:@"GoodsArray"] count]; i++) {
       NSMutableArray *goods=[[dictionary objectForKey:@"GoodsArray"] objectAtIndex:i];

        [self.goodsarray addObject:goods];
       
      
    }
    for (int i=0; i<[[dictionary objectForKey:@"SceneKind"] count]; i++) {
        NSString *kind=[[dictionary objectForKey:@"SceneKind"] objectAtIndex:i];
        [self.scenekinds addObject:kind];
        
        
    }
    
    for (int i=0; i<[[dictionary objectForKey:@"SceneArray"] count]; i++) {
        NSMutableArray *scenes=[[dictionary objectForKey:@"SceneArray"] objectAtIndex:i];

        [self.collectionsarray addObject:scenes];

        
    }
  
    
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
    otherGoods = [CCTexture textureWithFile:@"树2.png"];

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

    }
    
    _tile = CGSizeMake(self.contentSize.width/24, self.contentSize.height/14);
    for(int i=0;i<[self.goodsarray count];i++)
    {   NSMutableArray *points=[self.goodsarray objectAtIndex:i];

        CGPoint itempoint;
        itempoint.x=[[points objectAtIndex:0] doubleValue];
        itempoint.y=[[points objectAtIndex:1] doubleValue];
        int index=[[points  objectAtIndex:2] doubleValue];
        NSString *kind=[self.kindsarray objectAtIndex:index];
        CCTexture *new=[CCTexture textureWithFile:kind];
        CCSprite *item=[CCSprite spriteWithTexture:new];
        item.scaleY = _tile.height/item.contentSize.height;
        item.scaleX = _tile.width/item.contentSize.width;
        [item setPosition:CGPointMake((itempoint.x)*_tile.width+_tile.width/2.0f, (itempoint.y)*_tile.height+_tile.height/2.0f)];

        [[[self.meshData objectAtIndex:itempoint.x] objectAtIndex:itempoint.y] replaceObjectAtIndex:DIR_STATE withObject:@3];
        [self addChild:item z:11];
        
        
        
        
    }
    for(int i=0;i<[self.collectionsarray count];i++)
    {   NSMutableArray *points=[self.collectionsarray objectAtIndex:i];
       
        CGPoint itempoint;
        itempoint.x=[[points objectAtIndex:0] doubleValue];
        itempoint.y=[[points objectAtIndex:1] doubleValue];
        int index=[[points  objectAtIndex:2] doubleValue];
        NSString *kind=[self.scenekinds objectAtIndex:index];
        CCTexture *new=[CCTexture textureWithFile:kind];
        CCSprite *item=[CCSprite spriteWithTexture:new];
        item.scaleY = _tile.height/item.contentSize.height;
        item.scaleX = _tile.width/item.contentSize.width;
        [item setPosition:CGPointMake((itempoint.x)*_tile.width+_tile.width/2.0f, (itempoint.y)*_tile.height+_tile.height/2.0f)];

        [[[self.meshData objectAtIndex:itempoint.x] objectAtIndex:itempoint.y] replaceObjectAtIndex:DIR_STATE withObject:@4];
        [self addChild:item z:10];
        [self.collectgroup addObject:item];
        
        
        
        
    }
    

    
    // 放置树
  
    
    

    
    
    _train = [CCSprite spriteWithImageNamed:@"车.png"];
    _train.scaleY = _tile.height/_train.contentSize.height;
    _train.scaleX = _tile.width/_train.contentSize.width;
    [_train setPosition:CGPointMake((_trainLoc.x)*_tile.width+_tile.width/2.0f, (_trainLoc.y)*_tile.height+_tile.height/2.0f)];
    [self addChild:_train z:13];

    //放置终点
    
    
    
       CCTexture *new=[CCTexture textureWithFile:@"终点.png"];
    CCSprite *goal=[CCSprite spriteWithTexture:new];
    goal.scaleY = _tile.height/goal.contentSize.height;
    goal.scaleX = _tile.width/goal.contentSize.width;
    [goal setPosition:CGPointMake((_goal.x)*_tile.width+_tile.width/2.0f, (_goal.y)*_tile.height+_tile.height/2.0f)];
    [[[self.meshData objectAtIndex:_goal.x] objectAtIndex:_goal.y] replaceObjectAtIndex:DIR_STATE withObject:@2];
    [self addChild:goal z:11];
    
    
    



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
    CCButton *button1 = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"retry.png"]];
    button1.scaleY = _tile.height/button1.contentSize.height;
    button1.scaleX = _tile.width/button1.contentSize.width;
    [button1 setTarget:self selector:@selector(onMoeRetryClicked:)];
    [button1 setPosition:CGPointMake(0*_tile.width+_tile.width/2.0f, 1*_tile.height+_tile.height/2.0f)];
    [self addChild:button1 z:12];
    
    CCButton *button2 = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"begin.png"]];
    button2.scaleY = _tile.height/button2.contentSize.height;
    button2.scaleX = _tile.width/button2.contentSize.width;
    [button2 setTarget:self selector:@selector(onTravelModeClicked:)];
    [button2 setPosition:CGPointMake(1*_tile.width+_tile.width/2.0f, 1*_tile.height+_tile.height/2.0f)];
    [self addChild:button2 z:12];
    
    CCButton *button3 = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"icon/help_normal.png"]];
    [button3 setScale:(self.contentSize.width / button3.contentSize.width * 0.05f)];
    [button3 setTarget:self selector:@selector(onDeletemodeClicked:)];
    [button3 setPosition:CGPointMake(2*_tile.width+_tile.width/2.0f, 1*_tile.height+_tile.height/2.0f)];
    [self addChild:button3 z:12];
    
    CCButton *button4 = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"icon/menu_normal.png"]];
    [button4 setScale:(self.contentSize.width / button4.contentSize.width * 0.05f)];
    [button4 setTarget:self selector:@selector(onDrawmodeClicked:)];
    [button4 setPosition:CGPointMake(3*_tile.width+_tile.width/2.0f, 1*_tile.height+_tile.height/2.0f)];
    [self addChild:button4 z:12];


    
    
   
}




- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
      CGPoint touchLoc = [touch locationInNode:self];
    if (gamemode == DRAW_MODE ){
        //select the start point
        _preLoc = CGPointMake((int)(touchLoc.x/_tile.width), (int)(touchLoc.y/_tile.height));
    }
    else if (gamemode == REMOVE_MODE){
        [self deleteSpriteTouching:touchLoc];
    }
  
}
//触屏开始
- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {

        CGPoint touchLoc = [touch locationInNode:self];
    if (gamemode == DRAW_MODE){
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

                    }
                    else{
                        //presentLoc is leftward
                        [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] replaceObjectAtIndex:DIR_RIGHT withObject:@1];
 
                    }
                }
                else{
                    if (diff.y > 0) {
                        //presentLoc is upward
                        [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] replaceObjectAtIndex:DIR_DOWN withObject:@1];

                    }
                    else{
                        //presentLoc is downward
                        [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] replaceObjectAtIndex:DIR_UP withObject:@1];

                    }
                    
                }
            }}
        else{

            CGPoint diff = ccpSub(_nextLoc, _presentLoc);
            if (diff.x!=0 | diff.y!=0) {
                if (fabs(diff.x)>fabs(diff.y)) {
                    if (diff.x > 0) {
                        [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] replaceObjectAtIndex:DIR_RIGHT withObject:@1];

                    }
                    else{
                        //nextLoc is leftward
                        
                        [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] replaceObjectAtIndex:DIR_LEFT withObject:@1];
                       
                    }
                }
                else{
                    if (diff.y > 0) {
                        //nextLoc is upward
                        [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] replaceObjectAtIndex:DIR_UP withObject:@1];
                   
                    }
                    else{
                        //nextLoc is downward
                        [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] replaceObjectAtIndex:DIR_DOWN withObject:@1];
                    
                    }
                }
                
                
                //When isEdited == NO,build the rail
              
                if ([[[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] objectAtIndex:DIR_STATE] isEqualToValue:@0]||[[[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] objectAtIndex:DIR_STATE] isEqualToValue:@4]) {

                    [self createRailTargetX:(int)_presentLoc.x TargetY:(int)_presentLoc.y];
            
                    _preLoc = _presentLoc;
                    _presentLoc = _nextLoc;
            
                }
                isPresentSelected = false;
            
        }
        }
        
    }
    if(gamemode==REMOVE_MODE)
    {
         [self deleteSpriteTouching:touchLoc];
    }
 }

//触屏结束
- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
isPresentSelected = false;

    
}

- (void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event {

    
}


-(void)createRailTargetX:(int)targetX TargetY:(int)targetY{
    if(![[[[self.meshData objectAtIndex:(int)targetX] objectAtIndex:(int)targetY] objectAtIndex:DIR_STATE] isEqualToValue:@4])
    [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] replaceObjectAtIndex:DIR_STATE withObject:@1];
    else
        [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] replaceObjectAtIndex:DIR_STATE withObject:@5];


    //NSInteger state=[[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] objectAtIndex: DIR_STATE];

    NSString *temp=@"train.png";

    CCSprite *track=[[CCSprite alloc]init];

    if ([self judgeLeftRight:targetX :targetY]){
       temp=@"rail-left-right1.png";
        temp1=track3;

        
    }
    else if ([self judgeUpDown:targetX :targetY]){
           temp=@"rail-up-down1.png";
        temp1=track4;

        
    }
    else if ([self judgeUpLeft:targetX :targetY]){
          temp=@"rail-up-left1.png";
        temp1=track5;

    }
    else if ([self judgeUpRight:targetX :targetY]){
       temp=@"rail-up-right1.png";
        temp1=track6;

    }
    else if ([self judgeDownLeft:targetX :targetY]){
              temp=@"rail-down-left1.png";
        temp1=track1;

    }
    else if ([self judgeDownRight:targetX :targetY]){
        temp=@"rail-down-right1.png";
        temp1=track2;

    }
    else{
        if(![[[[self.meshData objectAtIndex:(int)targetX] objectAtIndex:(int)targetY] objectAtIndex:DIR_STATE] isEqualToValue:@4])
          [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] replaceObjectAtIndex:DIR_STATE withObject:@0];
        else
              [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] replaceObjectAtIndex:DIR_STATE withObject:@4];
       
    }
    if(![temp isEqualToString:@"train.png"]){
        track=[CCSprite spriteWithTexture:temp1];
        track.scaleY = _tile.height/track.contentSize.height;
    track.scaleX = _tile.width/track.contentSize.width;
    [track setPosition:CGPointMake(targetX*_tile.width+_tile.width/2.0f, targetY*_tile.height+_tile.height/2.0f)
];
        [self addChild:track z:12];
        [self.railGroup addObject:track];

    }
 
    
    
        }

-(void)onTrainTravelAction{
    switch (trainDirection) {

            
        case TRAIN_DIRECTION_UP:
            
        {
            if(_trainLoc.y==23)
            {
                [self gameFinished:YES];
            }
            
            CCAction *goUp = [CCActionMoveBy actionWithDuration:_trainSpeedDuration position:CGPointMake(0.0f, _tile.height)];
            [self->_train runAction:goUp];
               _trainLoc.y += 1.0f;
            if([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@5])
            {
                [self collect:(int)_trainLoc.x :(int)_trainLoc.y];
            }
            
           if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@1] && [self judgeDownLeft:(int)_trainLoc.x :(int)_trainLoc.y]){
                trainDirection = TRAIN_DIRECTION_LEFT;
            }
           else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@1] && [self judgeDownRight:(int)_trainLoc.x :(int)_trainLoc.y]){
                trainDirection = TRAIN_DIRECTION_RIGHT;
            }
           else{
               if([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@2]){
                   
                   [self gameFinished:YES];
               }
              
               
               
               else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@0]||[[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@3])
               {[self gameFinished:NO];
                   CCLOG(@"nowhere");
               }
               
           }
            break;
        }
        case TRAIN_DIRECTION_DOWN:
        {
            if(_trainLoc.y==0)
            {
                [self gameFinished:YES];
            }
            CCAction *goDown = [CCActionMoveBy actionWithDuration:_trainSpeedDuration position:CGPointMake(0.0f, -_tile.height)];
            
            [self->_train runAction:goDown];
           _trainLoc.y -= 1.0f;
         
            if([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@5]||[[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@4])
            {
                [self collect:(int)_trainLoc.x :(int)_trainLoc.y];
            }
         
             if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@1] && [self judgeUpLeft:(int)_trainLoc.x :(int)_trainLoc.y]){
                trainDirection = TRAIN_DIRECTION_LEFT;

            }
            else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@1] && [self judgeUpRight:(int)_trainLoc.x :(int)_trainLoc.y]){
                
                trainDirection = TRAIN_DIRECTION_RIGHT;
            }
            else{
                if([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@2]){
                    
                    [self gameFinished:YES];
                }
            
                
                
                else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@0]||[[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@3]||[[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@4])
                {[self gameFinished:NO];
                    CCLOG(@"nowhere");
                }
                
            }
            break;
        }
        case TRAIN_DIRECTION_LEFT:
        {
            if(_trainLoc.x==0)
            {
                [self gameFinished:YES];
            }
            CCAction *goLeft = [CCActionMoveBy actionWithDuration:_trainSpeedDuration position:CGPointMake(-_tile.width, 0)];
            [self->_train runAction:goLeft];
             _trainLoc.x-=1.0f;
            if([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@5])
            {
                [self collect:(int)_trainLoc.x :(int)_trainLoc.y];
            }
          if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@1] && [self judgeDownRight:(int)_trainLoc.x :(int)_trainLoc.y]){
                
                trainDirection = TRAIN_DIRECTION_DOWN;
            }
            else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@1] && [self judgeUpRight:(int)_trainLoc.x :(int)_trainLoc.y]){
                
                trainDirection = TRAIN_DIRECTION_UP;
            }
            else{
                if([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@2]){
                    
                    [self gameFinished:YES];
                }
                
                
                else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@0]||[[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@3])
                {[self gameFinished:NO];
                    CCLOG(@"nowhere");
                }
                
            }
            break;
        }
        case TRAIN_DIRECTION_RIGHT:
        {
            if(_trainLoc.x==23)
            {
                [self gameFinished:YES];
            }
            CCAction *goRight = [CCActionMoveBy actionWithDuration:_trainSpeedDuration position:CGPointMake(_tile.width, 0)];
            [self->_train runAction:goRight];
           _trainLoc.x+=1.0f;
            if([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@5])
            {
                [self collect:(int)_trainLoc.x :(int)_trainLoc.y];
            }
            if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@1] && [self judgeDownLeft:(int)_trainLoc.x :(int)_trainLoc.y]){
                
                trainDirection = TRAIN_DIRECTION_DOWN;

            }
            else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@1] && [self judgeUpLeft:(int)_trainLoc.x :(int)_trainLoc.y]){
                
                trainDirection = TRAIN_DIRECTION_UP;
            }
            else{
                if([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@2]){
                    
                    [self gameFinished:YES];
                }
                

               
                else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@0]||[[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@3])
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
-(void)onDeletemodeClicked:(id)sender
{
    gamemode=REMOVE_MODE;
}
-(void)onDrawmodeClicked:(id) sender
{
    gamemode=DRAW_MODE;
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
   // id delete=[CCActionCallFunc actionWithTarget:m_actor selector:@selector(CallBack1:)];
    id moveset=[CCActionSpawn actions: rotate,scale,nil];
    //循环这个并行的组合序列
    id repeatAct = [CCActionRepeat actionWithAction:moveset times:8];
    id bingxingAct=[CCActionSpawn actions: repeatAct,moveto, nil];
    
    [m_actor runAction:bingxingAct];
    
    //启动action
    
}
-(void) Callback1:(id)sender
{
    [sender removeFromParent];
    
}
-(void)deleteSpriteTouching:(CGPoint)touchLocation{   if (![[[[self.meshData objectAtIndex:(int)(touchLocation.x/_tile.width)] objectAtIndex:(int)(touchLocation.y/_tile.height)] objectAtIndex:DIR_STATE] isEqual:@1]) {
    return;
}
    for (CCSprite *sprite in self.railGroup) {
        if(CGRectContainsPoint(sprite.boundingBox, touchLocation)){
            [sprite removeFromParentAndCleanup:YES];
            NSMutableArray *copy=[statearray mutableCopy];
            //clear the isEdited value
            [[self.meshData objectAtIndex:(int)(touchLocation.x/_tile.width)] replaceObjectAtIndex:(int)(touchLocation.y/_tile.height) withObject:copy];
            [self.railGroup removeObjectAtIndex:[self.railGroup indexOfObject:sprite]];
            break;
        }
    }
  
}
-(BOOL) judgeLeftRight:(int)x :(int)y
{
     if ([[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectAtIndex: DIR_RIGHT] isEqual:@1] && [[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectAtIndex: DIR_LEFT] isEqual:@1])
         return true;
     else return false;
}
-(BOOL) judgeUpDown:(int)x :(int)y
{
    if ([[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectAtIndex: DIR_UP] isEqual:@1] &&[[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectAtIndex: DIR_DOWN] isEqual:@1])
        return true;
    else return false;
}
-(BOOL) judgeUpLeft:(int)x :(int)y
{
    if ([[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectAtIndex: DIR_UP] isEqual:@1] && [[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectAtIndex: DIR_LEFT] isEqual:@1])
        return true;
    else return false;
}
-(BOOL) judgeUpRight:(int)x :(int)y
{
    if ([[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectAtIndex: DIR_UP] isEqual:@1]&& [[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectAtIndex: DIR_RIGHT] isEqual:@1])
        return true;
    else return false;
}
-(BOOL) judgeDownLeft:(int)x :(int)y
{
    if ([[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectAtIndex: DIR_DOWN] isEqual:@1]&&[[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectAtIndex: DIR_LEFT] isEqual:@1])
        return true;
    else return false;
}
-(BOOL) judgeDownRight:(int)x :(int)y
{
    if ([[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectAtIndex: DIR_DOWN] isEqual:@1] && [[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectAtIndex: DIR_RIGHT] isEqual:@1])
        return true;
    else return false;
}
-(void) collect:(int)x :(int)y
{
    CCLOG(@"collect");
    for(int n=0;n<[self.collectgroup count];++n)
    {  Spoint=[self.collectgroup objectAtIndex:n];
     
        
       if(((int)([Spoint position].x/_tile.width)==x&& (int)([Spoint position].y/_tile.height)==y))
       {
           [self setAction:Spoint];
           if([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectAtIndex:DIR_STATE] isEqual:@5])
           {
               [[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] replaceObjectAtIndex:DIR_STATE withObject:@1] ;
           }
           CCLOG(@"success");
           break;
       }
        else

    
            continue;
    }
 
        CCLOG(@"input %d %d ",x,y);
    
}
//NSObject *up=[[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] objectAtIndex: DIR_UP];
//NSObject *down=[[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] objectAtIndex: DIR_DOWN];
//NSObject *left=[[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] objectAtIndex: DIR_LEFT];
//NSObject*right=[[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] objectAtIndex: DIR_RIGHT];




@end





