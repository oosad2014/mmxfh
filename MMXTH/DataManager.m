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

- (NSDictionary *)bundleDicWithName:(NSString *)name {
    NSString *plistName = name;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSDictionary *plistDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    return plistDic;
}

- (NSDictionary *)documentDicWithName:(NSString *)name {
    NSString *plistName = [name stringByAppendingString:@".plist"];
    NSString *plistPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    plistPath = [plistPath stringByAppendingPathComponent:plistName];
    
    NSDictionary *plistDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    return plistDic;
}

- (NSArray *)bundleArrayWithName:(NSString *)name {
    NSString *plistName = name;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray *plistArr = [NSArray arrayWithContentsOfFile:plistPath];
    
    return plistArr;
}

- (NSArray *)documentArrayWithName:(NSString *)name {
    NSString *plistName = [name stringByAppendingString:@".plist"];
    NSString *plistPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    plistPath = [plistPath stringByAppendingPathComponent:plistName];
    
    NSArray *plistArr = [NSArray arrayWithContentsOfFile:plistPath];
    
    return plistArr;
}

- (BOOL)writeDicWithName:(NSString *)name Dic:(NSDictionary *)dic {
    NSString *plistName = [name stringByAppendingString:@".plist"];
    NSString *plistPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    plistPath = [plistPath stringByAppendingPathComponent:plistName];
    
    NSDictionary *plistDic = dic;
    [plistDic writeToFile:plistPath atomically:YES];
    return YES;
}

- (BOOL)writeArrayWithName:(NSString *)name Arr:(NSArray *)array {
    NSString *plistName = [name stringByAppendingString:@".plist"];
    NSString *plistPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    plistPath = [plistPath stringByAppendingPathComponent:plistName];
    
    NSArray *plistArr = array;
    [plistArr writeToFile:plistPath atomically:YES];
    return YES;
}

@end
