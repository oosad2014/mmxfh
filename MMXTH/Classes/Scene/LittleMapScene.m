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

#import "LittleMapScene.h"


// -----------------------------------------------------------------

@implementation Newtest

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
@synthesize dataManager;
@synthesize collection;
@synthesize specialgroup;
static int trainskin=0;
int enemyDirection;

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
CCTexture *traintexup;
CCTexture *traintexdown;
CCTexture *traintexleft;
CCTexture *traintexright;
CCTexture *traintexpoint;
CCTexture *temp1;
CollectObj *Spoint;
NSDictionary *dress;

bool noway;
bool hasenemy=YES;
NSString *trainname=@"蓝火车";
+ (id)scene {
    return [[self alloc] init];
}


- (Newtest *)init {
    self = [super init];
    dataManager = [DataManager sharedManager];
    NSMutableArray *tracklist;
    NSDictionary *dictionary = [dataManager bundleDicWithName:@"GuangZhouMap"];
    collection=[[dataManager bundleDicWithName:@"Collection"]mutableCopy];
    dress=[dataManager documentDicWithName:@"TrainNow"];
    NSString *trainname1=[dress objectForKey:@"TrainSelected"];
    if([trainname1 isEqualToString:@"红火车左.png"])
    {
        trainname=@"红火车";
        trainskin=1;
    }
    if([trainname1 isEqualToString:@"蓝火车左.png"])
    {
        trainname=@"蓝火车";
        trainskin=0;
    }
    CCLOG(@" name is %@",dress);
    
//    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
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
    self.specialgroup=[[NSMutableArray alloc] init];
    tracklist=[[NSMutableArray alloc] init];
    
    _row=[[dictionary objectForKey:@"MapRow"] intValue];
    _column=[[dictionary objectForKey:@"MapCol"] intValue];

    CCNodeColor *bg = [CCNodeColor nodeWithColor:[CCColor blackColor]];
    _trainLoc.x=[[[dictionary objectForKey:@"TrainLocation"] objectAtIndex:0] doubleValue];
    _trainLoc.y=[[[dictionary objectForKey:@"TrainLocation"] objectAtIndex:1] doubleValue];
    _enemytrainLoc.x=[[[dictionary objectForKey:@"EnemyPos"] objectAtIndex:0] doubleValue];
    _enemytrainLoc.y=[[[dictionary objectForKey:@"EnemyPos"] objectAtIndex:1] doubleValue];
    tracklist=[dictionary objectForKey:@"Tracklist"];
//    _enemytrainLoc.x=5;
//    _enemytrainLoc.y=7;
//    _trainLoc.x=18;
//    _trainLoc.y=10;
    CCLOG(@"trainloc %f,%f",_trainLoc.x,_trainLoc.y);
    _goal.x=[[[dictionary objectForKey:@"TrainGoal"] objectAtIndex:0] doubleValue];
    _goal.y=[[[dictionary objectForKey:@"TrainGoal"] objectAtIndex:1] doubleValue];
    _start.x=[[[dictionary objectForKey:@"StartLoc"] objectAtIndex:0] doubleValue];
    _start.y=[[[dictionary objectForKey:@"StartLoc"] objectAtIndex:1] doubleValue];
    _preLoc = CGPointMake(0, 0);
    _nextLoc = CGPointMake(0, 0);
    NSString *dir=[dictionary objectForKey:@"TrainDir"];
    if([dir isEqualToString:@"Up"])
        trainDirection=TRAIN_DIRECTION_UP;
    if([dir isEqualToString:@"Down"])
         trainDirection=TRAIN_DIRECTION_DOWN;
    if([dir isEqualToString:@"Left"])
        trainDirection=TRAIN_DIRECTION_LEFT;
    if([dir isEqualToString:@"Right"])
         trainDirection=TRAIN_DIRECTION_RIGHT;
    
    _trainSpeedDuration=[[dictionary objectForKey:@"TrainSpeed"] floatValue];
    
   isTraveling = NO;
     isPaused = NO;
    noway=NO;
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
    
    for (int i=0; i<[[dictionary objectForKey:@"SpecialPlane"] count]; i++) {
        NSMutableArray *spec=[[dictionary objectForKey:@"SpecialPlane"] objectAtIndex:i];
        
        [self.specialgroup addObject:spec];
        
        
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
    NSString *up,*down,*left,*right;
    up= [trainname stringByAppendingString:@"上.png"];
    down= [trainname stringByAppendingString:@"下.png"];
    left= [trainname stringByAppendingString:@"左.png"];
    right= [trainname stringByAppendingString:@"右.png"];
    traintexup=[CCTexture textureWithFile:up];
    traintexdown=[CCTexture textureWithFile:down];
    traintexleft=[CCTexture textureWithFile:left];
    traintexright=[CCTexture textureWithFile:right];
    enemyDirection=trainDirection;
    
    switch (trainDirection)
    {
        case(1):
            traintexpoint=traintexup;
            break;
        case(2):
            traintexpoint=traintexdown;
            break;
        case(3):
            traintexpoint=traintexleft;
            break;
        case(4):
            traintexpoint=traintexright;
            break;
        default:
            break;
    }
    
    //铁轨数组
    
  

    for (int i=0; i<24; i++) {
        
        NSMutableArray *rowArray = [[NSMutableArray alloc] init];
        for (int j=0; j<14; j++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:7];
            [dic setObject:@0    forKey:@"Up"];
            [dic setObject:@0    forKey:@"Down"];
            [dic setObject:@0    forKey:@"Left"];
            [dic setObject:@0    forKey:@"Right"];
            [dic setObject:@0   forKey:@"State"];
            [dic setObject:@"Null"    forKey:@"Direction"];
             [dic setObject:@0    forKey:@"Removeable"];
           
            [rowArray addObject:dic];
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

        [[[self.meshData objectAtIndex:itempoint.x] objectAtIndex:itempoint.y] setObject:@3 forKey:@"State"];
        [self addChild:item z:13];

    }
//    -(BOOL) judgeLeftRight:(int)x :(int)y
//    {
//        CCLOG(@"in judge");
//        if ([[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectForKey:@"Left"] isEqual:@1] && [[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectForKey:@"Right"] isEqual:@1])
//            return true;
//        else return false;
//    }
//    -(BOOL) judgeUpDown:(int)x :(int)y
//    {
//        if ([[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectForKey:@"Up"] isEqual:@1] &&[[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectForKey:@"Down"] isEqual:@1])
//            return true;
//        else return false;
//    }
//    -(BOOL) judgeUpLeft:(int)x :(int)y
//    {
//        if ([[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectForKey:@"Up"] isEqual:@1] && [[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectForKey:@"Left"] isEqual:@1])
//            return true;
//        else return false;
//    }
//    -(BOOL) judgeUpRight:(int)x :(int)y
//    {
//        if ([[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectForKey:@"Up"] isEqual:@1]&& [[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectForKey:@"Right"] isEqual:@1])
//            return true;
//        else return false;
//    }
//    -(BOOL) judgeDownLeft:(int)x :(int)y
//    {
//        if ([[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectForKey:@"Down"] isEqual:@1]&&[[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectForKey:@"Left"] isEqual:@1])
//            return true;
//        else return false;
//    }
//    -(BOOL) judgeDownRight:(int)x :(int)y
//    {
//        if ([[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectForKey:@"Down"] isEqual:@1] && [[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectForKey:@"Right"] isEqual:@1])
//            return true;
//        else return false;
//    }

    for(int i=0;i<[tracklist count];i++)
    { NSMutableArray *points=[tracklist objectAtIndex:i];
      CGPoint trackpoint;
      NSString *dir=[points objectAtIndex:0];
      trackpoint.x=[[points objectAtIndex:1] intValue];
      trackpoint.y=[[points objectAtIndex:2] intValue];
      if([dir isEqual:@"leftright"])
      {
          [[[self.meshData objectAtIndex:trackpoint.x] objectAtIndex:trackpoint.y]setObject:@1 forKey: @"Left"] ;
          [[[self.meshData objectAtIndex:trackpoint.x] objectAtIndex:trackpoint.y] setObject:@1 forKey:@"Right"] ;
          
      }
        if([dir isEqual:@"updown"])
        {
            [[[self.meshData objectAtIndex:trackpoint.x] objectAtIndex:trackpoint.y]setObject:@1 forKey: @"Up"] ;
            [[[self.meshData objectAtIndex:trackpoint.x] objectAtIndex:trackpoint.y] setObject:@1 forKey:@"Down"] ;
        }
        if([dir isEqual:@"upleft"])
        {
            [[[self.meshData objectAtIndex:trackpoint.x] objectAtIndex:trackpoint.y]setObject:@1 forKey: @"Up"] ;
            [[[self.meshData objectAtIndex:trackpoint.x] objectAtIndex:trackpoint.y] setObject:@1 forKey:@"Left"] ;
        }
        if([dir isEqual:@"upright"])
        {
            [[[self.meshData objectAtIndex:trackpoint.x] objectAtIndex:trackpoint.y]setObject:@1 forKey: @"Up"] ;
            [[[self.meshData objectAtIndex:trackpoint.x] objectAtIndex:trackpoint.y] setObject:@1 forKey:@"Right"] ;
        }
        if([dir isEqual:@"downleft"])
        {
            [[[self.meshData objectAtIndex:trackpoint.x] objectAtIndex:trackpoint.y]setObject:@1 forKey: @"Down"] ;
            [[[self.meshData objectAtIndex:trackpoint.x] objectAtIndex:trackpoint.y] setObject:@1 forKey:@"Left"] ;
        }
        if([dir isEqual:@"downright"])
        {
            [[[self.meshData objectAtIndex:trackpoint.x] objectAtIndex:trackpoint.y]setObject:@1 forKey: @"Down"] ;
            [[[self.meshData objectAtIndex:trackpoint.x] objectAtIndex:trackpoint.y] setObject:@1 forKey:@"Right"] ;
        }
        [self createRailTargetX:trackpoint.x TargetY:trackpoint.y];
        

    }
    for(int i=0;i<[self.collectionsarray count];i++)
    {   NSMutableArray *points=[self.collectionsarray objectAtIndex:i];
       
        CGPoint itempoint;
        itempoint.x=[[points objectAtIndex:0] doubleValue];
        itempoint.y=[[points objectAtIndex:1] doubleValue];
        int index=[[points  objectAtIndex:2] doubleValue];
        NSString *kind=[[self.scenekinds objectAtIndex:index]objectAtIndex:0];
        CCTexture *new=[CCTexture textureWithFile:kind];
        CollectObj *item=[CollectObj spriteWithTexture:new];
        [item setCount:[[[self.scenekinds objectAtIndex:index]objectAtIndex:1] intValue]];
        item.scaleY = _tile.height/item.contentSize.height;
        item.scaleX = _tile.width/item.contentSize.width;
        [item setPosition:CGPointMake((itempoint.x)*_tile.width+_tile.width/2.0f, (itempoint.y)*_tile.height+_tile.height/2.0f)];

        
        [[[self.meshData objectAtIndex:itempoint.x] objectAtIndex:itempoint.y] setObject:@4 forKey:@"State"];
        [self addChild:item z:13];
        [self.collectgroup addObject:item];
    }
    
    for(int i=0;i<[self.specialgroup count];i++)
    {   NSMutableArray *points=[self.specialgroup objectAtIndex:i];
        
        int x,y,z;
        z=[[points objectAtIndex:0] intValue];
        x=[[points objectAtIndex:1] intValue];
        y=[[points objectAtIndex:2] intValue];
        if(trainskin==z)
          [[[self.meshData objectAtIndex:x] objectAtIndex:y] setObject:@0 forKey:@"State"];
        else  [[[self.meshData objectAtIndex:x] objectAtIndex:y] setObject:@-1 forKey:@"State"];;
        
       

    }

    
    _train = [CCSprite spriteWithTexture:traintexpoint];
    _train.scaleY = (_tile.height/_train.contentSize.height);
    _train.scaleX = 1.5*(_tile.width/_train.contentSize.width);
    [_train setPosition:CGPointMake((_trainLoc.x)*_tile.width+_tile.width/2.0f, (_trainLoc.y)*_tile.height+_tile.height/2.0f)];
    [self addChild:_train z:13];
    if(hasenemy){
    _enemytrain=[CCSprite spriteWithTexture:traintexpoint];
    _enemytrain.scaleY = (_tile.height/_enemytrain.contentSize.height);
    _enemytrain.scaleX = 1.5*(_tile.width/_enemytrain.contentSize.width);
    [_enemytrain setPosition:CGPointMake((_enemytrainLoc.x)*_tile.width+_tile.width/2.0f, (_enemytrainLoc.y)*_tile.height+_tile.height/2.0f)];
        [self addChild:_enemytrain z:13];}
    CCLOG(@"init pos %f,%f",_train.position.x,_train.position.y);

    //放置终点
    
    
    
       CCTexture *new=[CCTexture textureWithFile:@"终点.png"];
    CCSprite *goal=[CCSprite spriteWithTexture:new];
    goal.scaleY = _tile.height/goal.contentSize.height;
    goal.scaleX = 1.5*_tile.width/goal.contentSize.width;
    [goal setPosition:CGPointMake((_goal.x)*_tile.width+_tile.width/2.0f, (_goal.y)*_tile.height+_tile.height/2.0f)];
    [[[self.meshData objectAtIndex:_goal.x] objectAtIndex:_goal.y] setObject:@2 forKey:@"State"];
    [self addChild:goal z:11];
    
    
    CCTexture *begin=[CCTexture textureWithFile:@"起点.png"];
    CCSprite *beginp=[CCSprite spriteWithTexture:begin];
    beginp.scaleY = _tile.height/beginp.contentSize.height;
    beginp.scaleX = 1.5*_tile.width/beginp.contentSize.width;
    [beginp setPosition:CGPointMake((_start.x)*_tile.width+_tile.width/2.0f, (_start.y)*_tile.height+_tile.height/2.0f)];
    [[[self.meshData objectAtIndex:_start.x] objectAtIndex:_start.y] setObject:@3 forKey:@"State"];
    [self addChild:beginp z:11];


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
    
    
    CCButton *button1 = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"重新游戏.png"]];
    button1.scaleY = (_tile.height/button1.contentSize.height)*1.5;
    button1.scaleX = (_tile.width/button1.contentSize.width)*1.5;
    [button1 setTarget:self selector:@selector(onMoeRetryClicked:)];
    [button1 setPosition:CGPointMake(0*_tile.width+_tile.width/2.0f, 1*_tile.height+_tile.height/2.0f)];
    [self addChild:button1 z:12];
    
    CCButton *button2 = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"开始.png"]];
    button2.scaleY = (_tile.height/button2.contentSize.height)*1.5;
    button2.scaleX = (_tile.width/button2.contentSize.width)*1.5;
    [button2 setTarget:self selector:@selector(onTravelModeClicked:)];
    [button2 setPosition:CGPointMake(1*_tile.width+_tile.width/2.0f, 1*_tile.height+_tile.height/2.0f)];
    [self addChild:button2 z:12];
    
    CCButton *button3 = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"删除铁轨.png"]];
    button3.scaleY = (_tile.height/button3.contentSize.height)*1.5;
    button3.scaleX = (_tile.width/button3.contentSize.width)*1.5;
    [button3 setTarget:self selector:@selector(onDeletemodeClicked:)];
    [button3 setPosition:CGPointMake(2*_tile.width+_tile.width/2.0f, 1*_tile.height+_tile.height/2.0f)];
    [self addChild:button3 z:12];
    
    CCButton *button4 = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"铺设铁轨.png"]];
    button4.scaleY = (_tile.height/button4.contentSize.height)*1.5;
    button4.scaleX = (_tile.width/button4.contentSize.width)*1.5;
   
    [button4 setTarget:self selector:@selector(onDrawmodeClicked:)];
    [button4 setPosition:CGPointMake(3*_tile.width+_tile.width/2.0f, 1*_tile.height+_tile.height/2.0f)];
    [self addChild:button4 z:12];
    
    CCButton *button5 = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"暂停.png"]];
    button5.scaleY = (_tile.height/button5.contentSize.height)*1.6;
    button5.scaleX = (_tile.width/button5.contentSize.width)*1.6;
    
    [button5 setTarget:self selector:@selector(onPauseClicked:)];
    [button5 setPosition:CGPointMake(23*_tile.width+_tile.width/2.0f, 13*_tile.height+_tile.height/2.0f)];
    [self addChild:button5 z:12];

   
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
            if ((diff.x!=0 | diff.y!=0)) {
                //select the present point
                _presentLoc = _nextLoc;
                isPresentSelected = true;
                if (fabs(diff.x)>fabs(diff.y)) {
                    if (diff.x > 0) {

                        //presentLoc is rightward
                        [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] setObject:@1 forKey:@"Left"];

                    }
                    else{


                        //presentLoc is leftward
                         [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] setObject:@1 forKey:@"Right"];
 
                    }
                }
                else{
                    if (diff.y > 0) {
                        //presentLoc is upward
                        [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] setObject:@1 forKey:@"Down"];

                    }
                    else{
                        //presentLoc is downward
                        [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] setObject:@1 forKey:@"Up"];

                    }
                    
                }
            }}
        else{
            CGPoint diff = ccpSub(_nextLoc, _presentLoc);
            if (diff.x!=0 | diff.y!=0) {
                if (fabs(diff.x)>fabs(diff.y)) {
                    if (diff.x > 0) {
                        [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] setObject:@1 forKey:@"Right"];

                    }
                    else{
                        //nextLoc is leftward
                        
                        [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] setObject:@1 forKey:@"Left"];
                       
                    }
                }
                else{
                    if (diff.y > 0) {
                        //nextLoc is upward
                        [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] setObject:@1 forKey:@"Up"];
                   
                    }
                    else{
                        //nextLoc is downward
                        [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] setObject:@1 forKey:@"Down"];
                    
                    }
                }
                
                
                //When isEdited == NO,build the rail
              
                if ([[[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] objectForKey:@"State"] isEqual:@0]|| [[[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] objectForKey:@"State"] isEqual:@4]) {

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
    if(![[[[self.meshData objectAtIndex:(int)targetX] objectAtIndex:(int)targetY] objectForKey:@"State"] isEqualToValue:@4])
    [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] setObject:@1 forKey:@"State" ];
    else
        [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] setObject:@5 forKey:@"State"];

    //NSInteger state=[[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] objectAtIndex: DIR_STATE];

    NSString *temp=@"train.png";

    CCSprite *track=[[CCSprite alloc]init];

    if ([self judgeLeftRight:targetX :targetY]){
       temp=@"rail-left-right1.png";
        [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] setObject:@"LeftRight" forKey:@"Direction"];
        [self resetstate:1 :targetX :targetY];

        
    }
    else if ([self judgeUpDown:targetX :targetY]){
           temp=@"rail-up-down1.png";
        [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] setObject:@"Updown" forKey:@"Direction"];
