//
//  GameEmitterManager.h
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/10.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface GameEmitterManager : NSObject

- (instancetype)initWithScene:(SKScene *)scene;
@property (nonatomic,weak,readonly)SKScene *relateScene;

- (instancetype)init NS_UNAVAILABLE;//using initWithScene:
+ (instancetype)new  NS_UNAVAILABLE;//using initWithScene:

- (void)runAddBubbleFaildEmitterWithPosition:(CGPoint)pos;
- (void)runAddBubbleSucceedEmitterWithNode:(SKNode *)node;
- (void)addSnowWithEdge:(UIEdgeInsets)edge;
- (void)removeSnow;
- (void)runGameSucceed;

+ (void)addFireForNode:(SKNode *)node;

@end

