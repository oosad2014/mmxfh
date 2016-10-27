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

@interface PauseScene : CCScene

@property(nonatomic, retain) CCTexture *textureCache;
@property(nonatomic, retain) CCSprite *menuground;

+(PauseScene *)scene;
-(id)initWithParameter:(CCRenderTexture *)pauseTexture;

/*
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
- (void)touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event;
 */
@end
 
