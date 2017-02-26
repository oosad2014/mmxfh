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

@interface processBar : CCScene
{
    CCTime time;
    NSString *changTime;
    int i;
}
+ (processBar *)scene;
- (id)init;
@end
