//
//  ShopScene.m
//  MMXTH
//
//  Created by mac on 16/10/6.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "ShopScene.h"
#import "Shop.h"

#define GOODS_ONE_SECNE 6

@implementation ShopScene {
    Shop *shop;
    int sceneNum;
    int sceneCount;
}

@synthesize goodsArray;
@synthesize nextButton;
@synthesize lastButton;

+ (ShopScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    if ((self = [super init])) {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    }
    // 暂时不知道为什么必须定义一个CCNodeColor才能使用触屏功能
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:27.0f/255.0f green:185.0f/255.0f blue:239.0f/255.0f alpha:1.0f]];
    [self addChild:background];
    [self setSceneNum:1]; // SceneNum从1记起
    shop = [Shop oneShop]; // 获取单例类实例
    goodsArray = shop.goodsShopArray;
    [self setSceneCount:([goodsArray count] / GOODS_ONE_SECNE)];
    
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
    
    lastButton = [CCButton buttonWithTitle:@"Last" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]];
    [lastButton setTarget:self selector:@selector(onLastButtonClicked:)];
    [lastButton setEnabled:NO];
    lastButton.positionType = CCPositionTypeNormalized;
    [lastButton setPosition:ccp(0.1f, 0.9f)];
    
    CCLabelTTF *lastTitle = [CCLabelTTF labelWithString:@"Last" fontName:@"ArialMT" fontSize:20];
    lastTitle.color = [CCColor redColor];
    lastTitle.positionType = CCPositionTypeNormalized;
    lastTitle.position = ccp(0.1f, 0.9f);
    
    
    [self addChild:lastButton z:9];
    [self addChild:lastTitle z:10];
    
    nextButton = [CCButton buttonWithTitle:@"Next" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]];
    [nextButton setTarget:self selector:@selector(onNextButtonClicked:)];
    nextButton.positionType = CCPositionTypeNormalized;
    [nextButton setPosition:ccp(0.9f, 0.9f)];
    
    CCLabelTTF *nextTitle = [CCLabelTTF labelWithString:@"Next" fontName:@"ArialMT" fontSize:20];
    nextTitle.color = [CCColor redColor];
    nextTitle.positionType = CCPositionTypeNormalized;
    nextTitle.position = ccp(0.9f, 0.9f);
    
    [self addChild:nextButton z:9];
    [self addChild:nextTitle z:10];
    
    for (int i=0; i<[goodsArray count]; i++) {
        [self addChild:[goodsArray objectAtIndex:i] z:9];
    }
}

-(void)onLastButtonClicked:(id)sender {
    [nextButton setEnabled:YES];
    [self setSceneNum:[self getSceneNum] - 1];
    if ([self getSceneNum] <= 1) {
        [self setSceneNum:1];
        [lastButton setEnabled:NO];
    }
    
    CCAction *moveRight = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(1.0f, 0)];
    // 一个动作只能给一个sprite执行
    for (int i=0; i<[goodsArray count]; i++) {
        [[goodsArray objectAtIndex:i] runAction:[moveRight copy]];
    }
}

-(void)onNextButtonClicked:(id)sender {
    [lastButton setEnabled:YES];
    [self setSceneNum:[self getSceneNum] + 1];
    if ([self getSceneNum] >= [self getSceneCount]) {
        [self setSceneNum:[self getSceneCount]];
        [nextButton setEnabled:NO];
    }
    
    CCAction *moveLeft = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(-1.0f, 0)];
    // 一个动作只能给一个sprite执行
    for (int i=0; i<[goodsArray count]; i++) {
        [[goodsArray objectAtIndex:i] runAction:[moveLeft copy]];
    }
}

-(void)setSceneNum:(int)num {
    sceneNum = num;
}

-(int)getSceneNum {
    return sceneNum;
}

-(void)setSceneCount:(int)count {
    sceneCount = count;
}

-(int)getSceneCount {
    return sceneCount;
}

@end
