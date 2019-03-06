//
//  CommUtil.h
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/6.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommUtil : NSObject

+ (int)randomNumberIncludeFrom:(int)from includeTo:(int)to;
+ (BOOL)randomBOOL;
+ (BOOL)randomHitWithProb:(float)prob;

@end

