//
//  RedBall.h
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/6.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CommUtil.h"

typedef NS_ENUM(NSUInteger, RedBallEffectType) {
    RedBallEffectTypeNone,
    RedBallEffectTypeIceing,
};

@interface RedBall : SKSpriteNode

@property (nonatomic,readwrite)RedBallEffectType effectType;

//random
+ (instancetype)redBall;

@end

