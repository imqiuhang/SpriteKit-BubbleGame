//
//  GameScene.m
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/10.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import "MainGameScene.h"
#import "RedBall.h"
#import "Bubble.h"
#import "SpinnyNode.h"
#import "MianSoundManager.h"
#import "GameEmitterManager.h"
#import "GameButton.h"
#import "GameLevelLabel.h"

static  UIEdgeInsets const kPhysicsWorldInsert = (UIEdgeInsets){125, 118, 115, 118};

@interface MainGameScene()<SKPhysicsContactDelegate>

@property (nonatomic,strong)Bubble *currentGrowthingBubble;
@property (nonatomic)NSInteger randomFlag;

@property (nonatomic,strong)MianSoundManager *soundManager;
@property (nonatomic,strong)GameEmitterManager *emitterManager;

@property (nonatomic)CFTimeInterval gameBeganTime;

@end

@implementation MainGameScene
{
    BOOL _isGameStart;
}

+ (instancetype)sceneWithSize:(CGSize)size config:(MainGameSceneCreatConfig *)configs {
    return [[MainGameScene alloc] initWithSize:size config:configs];
}

- (instancetype)initWithSize:(CGSize)size config:(MainGameSceneCreatConfig *)configs {
    if (self=[super initWithSize:size]) {
        _configs  = configs;
        [self setupGamePrepareContent];
    }
    return self;
}

#pragma mark - PhysicsContact
- (void)didBeginContact:(SKPhysicsContact *)contact {
    
}

- (void)didEndContact:(SKPhysicsContact *)contact {
    
    RedBall *redBall = nil;
    Bubble  *bubble = nil;
    
    if ([contact.bodyA.node isKindOfClass:RedBall.class]) {
        redBall = (RedBall*)contact.bodyA.node;
        bubble = (Bubble*)contact.bodyB.node;
    }else {
        redBall = (RedBall*)contact.bodyB.node;
        bubble = (Bubble*)contact.bodyA.node;
    }
    
    if (!([redBall isKindOfClass:RedBall.class]&&[bubble isKindOfClass:Bubble.class])) {
        return;
    }
    
    redBall.effectType = bubble.bubbleType==BubbleTypeIce?RedBallEffectTypeIceing:RedBallEffectTypeNone;
    
    if (bubble.growthing) {
        [bubble stopGrowthing];
        [self creatBubbleFaildWithBubble:bubble];
        [self.soundManager playMakeBubbleFaildSoundForByHit];
        [bubble fadeOut];
        self.currentGrowthingBubble = nil;
    }
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
    
    [self.soundManager controlBubbleGrowingSoundWithPlay:YES];
}

- (void)updateBubbleStausWhenTouchOff {
    
    if (!self.currentGrowthingBubble) {
        return;
    }
    
    [self.currentGrowthingBubble stopGrowthing];
    self.currentGrowthingBubble.physicsBody.affectedByGravity = self.currentGrowthingBubble.bubbleType==BubbleTypeIce;
    if (self.currentGrowthingBubble.xScale<GameConfigs.minBubble2Stay) {
        [self.currentGrowthingBubble fadeOut];
        [self creatBubbleFaildWithBubble:self.currentGrowthingBubble];
        [self.soundManager playMakeBubbleFaildSoundForTooSmall];
    }else {
        [self creatGreatBubbleSucceedWithBubble:self.currentGrowthingBubble];
    }
    self.currentGrowthingBubble = nil;
    
//
}

