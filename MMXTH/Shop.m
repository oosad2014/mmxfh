//
//  Shop.m
//
//  Created by : Mac
//  Project    : MMXTH
//  Date       : 16/10/7
//
//  Copyright (c) 2016年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "Shop.h"
#import "SecondScene.h"

// -----------------------------------------------------------------
@implementation ShopScene

// -----------------------------------------------------------------------
+ (ShopScene *)scene
{
    return [[self alloc] init];
}
- (id)init
{
    
    // Apple recommend assigning self with supers return value
    self = [super init];
    
    // The thing is, that if this fails, your app will 99.99% crash anyways, so why bother
    // Just make an assert, so that you can catch it in debug
    NSAssert(self, @"Whoops");
    CCSprite *titleBackGround = [CCSprite spriteWithImageNamed:@"timeField.png"];
    titleBackGround.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
    titleBackGround.scaleX = self.contentSize.width/titleBackGround.contentSize.width;
    titleBackGround.scaleY = self.contentSize.height/titleBackGround.contentSize.height;
    [self addChild:titleBackGround z:1];
    CCButton *BackButton = [CCButton buttonWithTitle:@"back" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]
                                   ];
    BackButton.positionType = CCPositionTypeNormalized;
    BackButton.position = ccp(0.15f, 0.85f);
   BackButton.color=[CCColor redColor];
    [BackButton setTarget:self selector:@selector(onBackButtonClicked:)];
    [self addChild:BackButton z:2];
    
    CCButton *GoodsButton1 = [CCButton buttonWithTitle:@"GoodsButton1" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]
                            ];
    GoodsButton1.positionType = CCPositionTypeNormalized;
    GoodsButton1.position = ccp(0.5f, 0.75f);
    GoodsButton1.color=[CCColor redColor];
    [GoodsButton1 setTarget:self selector:@selector(onGoodsButton1Clicked:)];
    [self addChild:GoodsButton1 z:2];
    CCButton *GoodsButton2 = [CCButton buttonWithTitle:@"GoodsButton2" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]
                            ];
    
    GoodsButton2.positionType = CCPositionTypeNormalized;
    GoodsButton2.position = ccp(0.5f, 0.55f);
    GoodsButton2.color=[CCColor redColor];
    [GoodsButton2 setTarget:self selector:@selector(onGoodsButton2Clicked:)];
    [self addChild:GoodsButton2 z:2];
    
    CCButton *GoodsButton3 = [CCButton buttonWithTitle:@"GoodsButton3" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]
                            ];
   GoodsButton3.positionType = CCPositionTypeNormalized;
    GoodsButton3.position = ccp(0.5f, 0.35f);
    GoodsButton3.color=[CCColor redColor];
    [GoodsButton3 setTarget:self selector:@selector(onGoodsButton3Clicked:)];
    [self addChild:GoodsButton3 z:2];
    
    
    mscontroller=[ [ShopController alloc] init];
    
    
    // done
    return self;
}

// -----------------------------------------------------------------------
- (void)onBackButtonClicked:(id)sender
{
    // start scene with transition
    [[CCDirector sharedDirector] replaceScene:[SecondScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
}
- (void)onGoodsButton1Clicked:(id)sender
{
    [mscontroller buy:1];
    [mscontroller showbuy];
}
- (void)onGoodsButton2Clicked:(id)sender
{
    [mscontroller buy:2];
    [mscontroller showbuy];
}
- (void)onGoodsButton3Clicked:(id)sender
{
    [mscontroller buy:3];
    [mscontroller showbuy];
}


@end





