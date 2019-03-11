//
//  GameEmitterManager.m
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/10.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import "GameEmitterManager.h"

@implementation GameEmitterManager
{
    SKEmitterNode* _snow;
}
- (instancetype)initWithScene:(id)scene {
    if (self=[super init]) {
        _relateScene = scene;
    }
    return self;
}

//例子系统可以直接通过属性赋值 或者通过可视化的操作
- (void)runAddBubbleFaildEmitterWithPosition:(CGPoint)pos {
    
    SKEmitterNode* emnode=[SKEmitterNode nodeWithFileNamed:@"BubbleFaild.sks"];
    [self.relateScene addChild:emnode];
    emnode.position = pos;
    
    //action也可以通过可视化的操作来生成
    [emnode runAction:[SKAction sequence:@[[SKAction waitForDuration:2.f],
                                           [SKAction fadeOutWithDuration:0.5],
                                           [SKAction removeFromParent]]]];
    
}


- (void)runAddBubbleSucceedEmitterWithNode:(SKNode *)node {
    
    SKEmitterNode* emnode=[SKEmitterNode nodeWithFileNamed:@"BubbleSucceed.sks"];
    emnode.position = node.position;
    [emnode runAction:[SKAction sequence:@[[SKAction waitForDuration:1.f],
                                           [SKAction fadeOutWithDuration:0.5],
                                           [SKAction removeFromParent]]]];
    [self.relateScene addChild:emnode];
}

- (void)runGameSucceed {
    SKEmitterNode* emnode=[SKEmitterNode nodeWithFileNamed:@"GameSucceed.sks"];
    emnode.position = CGPointMake(self.relateScene.size.width/2.f, self.relateScene.size.height/2.f);
    [emnode runAction:[SKAction sequence:@[[SKAction waitForDuration:2.f],
                                           [SKAction fadeOutWithDuration:1.0],
                                           [SKAction removeFromParent]]]];
    [self.relateScene addChild:emnode];
}

- (void)addSnowWithEdge:(UIEdgeInsets)edge {
    [self removeSnow];
    _snow = [SKEmitterNode nodeWithFileNamed:@"Snow.sks"];
    _snow.position =  CGPointMake(self.relateScene.size.width/2.f, self.relateScene.size.height-edge.top);
    
    [self.relateScene addChild:_snow];
    _snow.particlePositionRange = CGVectorMake(self.relateScene.size.width - edge.left - edge.right, 5);

}

- (void)removeSnow {
    [_snow removeFromParent];
    _snow = nil;
}

+ (void)addFireForNode:(SKNode *)node {
    
    SKEmitterNode *fire = [SKEmitterNode nodeWithFileNamed:@"Fire.sks"];
    fire.position =  CGPointMake(0, 16);
    
    [node addChild:fire];
}

@end
