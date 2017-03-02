//
//  ShopController.h
//  MMXTH
//
//  Created by Mac on 16/10/7.
//  Copyright © 2016年 xc. All rights reserved.
//

#ifndef ShopController_h
#define ShopController_h

//#import"Train.h"
#import <Foundation/Foundation.h>
#import"Customer.h"
@interface ShopController : NSObject{

    Customer * thecustomer;
    
}
@property(nonatomic, retain)NSArray *GoodsArray;


// -----------------------------------------------------------------
// methods

-(void)buy:(int) x;
-(void) showbuy;
//-(NSArray *) showNbuy;

@end


#endif /* ShopController_h */
