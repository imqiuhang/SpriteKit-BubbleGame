//
//  GameEmitterManager.m
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/10.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import "GameEmitterManager.h"

@implementation GameEmitterManager

- (instancetype)initWithScene:(id)scene {
    if (self=[super init]) {
        _relateScene = scene;
    }
    return self;
}

- (void)runAddBubbleFaildEmitterWithPosition:(CGPoint)pos {
    
    SKEmitterNode* emnode=[SKEmitterNode nodeWithFileNamed:@"BubbleFaild.sks"];
    [self.relateScene addChild:emnode];
    emnode.position = pos;
    [emnode runAction:[SKAction sequence:@[[SKAction waitForDuration:2.f],
                                           [SKAction fadeOutWithDuration:0.5],
                                           [SKAction removeFromParent]]]];
    
}


- (void)runAddBubbleSucceedEmitterWithNode:(SKNode *)node {
    
    SKEmitterNode* emnode=[SKEmitterNode nodeWithFileNamed:@"BubbleSucceed.sks"];
    
    [emnode runAction:[SKAction sequence:@[[SKAction waitForDuration:1.f],
                                           [SKAction fadeOutWithDuration:0.5],
                                           [SKAction removeFromParent]]]];
    [node addChild:emnode];
}


@end
