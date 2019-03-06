//
//  Bubble.h
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/6.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CommUtil.h"

typedef NS_ENUM(NSUInteger, BubbleType) {
    BubbleTypeNormal,
    BubbleTypeIce,
};

@interface Bubble : SKSpriteNode

@property (nonatomic)BOOL creating;//正在创建中
@property (nonatomic)BubbleType bubbleType;

+ (instancetype)randomBubbleWithProb:(float)prob;
+ (instancetype)bubbleWithType:(BubbleType)bubbleType;

@end

