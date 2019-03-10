//
//  GameProgressBar.m
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/10.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import "GameProgressBar.h"
#import "UIColor+ColorExtension.h"
#import "GameConfigs.h"

@implementation GameProgressBar
{
    CGSize  __originalSize;
    CGPoint __originalPosition;
}

+ (instancetype)barWithType:(GameProgressBarType)type frame:(CGRect)frame {
    
    GameProgressBar *bar = [GameProgressBar shapeNodeWithRect:frame cornerRadius:frame.size.width/2.f];
    [bar __setOriginalSize:bar.frame.size pos:bar.position];
    [bar updateProgress:0 animation:NO];
    bar.barType = type;
    
    return bar;
}

- (void)updateProgress:(CGFloat)progress animation:(BOOL)animation {
    
    CGFloat proDif = fabs((_progress - progress));
    
    _progress = progress;

    [self updateBar];
    [self removeAllActions];

    NSTimeInterval aniDuration = animation?(proDif*5.f):0.f;

    CGFloat y = __originalPosition.y + (1.00-progress)*__originalSize.height;
    
    
    SKAction *scaleAction = [SKAction scaleYTo:progress duration:aniDuration];
    SKAction *moveAction = [SKAction moveToY:y duration:aniDuration];
    [self runAction:[SKAction group:@[
                                      moveAction,
                                      scaleAction]]];
}

- (void)setBarType:(GameProgressBarType)barType {
    _barType = barType;
    [self updateBar];
}

- (void)updateBar {
    switch (self.barType) {
        case GameProgressBarTypeBubbleAdd:
            self.fillColor = [UIColor colorWithHexString:@"#0D2B3D"];
            break;
        case GameProgressBarTypeTime: {
            self.fillColor = self.progress>GameConfigs.nomuchTimeRate?[UIColor colorWithHexString:@"#887532"]:[UIColor colorWithHexString:@"#480916"];
            break;
        }
    }
}

- (void)__setOriginalSize:(CGSize)size pos:(CGPoint)pos {
    __originalSize  = size;
    __originalPosition = pos;
}

@end
