//
//  SettingScene.m
//  MMXTH
//
//  Created by xc on 17/3/27.
//  Copyright © 2017年 xc. All rights reserved.
//

#import "SettingScene.h"
#import "FirstScene.h"
#import "CCSlider.h"
#import "AudioPlayer.h"

@implementation SettingScene

@synthesize musicSlider;
@synthesize musicSwitch;


// -----------------------------------------------------------------
+(SettingScene *)scene{
    return [[self alloc] init];
}

-(id)init{
    self=[super init];
    
    //CCSprite *welcomeBg=[CCSprite spriteWithTexture:firstSceneTexture.texture];
    //[self addChild:welcomeBg z:1];
    
    /*
     CCNodeColor *cover = [CCNodeColor nodeWithColor:[CCColor colorWithCcColor4b:ccc4(0, 0, 0, 30)]];
     [self addChild:cover z:10 name:@"cover"];
     */
    
    //背景图片--以后从plist获取
    CCSprite *viewBg =[CCSprite spriteWithImageNamed:@"背景.png"];
    viewBg.positionType=CCPositionTypeNormalized;
    viewBg.position=ccp(0.5f, 0.5f);
    [viewBg setScale:self.contentSize.width/viewBg.contentSize.width];
    [self addChild:viewBg z:1 name:@"pic"];
    
    //音量开关文字
    CCLabelTTF *lable = [CCLabelTTF labelWithString:@"背景音乐" fontName:@"TrebuchetMS-Bold" fontSize:20];
    lable.positionType = CCPositionTypeNormalized;
    lable.position = ccp(0.3f, 0.7f);
    [self addChild:lable z:10];
    
    //音量大小文字
    CCLabelTTF *lable1 = [CCLabelTTF labelWithString:@"音量" fontName:@"TrebuchetMS-Bold" fontSize:20];
    lable1.positionType = CCPositionTypeNormalized;
    lable1.position = ccp(0.3f, 0.45f);
    [self addChild:lable1 z:10];
    
    //滑块调节音量
    CCSpriteFrame *sliderRuler=[CCSpriteFrame frameWithImageNamed:@"ruler.png"];
    CCSpriteFrame *sliderKnob=[CCSpriteFrame frameWithImageNamed:@"滑块-4.png"];
    musicSlider=[[CCSlider alloc] initWithBackground:sliderRuler andHandleImage:sliderKnob];
    musicSlider.sliderValue=[AudioPlayer audioplayer].player.volume;
    [musicSlider setTarget:self selector:@selector(onMusicValChange:)];
    musicSlider.positionType=CCPositionTypeNormalized;
    musicSlider.position=ccp(0.45f, 0.4f);
    [self addChild:musicSlider z:11 name:@"slider"];
    
    //开关控制音量开启
    musicSwitch=[[UISwitch alloc] initWithFrame:CGRectMake(100, 50, 0, 0)];
    [musicSwitch addTarget:self action:@selector(soundJudge:) forControlEvents:UIControlEventValueChanged];
    musicSwitch.center=CGPointMake(280, 100);
    
    [musicSwitch setOn:[AudioPlayer audioplayer].ifMusicOn];
    CCLOG(@"~~~~~~sw.on:%d",musicSwitch.on);
    CCLOG(@"~~~~~~sw.selected:%d",musicSwitch.selected);
    [[[CCDirector sharedDirector] view]addSubview:musicSwitch];
    //release?
    
    
    // Back按钮
    CCButton *backButton = [CCButton buttonWithTitle:@"Back" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"return.png"]];
    [backButton setTarget:self selector:@selector(onBackButtonClicked:)];
    backButton.positionType = CCPositionTypeNormalized;
    [backButton setPosition:ccp(0.1f, 0.85f)];
    backButton.scale=0.03f;
    [self addChild:backButton z:9];
    
    return self;
}


// -----------------------------------------------------------------
- (void)onBackButtonClicked:(id)sender {
    CCSlider *sl=(CCSlider *)[self getChildByName:@"slider" recursively:false];
    [self removeChild:sl];
    
    [musicSwitch removeFromSuperview];
    [[CCDirector sharedDirector] popScene];
    /* [[CCDirector sharedDirector] replaceScene:[FirstScene scene]
     withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
     */
}

-(void)onMusicValChange:(id)sender{
    CCSlider *slider=(CCSlider *)sender;
    [AudioPlayer audioplayer].player.volume=slider.sliderValue;
    NSLog(@"~~~~~~~~~~~~change volume:%f",[AudioPlayer audioplayer].player.volume);
    
    //plist文件修改
    [AudioPlayer audioplayer].curVal=slider.sliderValue;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setFloat:slider.sliderValue forKey:@"musicVolume"];
}

-(void)soundJudge:(id)sender{
    UISwitch *sw=(UISwitch *)sender;
    
    if(sw.isOn==true)
        [[AudioPlayer audioplayer].player play];
    else
        [[AudioPlayer audioplayer].player stop];
    NSLog(@"~~~~~~~~~~~~change switch:%d",sw.isOn);
    
    //plist文件修改
    [AudioPlayer audioplayer].ifMusicOn=sw.isOn;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:sw.isOn forKey:@"musicSwitch"];
}
@end
