//
//  DataManager.m
//  MMXTH
//
//  Created by 修海锟 on 2017/3/14.
//  Copyright © 2017年 xc. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

static DataManager* dataManager = nil;

+ (DataManager *)sharedManager {
    // 使用GCD进行锁对象
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (dataManager == nil) {
            dataManager = [[self alloc] init];
        }
    });
    
    return dataManager;
}

- (id)bundleDataWithName:(NSString *)name {
    NSString *plistName = name;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSDictionary *plistDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    return plistDic;
}

- (id)documentDataWithName:(NSString *)name {
    NSString *plistName = [name stringByAppendingString:@".plist"];
    NSString *plistPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    plistPath = [plistPath stringByAppendingPathComponent:plistName];
    
    NSDictionary *plistDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    return plistDic;
}

- (BOOL)writeDataWithName:(NSString *)name Dic:(NSDictionary *)dic {
    NSString *plistName = [name stringByAppendingString:@".plist"];
    NSString *plistPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    plistPath = [plistPath stringByAppendingPathComponent:plistName];
    
    NSDictionary *plistDic = dic;
    [plistDic writeToFile:plistPath atomically:YES];
    return YES;
}

@end
