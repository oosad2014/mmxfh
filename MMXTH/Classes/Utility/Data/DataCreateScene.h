//
//  DataCreateScene.h
//  MMXTH
//
//  Created by 修海锟 on 2017/3/14.
//  Copyright © 2017年 xc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface DataCreateScene : CCScene

@property(weak) DataManager *dataManager;

+ (DataCreateScene *)scene;
- (id)init;
- (BOOL)createData;
- (void)createSuccess;

@end
