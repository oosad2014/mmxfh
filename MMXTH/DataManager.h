//
//  DataManager.h
//  MMXTH
//
//  Created by 修海锟 on 2017/3/14.
//  Copyright © 2017年 xc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+ (DataManager *)sharedManager; // 单例类返回的文件操作对象

- (id)bundleDataWithName:(NSString *)name; // 获取Bundle数据（字典）
- (id)documentDataWithName:(NSString *)name; // 获取Document数据（字典）
- (BOOL)writeDataWithName:(NSString *)name Dic:(NSDictionary *)dic;

@end
