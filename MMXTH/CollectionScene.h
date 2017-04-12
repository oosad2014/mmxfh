//
//  CollectionScene.h
//  MMXTH
//
//  Created by 修海锟 on 2017/3/31.
//  Copyright © 2017年 xc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "DataManager.h"

@interface CollectionScene : CCScene

@property(nonatomic, weak) DataManager *dataManager;
@property(nonatomic, strong) CCButton *backBtn;

+ (id)scene;
- (CollectionScene *)init;


@end
