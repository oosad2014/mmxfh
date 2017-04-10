//
//  CollectionScene.m
//  MMXTH
//
//  Created by 修海锟 on 2017/3/31.
//  Copyright © 2017年 xc. All rights reserved.
//

/**
 * 使用文件加载
 * Collection.plist
 * NSDictionary:
 *     "count": 收集物总个数
 *     "countNow": 已收集的个数
 *     "collectionArr": 收集物的数组，保存0/1 -> 0:没有，用阴影表示，1:有，用实物表示
 *     "collectionImg": 收集物的图片，对应数组保存收集物图片名字，阴影用"名字_NO"表示
 */

#import "CollectionScene.h"

@interface CollectionScene ()

@property(nonatomic, assign) int sceneCount;

@end

@implementation CollectionScene

@synthesize backBtn;

+ (id)scene {
    return [[self alloc] init];
}

- (CollectionScene *)init {
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    
    _dataManager = [DataManager sharedManager];
    
    CCSprite *collectionBg = [CCSprite spriteWithImageNamed:@"收集界面.png"];
    [collectionBg setPositionType:CCPositionTypeNormalized];
    [collectionBg setPosition:CGPointMake(0.5f, 0.5f)];
    [collectionBg setScale:self.contentSize.width/collectionBg.contentSize.width];
    [self addChild:collectionBg z: 1];
    
    backBtn = [CCSprite spriteWithImageNamed:@"撤销.png"];
    [backBtn setPositionType:CCPositionTypeNormalized];
    [backBtn setPosition:CGPointMake(0.1f, 0.9f)];
    [self addChild:backBtn z: 2];
    
    [self initScene];
    return self;
}

- (void)initScene {
    NSDictionary *collectionDic = [_dataManager documentDicWithName:@"Collection"];
    NSArray *collectionArr = [collectionDic objectForKey:@"collectionArr"];
    NSArray *collectionImg = [collectionDic objectForKey:@"collectionImg"];
    int maxImgCount = [[collectionDic objectForKey:@"count"] intValue];
    
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            if ((i*3+j) < maxImgCount ) {
                if ([[collectionArr objectAtIndex:(i*3+j)] intValue] == 1) {
                    NSString *imgName = [(NSString *)[collectionImg objectAtIndex:(i*3+j)] stringByAppendingString:@".png"];
                    CCSprite *collection = [CCSprite spriteWithImageNamed:imgName];
                    [collection setPositionType:CCPositionTypeNormalized];
                    [collection setPosition:ccp(0.25f * (j+1), (1 - 0.25f * (i+1)))];
                    [collection setScale:self.contentSize.width / 10 / collection.contentSize.width];
                    [self addChild:collection z:3];
                } else {
                    NSString *imgName = [(NSString *)[collectionImg objectAtIndex:(i*3+j)] stringByAppendingString:@"_NO.png"];
                    CCSprite *collection = [CCSprite spriteWithImageNamed:imgName];
                    [collection setPositionType:CCPositionTypeNormalized];
                    [collection setPosition:ccp(0.25f * (j+1), (1 - 0.25f * (i+1)))];
                    [collection setScale:self.contentSize.width / 10 / collection.contentSize.width];
                    [self addChild:collection z:3];
                }
            }
        }
    }
}

@end
