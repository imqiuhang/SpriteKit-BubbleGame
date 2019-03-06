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



@interface MainGameScene()<SKPhysicsContactDelegate>

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

#pragma mark - setup
- (void)setup {
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsWorld.contactDelegate = self;
}


#pragma mark - touch event
- (void)touchDownAtPoint:(CGPoint)pos {
    Bubble *bubble = [Bubble randomBubbleWithProb:0.25];
    bubble.position = pos;
    bubble.creating = YES;
    [self addChild:bubble];
}

- (void)touchMovedToPoint:(CGPoint)pos {

}

- (void)touchUpAtPoint:(CGPoint)pos {
    [self markBubblesOutTouching];
}

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

#pragma mark - private
- (void)markBubblesOutTouching {
    for(SKNode *node in self.children) {
        if ([node isKindOfClass:Bubble.class]) {
            Bubble *bubble = (Bubble *)node;
            bubble.creating = NO;
        }
    }
}

- (Bubble *)currentCreatingBubble {
    for(SKNode *node in self.children) {
        if ([node isKindOfClass:Bubble.class]) {
            Bubble *bubble = (Bubble *)node;
            if (bubble.creating) {
                return bubble;
            }
        }
    }
    return nil;
}

#pragma mark  draw
-(void)update:(CFTimeInterval)currentTime {
    Bubble *currentCreatingBubble = self.currentCreatingBubble;
    currentCreatingBubble.xScale +=kBubbleGrowingSpeed;
    currentCreatingBubble.yScale +=kBubbleGrowingSpeed;
    NSLog(@"%f\n", self.currentCreatingBubble.yScale);
}


@end
