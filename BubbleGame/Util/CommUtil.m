//
//  CommUtil.m
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/10.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import "CommUtil.h"

@implementation CommUtil

+ (int)randomNumberIncludeFrom:(int)from includeTo:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}

+ (BOOL)randomBOOL {
    return [@([self randomNumberIncludeFrom:0 includeTo:1])boolValue];
}

+ (BOOL)randomHitWithProb:(float)prob {
    int  max = prob*100;
    return [self randomNumberIncludeFrom:0 includeTo:max]==max;
}


@end
