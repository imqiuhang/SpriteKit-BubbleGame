//
//  GameButton.h
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/10.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameButton : SKSpriteNode

+ (instancetype)buttonWithImageNamed:(NSString *)imageNamed;

@property (nonatomic,copy)void(^onSelectCallback)(GameButton *button);

@end

