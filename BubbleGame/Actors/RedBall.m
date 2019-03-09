//
//  RedBall.m
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/6.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import "RedBall.h"

@implementation RedBall

+ (instancetype)redBall {
    
    RedBall *redBall = [RedBall spriteNodeWithImageNamed:@"ball"];
    [redBall setScale:5];
    redBall.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:redBall.size.width/2.f];
    redBall.physicsBody.affectedByGravity = NO;
    redBall.physicsBody.mass = 10;
    redBall.physicsBody.angularDamping = 0.f;
    redBall.physicsBody.linearDamping = 0.f;
    redBall.physicsBody.restitution = 1.f;//反弹的动量
    redBall.physicsBody.friction = 0.f;
    redBall.physicsBody.allowsRotation = YES;
    redBall.physicsBody.usesPreciseCollisionDetection = YES;
    return redBall;
}

- (void)setEffectType:(RedBallEffectType)effectType {
    if (effectType==_effectType) {
        return;
    }
    _effectType = effectType;
    
    self.texture  = [SKTexture textureWithImageNamed:effectType==RedBallEffectTypeIceing?@"ball_ice":@"ball"];
    BOOL isIceStatus = effectType==RedBallEffectTypeIceing;
    CGVector originalVelocity = self.physicsBody.velocity ;
    self.physicsBody.velocity = CGVectorMake(isIceStatus?(originalVelocity.dx*GameConfigs.redBallIceSpeedReducedRate):(originalVelocity.dx/GameConfigs.redBallIceSpeedReducedRate), isIceStatus?(originalVelocity.dy*GameConfigs.redBallIceSpeedReducedRate):(originalVelocity.dy/GameConfigs.redBallIceSpeedReducedRate));
}

@end
