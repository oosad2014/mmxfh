//
//  SettingScene.h
//  MMXTH
//
//  Created by xc on 17/3/27.
//  Copyright © 2017年 xc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "StartScene.h"
#import "CCSlider.h"
#import "AudioPlayer.h"

@interface SettingScene : CCScene

@property(nonatomic,retain)CCSlider *musicSlider;
@property(nonatomic,retain)UISwitch *musicSwitch;


//---------------------------------------------------------------
+ (SettingScene *)scene;
- (id)init;

@end
