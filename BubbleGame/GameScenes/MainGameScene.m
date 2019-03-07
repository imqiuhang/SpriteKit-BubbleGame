//
//  GameScene.m
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/5.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import "MainGameScene.h"
#import "RedBall.h"
#import "Bubble.h"
#import "SpinnyNode.h"

@interface MainGameScene()<SKPhysicsContactDelegate>

@property (nonatomic,strong)Bubble *currentGrowthingBubble;

@end

@implementation MainGameScene

- (instancetype)initWithSize:(CGSize)size {
    if (self=[super initWithSize:size]) {
        [self setup];
    }
    return self;
}

#pragma mark - PhysicsContact
- (void)didBeginContact:(SKPhysicsContact *)contact {
    
}

- (void)didEndContact:(SKPhysicsContact *)contact {
    
}

#pragma mark - bubble
- (void)addBubbleInPosition:(CGPoint)pos {
    
    Bubble *bubble = [Bubble randomBubbleWithProb:0.25];
    bubble.position = pos;
    [self addChild:bubble];
    [bubble beganGrowthingWithTargetScale:GameConfigs.maxBubbleScale duration:GameConfigs.growing2MaxDuration];
    self.currentGrowthingBubble = bubble;
}

- (void)updateBubbleStausWhenTouchOff {
    [self.currentGrowthingBubble stopGrowthing];
    if (self.currentGrowthingBubble.xScale<GameConfigs.minBubble2Stay) {
        [self.currentGrowthingBubble fadeOut];
    }
    self.currentGrowthingBubble = nil;
}

#pragma mark - effect
- (void)addSpinnyInPosition:(CGPoint)pos {
    SpinnyNode *spinnyNode = [SpinnyNode spinnyNode];
    spinnyNode.position = pos;
    spinnyNode.strokeColor = [SKColor randomColor];
    [self addChild:spinnyNode];
}

#pragma mark  game loop
-(void)update:(CFTimeInterval)currentTime {
}

#pragma mark - touch control
- (void)touchDownAtPoint:(CGPoint)pos {
    [self addBubbleInPosition:pos];
}

- (void)touchMovedToPoint:(CGPoint)pos {
    [self addSpinnyInPosition:pos];
    [self updateBubbleStausWhenTouchOff];
}

- (void)touchUpAtPoint:(CGPoint)pos {
    [self updateBubbleStausWhenTouchOff];
}

#pragma mark touch delegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchDownAtPoint:[t locationInNode:self]];}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *t in touches) {[self touchMovedToPoint:[t locationInNode:self]];}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}

#pragma mark - setup
- (void)setup {
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsWorld.contactDelegate = self;
}

@end
