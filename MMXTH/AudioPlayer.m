//
//  AudioPlayer.m
//  MMXTH
//
//  Created by xc on 17/4/10.
//  Copyright © 2017年 xc. All rights reserved.
//

#import "AudioPlayer.h"

@implementation AudioPlayer

@synthesize ifMusicOn;
@synthesize curVal;
@synthesize player;

-(void)playMusic{
    if(ifMusicOn)
    {
        [self.player play];
        self.player.numberOfLoops=-1;
    }
    else
        [self.player stop];
}

-(void)loadUserDefaults{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    ifMusicOn=[defaults boolForKey:@"musicSwitch"];
    curVal=[defaults floatForKey:@"musicVolume"];
}

+(AudioPlayer *)audioplayer{
    static AudioPlayer *audioplayer=nil;
    @synchronized (self) {
        if(!audioplayer)
            audioplayer=[[self alloc]init];
        return audioplayer;
    }
}

-(id)init{
    /*背景音乐播放*/
    
    //设置初始化
    ifMusicOn=1;
    curVal=1;
    [self loadUserDefaults];
    
    /*
     //aiff格式
     NSError *err;
     NSData *musicData=[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"2-17 Only One Forever" ofType:@"aif"]];
     player=[[AVAudioPlayer alloc]initWithData:musicData error:&err];
     */
    
    //mp3格式
    NSURL *url=[[NSBundle mainBundle]URLForResource:@"music.mp3" withExtension:Nil];
    player=[[AVAudioPlayer alloc]initWithContentsOfURL:url fileTypeHint:nil error:nil];
    
    player.volume=curVal;
    [player prepareToPlay];
    
    return self;
}



@end
