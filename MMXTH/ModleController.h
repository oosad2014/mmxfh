//
//  ModleController.h
//  MMXTH
//
//  Created by Mac on 16/9/22.
//  Copyright © 2016年 xc. All rights reserved.
//

#ifndef ModleController_h
#define ModleController_h
#import"Train.h"
#import <Foundation/Foundation.h>
@interface ModleController : NSObject{
      Train *train;
      int SouceNum;
    
}
-(Train *) getTrain;
-(int) getSouceNum;
-(void)setTrain:(Train*) mtrain;
-(void)setSouceNum:(int) tNum;
@end


#endif /* ModleController_h */
