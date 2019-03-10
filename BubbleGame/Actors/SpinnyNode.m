//
//  SpinnyNode.m
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/10.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import "SpinnyNode.h"

@implementation SpinnyNode

+ (instancetype)spinnyNode {
    
    SpinnyNode *spinnyNode = [SpinnyNode shapeNodeWithRectOfSize:CGSizeMake(50, 50) cornerRadius:15];
    spinnyNode.lineWidth = 2.5;
    
    [spinnyNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI duration:1]]];
    [spinnyNode runAction:[SKAction sequence:@[
                                                [SKAction waitForDuration:0.5],
                                                [SKAction fadeOutWithDuration:0.5],
                                                [SKAction removeFromParent],
                                                ]]];
    return spinnyNode;
}

@end
