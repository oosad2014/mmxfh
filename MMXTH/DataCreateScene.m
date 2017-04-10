//
//  DataCreateScene.m
//  MMXTH
//
//  Created by 修海锟 on 2017/3/14.
//  Copyright © 2017年 xc. All rights reserved.
//

#import "DataCreateScene.h"

@implementation DataCreateScene

+ (DataCreateScene *)scene {
    return [[self alloc] init];
}

- (id)init {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    // class initalization goes here
    
    _dataManager = [DataManager sharedManager];
    
    // 建立一个色层节点，用于存放scene界面
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:27.0f/255.0f green:185.0f/255.0f blue:239.0f/255.0f alpha:1.0f]];
    [self addChild:background z: 1];
    
    [self createData];
    if ([self showData]) {
        [self createSuccess];
    }
    
    return self;
}

- (BOOL)createData {
    // 此函数内使用数据写入文件操作
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                         @[@85, @-110], @"GuangDong",
//                         @[@93, @-112], @"HongKong",
//                         @[@145, @-105], @"TaiWan",
//                         @[@55, @-155], @"HaiNam",
//                         @[@-10, @-103], @"YunNan",
//                         nil];
//    
//    NSArray *arr = [NSArray arrayWithObjects:@"pb.png", @"panda.png", @"button.png", @"panda.png", @"Icon.png", @"Icon-Small.png", @"button.png", nil];
//    [_dataManager writeArrayWithName:@"TrainHeadImages" Arr:arr];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                            @"", @"TrainSelected",
//                            @"", @"Others",
//                            nil];
    NSArray *collectionImg = [NSArray arrayWithObjects:
                              @"panda",
                              @"goal",
                              @"train",
                              @"goal",
                              @"train",
                              @"panda",
                              @"train",
                              @"panda",
                              @"goal",
                              nil];
    NSArray *collectionArr = [NSArray arrayWithObjects: @1, @1, @1, @1, @1, @1, @1, @1, @1, nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @9, @"count",
                         @9, @"countNow",
                         collectionArr, @"collectionArr",
                         collectionImg, @"collectionImg",
                         nil];
    [_dataManager writeDicWithName:@"Collection" Dic:dic];
    
    return YES;
}

- (BOOL)showData {
    NSDictionary *dic = [_dataManager documentDicWithName:@"Collection"];
    NSLog(@"%@", dic);
//    NSArray *arr = [_dataManager documentArrayWithName:@"TrainHeadImages"];
//    NSLog(@"%@", arr);
    
    return YES;
}

- (void)createSuccess {
    CCLabelTTF *backTitle = [CCLabelTTF labelWithString:@"Create Data Successful!" fontName:@"ArialMT" fontSize:20];
    backTitle.color = [CCColor redColor];
    backTitle.positionType = CCPositionTypeNormalized;
    backTitle.position = ccp(0.5f, 0.5f);
    [self addChild:backTitle z: 2]; // 文字要高于按钮一层
}
@end
