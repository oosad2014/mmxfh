//
//  AudioPlayer.h
//  MMXTH
//
//  Created by xc on 17/4/10.
//  Copyright © 2017年 xc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface AudioPlayer : NSObject

@property(assign)bool ifMusicOn;//从plist读取上次保存的值
@property(assign)float curVal;//从plist读取上次保存的值
@property(nonatomic,retain)AVAudioPlayer *player;

+(AudioPlayer *)audioplayer;
-(id)init;
-(void)loadUserDefaults;
-(void)playMusic;

@end
