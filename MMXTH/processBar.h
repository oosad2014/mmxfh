//
//  processBar.h
//  text
//
//  Created by xc on 16/9/30.
//  Copyright © 2016年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "CCTextureCache.h"
#import "SecondScene.h"
#import "EnterLittleMap.h"
#import "DataManager.h"

@interface processBar : CCScene

@property(assign) int totalResCount;//需要预加载的资源总数
@property(assign) int loadResCount;//已加载资源数
@property(assign) NSArray *resourcesArray;

@property(nonatomic, strong) DataManager *dataManager;
// -----------------------------------------------------------------------

- (instancetype)init;
+(processBar *)scene;
-(void)addResource;
@end
