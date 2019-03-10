//
//  GameConfigs.h
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/10.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "UIColor+ColorExtension.h"
#import "CommUtil.h"
#import <UIKit/UIKit.h>

#define WeakSelf __weak typeof(self) weakSelf = self;

@interface GameConfigs : NSObject

+ (CGFloat)bubbleGrowingSpeed;
+ (CGFloat)maxBubbleScale;
+ (NSTimeInterval)growing2MaxDuration;
+ (CGFloat)minBubble2Stay;

+ (uint32_t)bubbleCollisionBitMask;
+ (uint32_t)redBallCollisionBitMask;

+ (CGFloat)redBallSpeedNormal;
+ (CGFloat)redBallSpeedIce;

+ (CGFloat)nomuchTimeRate;

+ (CGFloat)maxBubbleAddForLevel:(NSInteger)level;
+ (CGFloat)totalTimeForPass;

@end