#pragma Mark- redball
- (void)setupRedballs {
    
    CGFloat speed = GameConfigs.redBallSpeedNormal;
    
    NSArray *vectors = @[[NSValue valueWithCGVector:CGVectorMake(speed, speed)],
                         [NSValue valueWithCGVector:CGVectorMake(speed, -speed)],
                         [NSValue valueWithCGVector:CGVectorMake(-speed, speed)],
                         [NSValue valueWithCGVector:CGVectorMake(-speed, -speed)]];
    
    for(int i=0;i<3+self.configs.level;i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((0.5*i + 1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            RedBall *redball = [RedBall redBall];
            redball.physicsBody.collisionBitMask = GameConfigs.redBallCollisionBitMask;
            redball.physicsBody.contactTestBitMask = GameConfigs.bubbleCollisionBitMask;
            redball.position = CGPointMake(self.size.width/2.f, self.size.height/2.f);
            [self addChild:redball];
            //可以通过施加一个推力（牛顿）或者直接赋值速度，直接赋值速度比较方便，推力需要计算
//            [redball.physicsBody applyForce:[vectors[i] CGVectorValue]];
            redball.physicsBody.velocity = [vectors[i%vectors.count] CGVectorValue];
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
    
    if (_isGameStart) {
        if(self.gameBeganTime==0){
            self.gameBeganTime = currentTime;
        }else {
            [self updateGameDuration:currentTime - self.gameBeganTime];
        }
    }
}

- (void)updateGameDuration:(CFTimeInterval)gameDuration {
    
}

#pragma mark - touch control
- (void)touchDownAtPoint:(CGPoint)pos {
    if (!_isGameStart) {
        return;
    }
    [self addBubbleInPosition:pos];
}

- (void)touchMovedToPoint:(CGPoint)pos {
    
    [self addSpinnyInPosition:pos];
    
    if (!_isGameStart) {
        return;
    }
}

- (void)touchUpAtPoint:(CGPoint)pos {
    if (!_isGameStart) {
        return;
    }
    [self updateBubbleStausWhenTouchOff];
}

#pragma mark - grade
- (void)creatGreatBubbleSucceedWithBubble:(Bubble *)bubble {
     [self.soundManager controlBubbleGrowingSoundWithPlay:NO];
    [self.emitterManager runAddBubbleSucceedEmitterWithNode:bubble];
    NSLog(@"-------创建泡泡成功-------\n size:%f",bubble.size.width);
}

- (void)creatBubbleFaildWithBubble:(Bubble *)bubble {
    [self.soundManager controlBubbleGrowingSoundWithPlay:NO];
    [self.emitterManager runAddBubbleFaildEmitterWithPosition:bubble.position];
    NSLog(@"-------创建泡泡失败-------\n size:%f",bubble.size.width);
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
- (void)setupGamePrepareContent {
    
    self.physicsWorld.gravity = CGVectorMake(0, -9.8);
    self.physicsWorld.contactDelegate = self;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(kPhysicsWorldInsert.left, kPhysicsWorldInsert.top, self.size.width-kPhysicsWorldInsert.left-kPhysicsWorldInsert.right, self.size.height-kPhysicsWorldInsert.top-kPhysicsWorldInsert.bottom)];
    
    self.soundManager = [[MianSoundManager alloc] initWithScene:self];
    [self.soundManager controlBgMusicWithPlay:YES];
    
    self.emitterManager = [[GameEmitterManager alloc] initWithScene:self];
    
    SKSpriteNode *bgImageNode = [[SKSpriteNode alloc] initWithImageNamed:@"background"];
    bgImageNode.size = self.size;
    bgImageNode.position = CGPointMake(self.size.width/2.f, self.size.height/2.f);
    [self addChild:bgImageNode];
    
    [self.emitterManager addSnowWithEdge:kPhysicsWorldInsert];
    
    GameButton *startGameBtn = [GameButton buttonWithImageNamed:@"startGame"];
    startGameBtn.position = CGPointMake(self.size.width/2.f, self.size.height/2.f);
    [startGameBtn setScale:3.f];
    [GameEmitterManager addFireForNode:startGameBtn];
    [self addChild:startGameBtn];
    WeakSelf;
    [startGameBtn setOnSelectCallback:^(GameButton *button) {
        [weakSelf setUpStartGameContent];
        [button runAction:[SKAction sequence:@[
                                               [SKAction fadeOutWithDuration:2.f],
                                               [SKAction removeFromParent],
                                               ]]];
    }];
    
    GameLevelLabel *levelLabel = [GameLevelLabel levelLabelWithLevel:self.configs.level];
    levelLabel.position =CGPointMake(self.size.width/2.f+95, self.size.height - kPhysicsWorldInsert.top/2.f-16);
    [self addChild:levelLabel];
    
}

- (void)setUpStartGameContent {
    [self.soundManager playReadyGoSound];
    [self setupRedballs];
    [self setupMenu];
    _isGameStart = YES;
}

- (void)setupMenu {
    
    GameButton *gameContrlBtn = [GameButton buttonWithImageNamed:@"game_stop"];
    gameContrlBtn.position = CGPointMake(100, 50);
    [gameContrlBtn setScale:3];
    WeakSelf;
    [gameContrlBtn setOnSelectCallback:^(GameButton *button){
        weakSelf.paused = !weakSelf.paused;
        button.texture = [SKTexture textureWithImageNamed:weakSelf.paused?@"game_play":@"game_stop"] ;
    }];
    [self addChild:gameContrlBtn];
}


@end


@implementation MainGameSceneCreatConfig

+ (instancetype)firstConfig {
    MainGameSceneCreatConfig *config = [MainGameSceneCreatConfig new];
    config.isFirst = YES;
    return config;
}

@end
