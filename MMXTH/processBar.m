//
//  processBar.m
//  text
//
//  Created by xc on 16/9/30.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "processBar.h"
#import "SecondScene.h"

@implementation processBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (processBar *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

-(id)init{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    CCSprite *spriteBG = [CCSprite spriteWithImageNamed:@"pb_bg.png"];
    //CCSprite *spriteBG = [CCSprite spriteWithFile:@"pb.png"];
    spriteBG.position = ccp(254,53);
    spriteBG.scaleX = 292;
    [self addChild:spriteBG ];
    [self setPb_bar];
    
    return self;
}

- (void) setPb_bar{
    
    //左进度条
    CCSprite *spriteLeftBAR = [CCSprite spriteWithImageNamed:@"pb_bar_left.png"];
    //[spriteLeftBG setTextureRect:CGRectMake(20, 20, 5, 5)];
    spriteLeftBAR.position = ccp(104,50);
    spriteLeftBAR.anchorPoint = CGPointZero;
    [self addChild:spriteLeftBAR ];
    
    [self schedule:@selector(step:) interval:0.01];
    
}
-(void) step:(CCTime)dt
{
    time = dt + time;
    //NSString *string = [NSString stringWithFormat:@"%d", (int)time];
    //NSLog(@"~~~~~~%@~~~~~~~~~",string);
    i++;
    [self chang];
    
}
- (void) chang{
    
    
    if (i<=298) {
        
        //中间背景进度条
        CCSprite *spriteBAR = [CCSprite spriteWithImageNamed:@"pb_bar.png"];
        //spriteBAR.position = ccp(254,53);
        spriteBAR.position = ccp(107+i,53);
        //spriteBAR.scaleX = 292;
        [self addChild:spriteBAR ];
        
    }else if (i>299){
        //[spriteBAR release];
        [self removeAllChildren];
        [[CCDirector sharedDirector] replaceScene:[SecondScene scene]
                                   withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
    }
    
}


@end
