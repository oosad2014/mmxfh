#import "Train.h"

// -----------------------------------------------------------------

static int count = 0;

@implementation Train

@synthesize trainArray;
@synthesize url;

// -----------------------------------------------------------------

-(id)init {
    self = [super init];
    Row = 0;
    Column = 0;
    url = @"";
    trainArray = [NSArray arrayWithObjects:@"train.png", @"traingood.png", @"button.png", nil];
    return self;
}

-(void)setRow:(float)x {
    Row = x;
}

-(void)setColumn:(float)y {
    Column = y;
}

+(void)setCount:(int)countNew {
    count = countNew;
}

-(float)getRow {
    return Row;
}

-(float)getColumn {
    return Column;
}

+(int)getCount {
    return count;
}

// -----------------------------------------------------------------

-(Train *)create:(float)x ySet:(float)y {
    url = [trainArray objectAtIndex:[Train getCount]];
    Train *train = [Train spriteWithImageNamed:url];
    train.url = [trainArray objectAtIndex:[Train getCount]];
    [train setRow:x];
    [train setColumn:y];
    train.positionType = CCPositionTypeNormalized;
    [train setPosition:ccp([train getRow], [train getColumn])];
    return train;
}

-(id)copyWithZone:(NSZone *)zone {
    Train *copyTrain = [[[self class] allocWithZone:zone] init];
    copyTrain.url = self.url;
    copyTrain.trainArray = self.trainArray;
    return copyTrain;
}

@end