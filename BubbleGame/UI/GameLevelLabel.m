//
//  GameLevelLabel.m
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/10.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import "GameLevelLabel.h"
#import "UIColor+ColorExtension.h"

@implementation GameLevelLabel

+ (instancetype)levelLabelWithLevel:(NSInteger)level {
    GameLevelLabel *label = [[GameLevelLabel alloc] initWithFontNamed:@"04B_25"];
    label.fontColor = [UIColor colorWithHexString:@"#FFFD7C"];
    label.fontSize = 70;
    label.text =  [NSString stringWithFormat:@"0%li",(long)level+1];
    [label runAction:[SKAction repeatActionForever:
                      [SKAction sequence:@[[SKAction scaleTo:1.35 duration:1.5],
                                           [SKAction scaleTo:1 duration:1.5],
                                           [SKAction waitForDuration:2]
                                           ]]]];
    return label;
}

@end