[self resetstate:2 :targetX :targetY];
        
    }
    else if ([self judgeUpLeft:targetX :targetY]){
          temp=@"rail-up-left1.png";
        [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] setObject:@"UpLeft" forKey:@"Direction"];
[self resetstate:3 :targetX :targetY];
    }
    else if ([self judgeUpRight:targetX :targetY]){
       temp=@"rail-up-right1.png";
        [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] setObject:@"UpRight" forKey:@"Direction"];
[self resetstate:4 :targetX :targetY];
    }
    else if ([self judgeDownLeft:targetX :targetY]){
              temp=@"rail-down-left1.png";
        [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] setObject:@"DownLeft" forKey:@"Direction"];
        [self resetstate:5 :targetX :targetY];

    }
    else if ([self judgeDownRight:targetX :targetY]){
        [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] setObject:@"DownRight" forKey:@"Direction"];
        temp=@"rail-down-right1.png";
        [self resetstate:6 :targetX :targetY];

    }
    else{
        if(![[[[self.meshData objectAtIndex:(int)targetX] objectAtIndex:(int)targetY] objectForKey:@"State"]isEqual:@5])
          [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] setObject:@0 forKey:@"State"];
        else
              [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] setObject:@4 forKey:@"State"];
        [self resetstate:0 :targetX :targetY];
       
    }
    if(![temp isEqualToString:@"train.png"]){
        track=[CCSprite spriteWithImageNamed:temp];
        track.scaleY = _tile.height/track.contentSize.height;
    track.scaleX = _tile.width/track.contentSize.width;
    [track setPosition:CGPointMake(targetX*_tile.width+_tile.width/2.0f, targetY*_tile.height+_tile.height/2.0f)
];
        [self addChild:track z:10];
        [self.railGroup addObject:track];
        [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] setObject:@1 forKey:@"Removeable"];

    }
 
    
    
        }

