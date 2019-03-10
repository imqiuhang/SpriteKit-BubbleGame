//
//  RedBall.m
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/10.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import "RedBall.h"

@implementation RedBall

+ (instancetype)redBall {
    
    RedBall *redBall = [RedBall spriteNodeWithImageNamed:@"ball"];
    [redBall setScale:5];
    redBall.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:redBall.size.width/2.f];
    
//------------------------init configs---------------------------------
    redBall.physicsBody.affectedByGravity = NO;//不受重力影响
    redBall.physicsBody.mass = 10;//质量 10kg
    redBall.physicsBody.angularDamping = 0.f;//角动量摩擦力
    redBall.physicsBody.linearDamping = 0.f;//线性摩擦力
    redBall.physicsBody.restitution = 1.f;//反弹的动量
    redBall.physicsBody.friction = 0.f;//摩擦力
    redBall.physicsBody.allowsRotation = YES;//允许受到角动量
    redBall.physicsBody.usesPreciseCollisionDetection = YES;//独立计算碰撞
    
    return redBall;
}

- (void)setEffectType:(RedBallEffectType)effectType {
    if (effectType==_effectType) {
        return;
    }
    _effectType = effectType;
    
    self.texture  = [SKTexture textureWithImageNamed:effectType==RedBallEffectTypeIceing?@"ball_ice":@"ball"];
    
    //碰撞后拿出原有的角速度的方向 赋值到新速度，方向不变 d速度减半或者恢复
    CGVector originalVelocity = self.physicsBody.velocity ;
    CGFloat dxv = originalVelocity.dx>=0?1:-1;
    CGFloat dyv = originalVelocity.dy>=0?1:-1;
    CGFloat v = effectType==RedBallEffectTypeIceing?GameConfigs.redBallSpeedIce:GameConfigs.redBallSpeedNormal;
    self.physicsBody.velocity = CGVectorMake(v*dxv, v*dyv);
}

@end
