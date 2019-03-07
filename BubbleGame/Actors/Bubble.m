//
//  Bubble.m
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/6.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import "Bubble.h"

static NSString *const kGrowthingAnimationName = @"action_buuble_self_growthing";

@implementation Bubble

#pragma mark - actions
- (void)fadeOut {
    [self runAction:[SKAction sequence:@[
                                         [SKAction fadeOutWithDuration:0.5],
                                         [SKAction removeFromParent],
                                         ]]];
}

- (void)beganGrowthingWithTargetScale:(CGFloat)scale duration:(NSTimeInterval)duration{
    [self stopGrowthing];
    _growthing = YES;
    [self runAction:[SKAction scaleTo:scale duration:duration] withKey:kGrowthingAnimationName];
}

- (void)stopGrowthing {
    _growthing = NO;
    [self removeActionForKey:kGrowthingAnimationName];
}

#pragma mark - creating
+ (instancetype)randomBubbleWithProb:(float)prob {
    return [self bubbleWithType:[CommUtil randomHitWithProb:prob]?BubbleTypeIce:BubbleTypeNormal];
}

+ (instancetype)bubbleWithType:(BubbleType)bubbleType {
   Bubble *bubble =  bubbleType==BubbleTypeNormal?[self spriteNodeWithImageNamed:@"bubble"]:[self spriteNodeWithImageNamed:@"bubble_ice"];
    [bubble setScale:0.f];
    return bubble;
}



@end