-(void)onTrainTravelAction{
    switch (trainDirection) {

            
        case TRAIN_DIRECTION_UP:
                    {   [_train setTexture:traintexup];
            _train.scaleY = 1.5*_tile.height/_train.contentSize.height;
            _train.scaleX = _tile.width/_train.contentSize.width;
            if(_trainLoc.y==23)
            {
                [self gameFinished:NO];
            }
            
            CCAction *goUp = [CCActionMoveBy actionWithDuration:_trainSpeedDuration position:CGPointMake(0.0f, _tile.height)];
            [self->_train runAction:goUp];
               _trainLoc.y += 1.0f;

            if([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@5]||[[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@4])
            {
                [self collect:(int)_trainLoc.x :(int)_trainLoc.y];
            }
            
           if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"Direction"]isEqualToString:@"DownLeft"]){
                trainDirection = TRAIN_DIRECTION_LEFT;
             

               
            }
           else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"Direction"]isEqualToString:@"DownRight"]){
                trainDirection = TRAIN_DIRECTION_RIGHT;
      

            }
           else{
               if([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@2]){
                   
                   [self gameFinished:YES];
               }
              
               
               
               else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@0]||[[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@3])
               {[self gameFinished:NO];
               }
               
           }
            break;
        }
        case TRAIN_DIRECTION_DOWN:
        {
            [_train setTexture:traintexdown];
            _train.scaleY = 1.5*_tile.height/_train.contentSize.height;
            _train.scaleX = _tile.width/_train.contentSize.width;
            if(_trainLoc.y==0)
            {
                [self gameFinished:NO];
            }
            CCAction *goDown = [CCActionMoveBy actionWithDuration:_trainSpeedDuration position:CGPointMake(0.0f, -_tile.height)];
            
            [self->_train runAction:goDown];
           _trainLoc.y -= 1.0f;
         
            if([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@5]||[[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@4])
            {
                [self collect:(int)_trainLoc.x :(int)_trainLoc.y];
            }
         
             if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"Direction"]isEqualToString:@"UpLeft"]){
                trainDirection = TRAIN_DIRECTION_LEFT;
               

            }
            else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"Direction"]isEqualToString:@"UpRight"]){
                
                trainDirection = TRAIN_DIRECTION_RIGHT;
                
            }
            else{
                if([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@2]){
                    
                    [self gameFinished:YES];
                }

                else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@0]||[[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@3]||[[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@4])
                {[self gameFinished:NO];
                }
                
                
                
            }
            break;
        }
        case TRAIN_DIRECTION_LEFT:
        {
            [_train setTexture:traintexleft];
            _train.scaleY = _tile.height/_train.contentSize.height;
            _train.scaleX = 1.5*_tile.width/_train.contentSize.width;
            if(_trainLoc.x==0)
            {
                [self gameFinished:NO];
            }
            CCAction *goLeft = [CCActionMoveBy actionWithDuration:_trainSpeedDuration position:CGPointMake(-_tile.width, 0)];
            [self->_train runAction:goLeft];
             _trainLoc.x-=1.0f;
            if([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@5])
            {
                [self collect:(int)_trainLoc.x :(int)_trainLoc.y];
            }
          if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"Direction"]isEqualToString:@"DownRight"]){
                
                trainDirection = TRAIN_DIRECTION_DOWN;
        
            }
            else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"Direction"]isEqualToString:@"UpRight"]){
                
                trainDirection = TRAIN_DIRECTION_UP;
            
           
            }
            else{
                if([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@2]){
                    
                    [self gameFinished:YES];
                }
                
                
                else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@0]||[[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@3])
                {[self gameFinished:NO];
                }
                
            }
            break;
        }
        case TRAIN_DIRECTION_RIGHT:
        {
            [_train setTexture:traintexright];
            _train.scaleY = _tile.height/_train.contentSize.height;
            _train.scaleX = 1.5*_tile.width/_train.contentSize.width;
            if(_trainLoc.x==23)
            {
                [self gameFinished:NO];
            }
            CCAction *goRight = [CCActionMoveBy actionWithDuration:_trainSpeedDuration position:CGPointMake(_tile.width, 0)];
            [self->_train runAction:goRight];
           _trainLoc.x+=1.0f;
            if([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@5])
            {
                [self collect:(int)_trainLoc.x :(int)_trainLoc.y];
            }
            if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"Direction"]isEqualToString:@"DownLeft"]){
                
                trainDirection = TRAIN_DIRECTION_DOWN;
            

            }
            else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"Direction"]isEqualToString:@"UpLeft"]){
                
                trainDirection = TRAIN_DIRECTION_UP;
              
            }
            else{
                if([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@2]){
                    
                    [self gameFinished:YES];
                }
                

               
                else if ([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@0]||[[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@3])
                {[self gameFinished:NO];

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
        if(hasenemy){
        [self onEnemyTravelAction];
        }
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
        
        pauseTexture = [CCRenderTexture renderTextureWithWidth:self.contentSize.width height:self.contentSize.height];
        
        // 相关操作（记住就好）
        
        [pauseTexture begin];
        [self visit];
        [pauseTexture end];
        
        // 加载暂停界面
        [[CCDirector sharedDirector] pushScene:[[PauseScene scene] initWithParameter:pauseTexture] withTransition: [CCTransition transitionPushWithDirection:CCTransitionDirectionInvalid duration:1.0f]];
        CCLOG(@"Lose");
    }
  
    
}

-(void) setAction:(CCSprite *) m_actor
{
   
    
    id rotate=[CCActionRotateBy actionWithDuration:0.5 angle:360];
    id scale=[CCActionScaleBy actionWithDuration:0.5 scale:0.7];
    id moveto=[CCActionMoveTo actionWithDuration:5 position:CGPointMake(1*_tile.width+_tile.width/2.0f, 12*_tile.height+_tile.height/2.0f)];
   // id delete=[CCActionCallFunc actionWithTarget:m_actor selector:@selector(CallBack1:)];
    id delete=[CCActionRemove action ];
    id moveset=[CCActionSpawn actions: rotate,scale,nil];
    //循环这个并行的组合序列
    id repeatAct = [CCActionRepeat actionWithAction:moveset times:8];
    id bingxingAct=[CCActionSpawn actions: repeatAct,moveto,nil];
    id xianxing=[CCActionSequence actions: bingxingAct,delete,nil];
    
    [m_actor runAction:xianxing];
    
    //启动action
    
}

-(void)deleteSpriteTouching:(CGPoint)touchLocation{   if (![[[[self.meshData objectAtIndex:(int)(touchLocation.x/_tile.width)] objectAtIndex:(int)(touchLocation.y/_tile.height)] objectForKey:@"Removeable"] isEqual:@1]) {
    return;
}
    for (CCSprite *sprite in self.railGroup) {
        if(CGRectContainsPoint(sprite.boundingBox, touchLocation)){
            [sprite removeFromParentAndCleanup:YES];
            [self resetstate:(int)0 :(int)(touchLocation.x/_tile.width) :(int)(touchLocation.y/_tile.height)];
            [self.railGroup removeObjectAtIndex:[self.railGroup indexOfObject:sprite]];
            if([[[[self.meshData objectAtIndex:(int)(touchLocation.x/_tile.width)] objectAtIndex:(int)(touchLocation.y/_tile.height)] objectForKey:@"State"] isEqual:@1])
            {[[[self.meshData objectAtIndex:(int)(touchLocation.x/_tile.width)] objectAtIndex:(int)(touchLocation.y/_tile.height)] setObject:@0 forKey:@"State"];

            }
            else if([[[[self.meshData objectAtIndex:(int)(touchLocation.x/_tile.width)] objectAtIndex:(int)(touchLocation.y/_tile.height)] objectForKey:@"State"] isEqual:@5])
            {CCLOG(@"set0");
                [[[self.meshData objectAtIndex:(int)(touchLocation.x/_tile.width)] objectAtIndex:(int)(touchLocation.y/_tile.height)] setObject:@4 forKey:@"State"];
            }
                
            CCLOG(@"can be delete");
            break;
        }
    }
  
}
-(BOOL) judgeLeftRight:(int)x :(int)y
{
    CCLOG(@"in judge");
     if ([[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectForKey:@"Left"] isEqual:@1] && [[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectForKey:@"Right"] isEqual:@1])
         return true;
     else return false;
}
-(BOOL) judgeUpDown:(int)x :(int)y
{
    if ([[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectForKey:@"Up"] isEqual:@1] &&[[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectForKey:@"Down"] isEqual:@1])
        return true;
    else return false;
}
-(BOOL) judgeUpLeft:(int)x :(int)y
{
    if ([[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectForKey:@"Up"] isEqual:@1] && [[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectForKey:@"Left"] isEqual:@1])
        return true;
    else return false;
}
-(BOOL) judgeUpRight:(int)x :(int)y
{
    if ([[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectForKey:@"Up"] isEqual:@1]&& [[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectForKey:@"Right"] isEqual:@1])
        return true;
    else return false;
}
-(BOOL) judgeDownLeft:(int)x :(int)y
{
    if ([[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectForKey:@"Down"] isEqual:@1]&&[[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectForKey:@"Left"] isEqual:@1])
        return true;
    else return false;
}
-(BOOL) judgeDownRight:(int)x :(int)y
{
    if ([[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectForKey:@"Down"] isEqual:@1] && [[[[self.meshData objectAtIndex:x] objectAtIndex:y] objectForKey:@"Right"] isEqual:@1])
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
           int index=[Spoint getCount];
           NSMutableArray *temp=[[collection objectForKey:@"collectionArr"] mutableCopy];
           [temp replaceObjectAtIndex:index withObject:@1];
           [self.collection setObject:temp forKey:@"collectionArr"];
           CCLOG(@"aaa %d",[[[collection objectForKey:@"collectionArr"] objectAtIndex:index] intValue]);
           [self setAction:Spoint];
           if([[[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] objectForKey:@"State"] isEqual:@5])
           {
               [[[self.meshData objectAtIndex:(int)_trainLoc.x] objectAtIndex:(int)_trainLoc.y] setObject:@1 forKey:@"State"] ;
           }
           CCLOG(@"success");
           break;
       }
        else

    
            continue;
    }
    [dataManager writeDicWithName:@"Collection" Dic:collection];
 
        CCLOG(@"input %d %d ",x,y);
    
}

