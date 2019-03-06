//
//  Bubble.m
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/6.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import "Bubble.h"

@implementation Bubble

+ (instancetype)randomBubbleWithProb:(float)prob {
    return [self bubbleWithType:[CommUtil randomHitWithProb:prob]?BubbleTypeIce:BubbleTypeNormal];
}

+ (instancetype)bubbleWithType:(BubbleType)bubbleType {
    return bubbleType==BubbleTypeNormal?[self spriteNodeWithImageNamed:@"bubble"]:[self spriteNodeWithImageNamed:@"bubble_ice"];
}

@end
