//
//  ShopScene.m
//  MMXTH
//
//  Created by mac on 16/10/6.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "ShopScene.h"
#import "ShoppingThings.h"
#import "Shop.h"

#define GOODS_ONE_SECNE 6

@implementation ShopScene {
    Shop *shop;
    int sceneNum;
    int sceneCount;
    BOOL selOrNot; // 用来判断是否转换数组
}

@synthesize goodsArray;
@synthesize goodsArraySel;
@synthesize nextButton;
@synthesize lastButton;
@synthesize selectButton;
@synthesize recoverButton;

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
    goodsArray = [shop.goodsShopArray mutableCopy]; // 复制问题，暂时未解决
    [self updateSelArray];
    [self setSceneCount:([goodsArray count] / GOODS_ONE_SECNE)];
    [self setSelOrNot:NO];
    
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
    [lastButton setPosition:ccp(0.1f, 0.95f)];
    
    CCLabelTTF *lastTitle = [CCLabelTTF labelWithString:@"Last" fontName:@"ArialMT" fontSize:20];
    lastTitle.color = [CCColor redColor];
    lastTitle.positionType = CCPositionTypeNormalized;
    lastTitle.position = ccp(0.1f, 0.95f);
    
    
    [self addChild:lastButton z:9];
    [self addChild:lastTitle z:10];
    
    nextButton = [CCButton buttonWithTitle:@"Next" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]];
    [nextButton setTarget:self selector:@selector(onNextButtonClicked:)];
    nextButton.positionType = CCPositionTypeNormalized;
    [nextButton setPosition:ccp(0.9f, 0.95f)];
    
    CCLabelTTF *nextTitle = [CCLabelTTF labelWithString:@"Next" fontName:@"ArialMT" fontSize:20];
    nextTitle.color = [CCColor redColor];
    nextTitle.positionType = CCPositionTypeNormalized;
    nextTitle.position = ccp(0.9f, 0.95f);
    
    [self addChild:nextButton z:9];
    [self addChild:nextTitle z:10];
    
    selectButton = [CCButton buttonWithTitle:@"未购买" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]];
    [selectButton setTarget:self selector:@selector(onSelectButtonClicked:)];
    selectButton.positionType = CCPositionTypeNormalized;
    [selectButton setPosition:ccp(0.9f, 0.05f)];
    
    CCLabelTTF *selectTitle = [CCLabelTTF labelWithString:@"未购买" fontName:@"ArialMT" fontSize:20];
    selectTitle.color = [CCColor redColor];
    selectTitle.positionType = CCPositionTypeNormalized;
    selectTitle.position = ccp(0.9f, 0.05f);
    
    [self addChild:selectButton z:9];
    [self addChild:selectTitle z:10];
    
    recoverButton = [CCButton buttonWithTitle:@"全部" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]];
    [recoverButton setTarget:self selector:@selector(onRecoverButtonClicked:)];
    [recoverButton setEnabled:NO];
    recoverButton.positionType = CCPositionTypeNormalized;
    [recoverButton setPosition:ccp(0.7f, 0.05f)];
    
    CCLabelTTF *recoverTitle = [CCLabelTTF labelWithString:@"全部" fontName:@"ArialMT" fontSize:20];
    recoverTitle.color = [CCColor redColor];
    recoverTitle.positionType = CCPositionTypeNormalized;
    recoverTitle.position = ccp(0.7f, 0.05f);
    
    [self addChild:recoverButton z:9];
    [self addChild:recoverTitle z:10];
    
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
    
    CCAction *moveRight = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(1.1f, 0)];
    CCAction *moveLeft = [CCActionMoveBy actionWithDuration:0.1f position:CGPointMake(-0.1f, 0)];
    CCAction *action = [CCActionSequence actionWithArray:@[moveRight, moveLeft]];
    // 一个动作只能给一个sprite执行
    
    if ([self getSelOrNot]) {
        for (int i=0; i<[goodsArraySel count]; i++) {
            [[goodsArraySel objectAtIndex:i] runAction:[action copy]];
        }
    }
    else {
        for (int i=0; i<[goodsArray count]; i++) {
            [[goodsArray objectAtIndex:i] runAction:[action copy]];
        }
    }
}

-(void)onNextButtonClicked:(id)sender {
    [lastButton setEnabled:YES];
    [self setSceneNum:[self getSceneNum] + 1];
    if ([self getSceneNum] >= [self getSceneCount]) {
        [self setSceneNum:[self getSceneCount]];
        [nextButton setEnabled:NO];
    }
    
    CCAction *moveLeft = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(-1.1f, 0)];
    CCAction *moveRight = [CCActionMoveBy actionWithDuration:0.1f position:CGPointMake(0.1f, 0)];
    CCAction *action = [CCActionSequence actionWithArray:@[moveLeft, moveRight]];
    // 一个动作只能给一个sprite执行
    
    if ([self getSelOrNot]) {
        for (int i=0; i<[goodsArraySel count]; i++) {
            [[goodsArraySel objectAtIndex:i] runAction:[action copy]];
        }
    }
    else {
        for (int i=0; i<[goodsArray count]; i++) {
            [[goodsArray objectAtIndex:i] runAction:[action copy]];
        }
    }
}

