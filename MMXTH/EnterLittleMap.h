//
//  EnterLittleMap.h
//  MMXTH
//
//  Created by 修海锟 on 2017/3/10.
//  Copyright © 2017年 xc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface EnterLittleMap : CCScene

@property(nonatomic, retain) CCNodeColor *background; // 用于保存游戏界面背景图
@property(nonatomic, retain) CCNodeColor *buttonLayer; // Node节点，用于盛放锁定按钮（固定层）
@property(nonatomic, retain) CCSprite *guangDongMap; // 广东地图
@property(nonatomic, retain) CCButton *guangDongBtn; // 广东按钮

+(EnterLittleMap *)scene;
- (id)init;
- (void)initScene;

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
@end

