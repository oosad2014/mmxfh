//
//  processBar.m
//  text
//
//  Created by xc on 16/9/30.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "processBar.h"

@implementation processBar

@synthesize totalResCount;
@synthesize loadResCount;
@synthesize resourcesArray;

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

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    
    totalResCount=0;//此处按需更改资源数
    loadResCount=0;
    _dataManager = [DataManager sharedManager];
    
    // The thing is, that if this fails, your app will 99.99% crash anyways, so why bother
    // Just make an assert, so that you can catch it in debug
    NSAssert(self, @"Whoops");
    
    //进度条(cocos2d v3自动调用update方法）
    CCSprite *pic=[CCSprite spriteWithImageNamed:@"Icon-120.png"];
    CCProgressNode *pb=[CCProgressNode progressWithSprite:pic];
    
    CGSize viewSize=[CCDirector sharedDirector].viewSize;
    pb.position=ccp(viewSize.width/2, viewSize.height/2);
    
    pb.percentage=0;
    pb.type=CCProgressNodeTypeBar;
    
    pb.midpoint=ccp(0.0, 0.0);
    pb.barChangeRate=ccp(1.0, 0.0);
    [self addChild:pb z:0 name:@"progressBar"];
    NSLog(@"~~~~~~~~~~~~~~~~~~~进度条初始配置完成");
    
    //加载资源,进度条显示加载进度
    [self addResource];
    
    // done
    return self;
    NSLog(@"false~~");
}

//加载资源
-(void)addResource{
    resourcesArray = [_dataManager bundleArrayWithName:@"AllImagesResources"];
    totalResCount = (int)[resourcesArray count];
    
    int count = 0;
    for (id images in resourcesArray) {
        [[CCTextureCache sharedTextureCache] addImageAsync:images target:self selector:@selector(loadCallBack)];
        NSLog(@"~~~~~~~~~~~~~%d", count++);
    }
}
// -----------------------------------------------------------------------

//伪加载
/*
 -(void)update:(CCTime)delta{
 CCProgressNode *pb=(CCProgressNode*)[self getChildByName:@"progressBar" recursively:false];
 pb.percentage++;
 }
 */

-(void)loadCallBack {
    NSLog(@"Load: ~~~~~~~~~~~~~%d", loadResCount++);
    CCProgressNode *pb=(CCProgressNode*)[self getChildByName:@"progressBar" recursively:false];
    pb.percentage=(int)loadResCount*100/totalResCount;
    
    if(loadResCount==totalResCount){
        NSLog(@"~~~~~~~~~~~~资源加载完毕");
        [[CCDirector sharedDirector] replaceScene:[EnterLittleMap scene]
                                   withTransition:[CCTransition transitionFadeWithColor:[CCColor redColor] duration:0.5f]];
        //切换场景
    }
}

@end