-(void)onSelectButtonClicked:(id)sender {
    [self setSomeBuy];
    // 清理所有原元素
    for (int i=0; i<[goodsArray count]; i++) {
        [[goodsArray objectAtIndex:i] removeFromParentAndCleanup:YES];
    }
    // 重置新元素
    for (int i=0; i<[goodsArraySel count]; i++) {
        [self addChild:[goodsArraySel objectAtIndex:i] z:9];
    }
    
    [self setSelOrNot:YES];
    [selectButton setEnabled:NO];
    [recoverButton setEnabled:YES];
}

-(void)onRecoverButtonClicked:(id)sender {
    [self recoverGoodsArray]; // 恢复
    // 清理所有原元素
    for (int i=0; i<[goodsArraySel count]; i++) {
        [[goodsArraySel objectAtIndex:i] removeFromParentAndCleanup:YES];
    }
    // 重置新元素
    
    for (int i=0; i<[goodsArray count]; i++) {
        [self addChild:[goodsArray objectAtIndex:i] z:9];
    }
    
    [self setSelOrNot:NO];
    [selectButton setEnabled:YES];
    [recoverButton setEnabled:NO];
}

-(void)setSomeBuy {
    for (int i=0; i<[goodsArray count]; i+=2) {
        // 假设设置一些已购买
        [[goodsArray objectAtIndex:i] setBuyOrNot:YES];
    }
    [self updateSelArray];
}

-(void)updateSelArray {
    goodsArraySel = [NSMutableArray arrayWithCapacity:0];
    _countSel = 1;
    for (int i=0; i<[goodsArray count]; i++) {
        if (![[goodsArray objectAtIndex:i] getBuyOrNot]) {
            [goodsArraySel addObject:[goodsArray objectAtIndex:i]]; // 将goodsArray中没有买的放入
            ShoppingThings *goods = [[ShoppingThings alloc] init];
            int sceneN = [self getSceneNum] - 1; // 自动减一，方便计算
            switch ((_countSel)%6) {
                case 1:
                    goods = [goodsArraySel objectAtIndex:_countSel-1];
                    [goods setRow:(_countSel/6 + 0.25f - sceneN)];
                    [goods setColumn:(0.7f)];
                    [goods setPosition:ccp([goods getRow], [goods getColumn])];
                    break;
                case 2:
                    goods = [goodsArraySel objectAtIndex:_countSel-1];
                    [goods setRow:(_countSel/6 + 0.25f - sceneN)];
                    [goods setColumn:(0.3f)];
                    [goods setPosition:ccp([goods getRow], [goods getColumn])];
                    break;
                case 3:
                    goods = [goodsArraySel objectAtIndex:_countSel-1];
                    [goods setRow:(_countSel/6 + 0.5f - sceneN)];
                    [goods setColumn:(0.7f)];
                    [goods setPosition:ccp([goods getRow], [goods getColumn])];
                    break;
                case 4:
                    goods = [goodsArraySel objectAtIndex:_countSel-1];
                    [goods setRow:(_countSel/6 + 0.5f - sceneN)];
                    [goods setColumn:(0.3f)];
                    [goods setPosition:ccp([goods getRow], [goods getColumn])];
                    break;
                case 5:
                    goods = [goodsArraySel objectAtIndex:_countSel-1];
                    [goods setRow:(_countSel/6 + 0.75f - sceneN)];
                    [goods setColumn:(0.7f)];
                    [goods setPosition:ccp([goods getRow], [goods getColumn])];
                    break;
                case 0:
                    goods = [goodsArraySel objectAtIndex:_countSel-1];
                    [goods setRow:(_countSel/6 - 1 + 0.75f - sceneN)];
                    [goods setColumn:(0.3f)];
                    [goods setPosition:ccp([goods getRow], [goods getColumn])];
                    break;
                default:
                    break;
            }
            _countSel++;
        }
    }
}

-(void)recoverGoodsArray {
    // 用于恢复goodsArray中元素属性
    shop = [Shop oneShop]; // 获取单例类实例
    goodsArray = [shop.goodsShopArray copy];
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

-(void)setSelOrNot:(BOOL)sel {
    selOrNot = sel;
}

-(BOOL)getSelOrNot {
    return selOrNot;
}

@end
