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

+ (instancetype)randomBubbleWithProb:(float)prob;
+ (instancetype)bubbleWithType:(BubbleType)bubbleType;

//normal or ice 
@property (nonatomic)BubbleType bubbleType;

//正在变大中
@property (nonatomic,readonly)BOOL growthing;

- (void)beganGrowthingWithTargetScale:(CGFloat)scale
                             duration:(NSTimeInterval)duration;
- (void)stopGrowthing;

//渐隐 然后移除
- (void)fadeOut;

@end

