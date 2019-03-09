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

@property (nonatomic)NSInteger randomFlag;

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
    
    Bubble *bubble = [Bubble bubbleForIce:self.randomFlag>0&&self.randomFlag%3==0];
    bubble.physicsBody.collisionBitMask = GameConfigs.bubbleCollisionBitMask;
    bubble.physicsBody.contactTestBitMask = GameConfigs.redBallCollisionBitMask;
    bubble.position = pos;
    [self addChild:bubble];
    [bubble beganGrowthingWithTargetScale:GameConfigs.maxBubbleScale duration:GameConfigs.growing2MaxDuration];
    self.currentGrowthingBubble = bubble;
    
    self.randomFlag ++;
}

- (void)updateBubbleStausWhenTouchOff {
    [self.currentGrowthingBubble stopGrowthing];
    self.currentGrowthingBubble.physicsBody.affectedByGravity = self.currentGrowthingBubble.bubbleType==BubbleTypeIce;
    if (self.currentGrowthingBubble.xScale<GameConfigs.minBubble2Stay) {
        [self.currentGrowthingBubble fadeOut];
    }
    self.currentGrowthingBubble = nil;
}

#pragma Mark- redball
- (void)setupRedballs {
    
    CGFloat force = GameConfigs.redBallSpeedForce;
    
    NSArray *vectors = @[[NSValue valueWithCGVector:CGVectorMake(force, force)],
                         [NSValue valueWithCGVector:CGVectorMake(force, -force)],
                         [NSValue valueWithCGVector:CGVectorMake(-force, force)]];
    
    for(int i=0;i<3;i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            RedBall *redball = [RedBall redBall];
            redball.physicsBody.collisionBitMask = GameConfigs.redBallCollisionBitMask;
            redball.physicsBody.contactTestBitMask = GameConfigs.bubbleCollisionBitMask;
            redball.position = CGPointMake(self.size.width/2.f + i*30, self.size.height/2.f);
            [self addChild:redball];
            [redball.physicsBody applyForce:[vectors[i] CGVectorValue]];
        });
    }
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
    
    self.physicsWorld.gravity = CGVectorMake(0, -9.8);
    self.physicsWorld.contactDelegate = self;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupRedballs];
    });
}

@end
