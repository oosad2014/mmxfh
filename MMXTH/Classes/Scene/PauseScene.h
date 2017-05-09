//
//  PauseScene.h
//  MMXTH
//
//  Created by mac on 16/10/23.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "StartScene.h"
#import "SkinScene.h"
#import "BigMapScene.h"
#import "LittleMapScene.h"

@interface PauseScene : CCScene

@property(nonatomic, retain) CCTexture *textureCache; // 用来缓存图片
@property(nonatomic, retain) CCSprite *menuground; // 用来记录menu界面背景

+(PauseScene *)scene;
-(id)initWithParameter:(CCRenderTexture *)pauseTexture; // 通过缓存池建立

@end
 