//}

-(void) resetstate:(int)mod :(int)x :(int)y
{
    switch (mod) {
        case 0:
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@0 forKey:@"Up"] ;
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@0 forKey:@"Down"];
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@0 forKey:@"Left"];
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@0 forKey:@"Right"];
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@"Null" forKey:@"Direction"] ;
            break;
        case 1:
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@0 forKey:@"Up"] ;
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@0 forKey:@"Down"];
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@1 forKey:@"Left"];
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@1 forKey:@"Right"];
            break;
        case 2:
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@1 forKey:@"Up"] ;
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@1 forKey:@"Down"];
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@0 forKey:@"Left"];
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@0 forKey:@"Right"];
            break;
        case 3:
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@1 forKey:@"Up"] ;
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@0 forKey:@"Down"];
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@1 forKey:@"Left"];
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@0 forKey:@"Right"];
            break;
        case 4:
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@1 forKey:@"Up"] ;
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@0 forKey:@"Down"];
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@0 forKey:@"Left"];
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@1 forKey:@"Right"];
            break;
        case 5:
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@0 forKey:@"Up"] ;
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@1 forKey:@"Down"];
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@1 forKey:@"Left"];
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@0 forKey:@"Right"];
            break;
        case 6:
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@0 forKey:@"Up"] ;
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@1 forKey:@"Down"];
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@0 forKey:@"Left"];
            [[[self.meshData objectAtIndex:(int)x] objectAtIndex:(int)y] setObject:@1 forKey:@"Right"];
            break;
            
        default:
            break;
    }



}
-(void) onPauseClicked:(id) sender
{
    pauseTexture = [CCRenderTexture renderTextureWithWidth:self.contentSize.width height:self.contentSize.height];
    
    // 相关操作（记住就好）
    
    [pauseTexture begin];
    [self visit];
    [pauseTexture end];
    
    // 加载暂停界面
    [[CCDirector sharedDirector] pushScene:[[PauseScene scene] initWithParameter:pauseTexture] withTransition: [CCTransition transitionPushWithDirection:CCTransitionDirectionInvalid duration:1.0f]];
}
//NSObject *up=[[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] objectAtIndex: DIR_UP];
//NSObject *down=[[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] objectAtIndex: DIR_DOWN];
//NSObject *left=[[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] objectAtIndex: DIR_LEFT];
//NSObject*right=[[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] objectAtIndex: DIR_RIGHT];
-(void)onEnemyTravelAction{
    switch (enemyDirection) {
            
            
        case TRAIN_DIRECTION_UP:
        {   [_enemytrain setTexture:traintexup];
            _enemytrain.scaleY = 1.5*_tile.height/_enemytrain.contentSize.height;
            _enemytrain.scaleX = _tile.width/_enemytrain.contentSize.width;
            if([[[[self.meshData objectAtIndex:(int)_enemytrainLoc.x] objectAtIndex:(int)_enemytrainLoc.y] objectForKey:@"State"] isEqual:@0]||_enemytrainLoc.y+1>=14)
            {noway=YES;
            }
            CCAction *goUp = [CCActionMoveBy actionWithDuration:_trainSpeedDuration position:CGPointMake(0.0f, _tile.height)];
            [self->_enemytrain runAction:goUp];
            _enemytrainLoc.y += 1.0f;
            if ([[[[self.meshData objectAtIndex:(int)_enemytrainLoc.x] objectAtIndex:(int)_enemytrainLoc.y] objectForKey:@"State"] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_enemytrainLoc.x] objectAtIndex:(int)_enemytrainLoc.y] objectForKey:@"Direction"]isEqualToString:@"DownLeft"]){
                enemyDirection = TRAIN_DIRECTION_LEFT;
            }
            else if ([[[[self.meshData objectAtIndex:(int)_enemytrainLoc.x] objectAtIndex:(int)_enemytrainLoc.y] objectForKey:@"State"] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_enemytrainLoc.x] objectAtIndex:(int)_enemytrainLoc.y] objectForKey:@"Direction"]isEqualToString:@"DownRight"]){
                enemyDirection = TRAIN_DIRECTION_RIGHT;
                
                
            }
            if([[[[self.meshData objectAtIndex:(int)_enemytrainLoc.x] objectAtIndex:(int)_enemytrainLoc.y] objectForKey:@"State"] isEqual:@5])
            {
                [self gameFinished:(NO)];
            }
            if(_enemytrainLoc.x==_trainLoc.x&&_enemytrainLoc.y==_trainLoc.y)
            {
                [self gameFinished:(NO)];
            }
 
            break;
        }
        case TRAIN_DIRECTION_DOWN:
        {
            [_enemytrain setTexture:traintexdown];
            _enemytrain.scaleY = 1.5*_tile.height/_enemytrain.contentSize.height;
            _enemytrain.scaleX = _tile.width/_enemytrain.contentSize.width;
            if([[[[self.meshData objectAtIndex:(int)_enemytrainLoc.x] objectAtIndex:(int)_enemytrainLoc.y] objectForKey:@"State"] isEqual:@0]||_enemytrainLoc.y-1<=0)
            {noway=YES;
            }
            CCAction *goDown = [CCActionMoveBy actionWithDuration:_trainSpeedDuration position:CGPointMake(0.0f, -_tile.height)];
            [self->_enemytrain runAction:goDown];
            _enemytrainLoc.y -= 1.0f;
            if ([[[[self.meshData objectAtIndex:(int)_enemytrainLoc.x] objectAtIndex:(int)_enemytrainLoc.y] objectForKey:@"State"] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_enemytrainLoc.x] objectAtIndex:(int)_enemytrainLoc.y] objectForKey:@"Direction"]isEqualToString:@"UpLeft"]){
                enemyDirection = TRAIN_DIRECTION_LEFT;
            }
            else if ([[[[self.meshData objectAtIndex:(int)_enemytrainLoc.x] objectAtIndex:(int)_enemytrainLoc.y] objectForKey:@"State"] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_enemytrainLoc.x] objectAtIndex:(int)_enemytrainLoc.y] objectForKey:@"Direction"]isEqualToString:@"UpRight"]){
                
                enemyDirection = TRAIN_DIRECTION_RIGHT;
         
            }
            if([[[[self.meshData objectAtIndex:(int)_enemytrainLoc.x] objectAtIndex:(int)_enemytrainLoc.y] objectForKey:@"State"] isEqual:@5])
            {
                [self gameFinished:(NO)];
            }
            
            break;
        }
        case TRAIN_DIRECTION_LEFT:
        {
            [_enemytrain setTexture:traintexleft];
            _enemytrain.scaleY = _tile.height/_enemytrain.contentSize.height;
            _enemytrain.scaleX = 1.5*_tile.width/_enemytrain.contentSize.width;
            if([[[[self.meshData objectAtIndex:(int)_enemytrainLoc.x] objectAtIndex:(int)_enemytrainLoc.y] objectForKey:@"State"] isEqual:@0]||_enemytrainLoc.x-1<=0)
            {noway=YES;
            }
            CCAction *goLeft = [CCActionMoveBy actionWithDuration:_trainSpeedDuration position:CGPointMake(-_tile.width, 0)];
            [self->_enemytrain runAction:goLeft];
            _enemytrainLoc.x-=1.0f;
            if ([[[[self.meshData objectAtIndex:(int)_enemytrainLoc.x] objectAtIndex:(int)_enemytrainLoc.y] objectForKey:@"State"] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_enemytrainLoc.x] objectAtIndex:(int)_enemytrainLoc.y] objectForKey:@"Direction"]isEqualToString:@"DownRight"]){
                
                enemyDirection = TRAIN_DIRECTION_DOWN;
                
            }
            else if ([[[[self.meshData objectAtIndex:(int)_enemytrainLoc.x] objectAtIndex:(int)_enemytrainLoc.y] objectForKey:@"State"] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_enemytrainLoc.x] objectAtIndex:(int)_enemytrainLoc.y] objectForKey:@"Direction"]isEqualToString:@"UpRight"]){
                
                enemyDirection = TRAIN_DIRECTION_UP;
                
                
            }
            if([[[[self.meshData objectAtIndex:(int)_enemytrainLoc.x] objectAtIndex:(int)_enemytrainLoc.y] objectForKey:@"State"] isEqual:@5])
            {
                [self gameFinished:(NO)];
            }
            if(_enemytrainLoc.x==_trainLoc.x&&_enemytrainLoc.y==_trainLoc.y)
            {
                [self gameFinished:(NO)];
            }
                        break;
        }
        case TRAIN_DIRECTION_RIGHT:
        {
            [_enemytrain setTexture:traintexright];
            _enemytrain.scaleY = _tile.height/_enemytrain.contentSize.height;
            _enemytrain.scaleX = 1.5*_tile.width/_enemytrain.contentSize.width;
            CCAction *goRight = [CCActionMoveBy actionWithDuration:_trainSpeedDuration position:CGPointMake(_tile.width, 0)];
            if([[[[self.meshData objectAtIndex:(int)_enemytrainLoc.x] objectAtIndex:(int)_enemytrainLoc.y] objectForKey:@"State"] isEqual:@0]||_enemytrainLoc.x+1>=24)
            {noway=YES;
                
            }
            [self->_enemytrain runAction:goRight];
            _enemytrainLoc.x+=1.0f;
            if ([[[[self.meshData objectAtIndex:(int)_enemytrainLoc.x] objectAtIndex:(int)_enemytrainLoc.y] objectForKey:@"State"] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_enemytrainLoc.x] objectAtIndex:(int)_enemytrainLoc.y] objectForKey:@"Direction"]isEqualToString:@"DownLeft"]){
                
                enemyDirection = TRAIN_DIRECTION_DOWN;
                
                
            }
            else if ([[[[self.meshData objectAtIndex:(int)_enemytrainLoc.x] objectAtIndex:(int)_enemytrainLoc.y] objectForKey:@"State"] isEqual:@1] && [[[[self.meshData objectAtIndex:(int)_enemytrainLoc.x] objectAtIndex:(int)_enemytrainLoc.y] objectForKey:@"Direction"]isEqualToString:@"UpLeft"]){
                
                enemyDirection = TRAIN_DIRECTION_UP;
                
            }
            if([[[[self.meshData objectAtIndex:(int)_enemytrainLoc.x] objectAtIndex:(int)_enemytrainLoc.y] objectForKey:@"State"] isEqual:@5])
            {
                [self gameFinished:(NO)];
            }
            if(_enemytrainLoc.x==_trainLoc.x&&_enemytrainLoc.y==_trainLoc.y)
            {
                [self gameFinished:(NO)];
            }
            
            break;
        }
        default:
            break;
    }
    if(!isPaused&&!noway)self.timer =[NSTimer scheduledTimerWithTimeInterval:_trainSpeedDuration target:self selector:@selector(onEnemyTravelAction) userInfo:nil repeats:NO];
}



@end





