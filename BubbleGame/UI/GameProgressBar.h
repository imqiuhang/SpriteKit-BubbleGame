//
//  GameProgressBar.h
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/10.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, GameProgressBarType) {
    GameProgressBarTypeBubbleAdd,
    GameProgressBarTypeTime,
};

@interface GameProgressBar : SKShapeNode

+ (instancetype)barWithType:(GameProgressBarType)type frame:(CGRect)frame;

@property (nonatomic,readonly)CGFloat progress;
@property (nonatomic)GameProgressBarType barType;
- (void)updateProgress:(CGFloat)progress animation:(BOOL)animation;

@end

