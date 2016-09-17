//
//  Train.h
//
//  Created by : Mac
//  Project    : MMXTH
//  Date       : 16/9/17
//
//  Copyright (c) 2016年 xc.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"


// -----------------------------------------------------------------

@interface Train : CCSprite

{
    NSString *url;
    
    
    
}
// -----------------------------------------------------------------
// properties

// -----------------------------------------------------------------
// methods
-(NSString *) getUrl;
-(void) setUrl:(NSString*)URL;

+ (instancetype)node;
- (instancetype)init;

// -----------------------------------------------------------------

@end




