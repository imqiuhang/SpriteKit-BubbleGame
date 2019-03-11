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
#import "GameProgressBar.h"

static  UIEdgeInsets const kPhysicsWorldInsert = (UIEdgeInsets){125, 118, 115, 118};

@interface MainGameScene()<SKPhysicsContactDelegate>

@property (nonatomic,strong)Bubble *currentGrowthingBubble;
@property (nonatomic)NSInteger randomFlag;

@property (nonatomic,strong)MianSoundManager *soundManager;
@property (nonatomic,strong)GameEmitterManager *emitterManager;

@property (nonatomic,strong)GameProgressBar *bubbleAddBar;
@property (nonatomic,strong)GameProgressBar *timeBar;

@property (nonatomic)CFTimeInterval gameBeganTime;
@property (nonatomic)CGFloat bubbleProgess;;

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
    //假如创建的是冰球，我们让他受到重力影响 看下效果
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
    
/*  -------------> △vx
    | .        /
    |    .    /
    |       ./
    |       /  垂直方向是角速度,也就是速度的向量
    |      /
    |     /
    |    /
    |   /
    |  /
    | /
   △vy
  */
    
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
            //可以通过施加一个推力（牛顿）或者j冲量 或者直接赋值速度，直接赋值速度比较方便，推力需要计算
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
//每隔0.01秒调用 currentTime 是秒 精确到后三位 例如1.002秒
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
    if (gameDuration>=GameConfigs.totalTimeForPass) {
        if (self.onGameNeedRestart) {
            self.onGameNeedRestart(NO);
        }
        return;
    }
    CGFloat progress = 1.00f-(gameDuration/GameConfigs.totalTimeForPass);
    [self.timeBar updateProgress:progress animation:NO];
    if (progress<=GameConfigs.nomuchTimeRate) {
        [self.soundManager playNomuchTimeSound];
    }
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
    self.bubbleProgess+=(0.2 * (bubble.xScale/GameConfigs.maxBubbleScale));
    NSLog(@"-------创建泡泡成功-------\n size:%f",bubble.size.width);
}

- (void)creatBubbleFaildWithBubble:(Bubble *)bubble {
    [self.soundManager controlBubbleGrowingSoundWithPlay:NO];
    [self.emitterManager runAddBubbleFaildEmitterWithPosition:bubble.position];
    self.bubbleProgess-=(0.2 * (bubble.xScale/GameConfigs.maxBubbleScale));
    NSLog(@"-------创建泡泡失败-------\n size:%f",bubble.size.width);
}

- (void)setBubbleProgess:(CGFloat)bubbleProgess {
    
    bubbleProgess = MAX(0, bubbleProgess);
    
    _bubbleProgess = bubbleProgess;
    if (bubbleProgess>=1) {
        if(self.onGameNeedRestart) {
            self.onGameNeedRestart(YES);
        }
        return;
    }
    [self.bubbleAddBar updateProgress:bubbleProgess animation:YES];
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
    
    //因为坐标系是从下往上的，和现实世界相反，所以重力是负数
    self.physicsWorld.gravity = CGVectorMake(0, -9.8);
    
    //设置世界的碰撞代理
    self.physicsWorld.contactDelegate = self;
    
    //设置这个世界的边界，任何刚体都无法通过力的作用逃离这个世界的边界
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(kPhysicsWorldInsert.left, kPhysicsWorldInsert.top, self.size.width-kPhysicsWorldInsert.left-kPhysicsWorldInsert.right, self.size.height-kPhysicsWorldInsert.top-kPhysicsWorldInsert.bottom)];
    
    //初始化声音，例子系统
    self.soundManager = [[MianSoundManager alloc] initWithScene:self];
    [self.soundManager controlBgMusicWithPlay:YES];
    self.emitterManager = [[GameEmitterManager alloc] initWithScene:self];

    SKSpriteNode *bgImageNode = [[SKSpriteNode alloc] initWithImageNamed:@"background"];
    bgImageNode.size = self.size;
    //position是物体的中间点
    bgImageNode.position = CGPointMake(self.size.width/2.f, self.size.height/2.f);
    //addChild，和addSubView类似
    [self addChild:bgImageNode];
    
    if (self.configs.isWin) {
        [self.soundManager playGameSucceedSound];
        [self.emitterManager runGameSucceed];
    }else if (!self.configs.isFirst) {
        [self.soundManager playGameFaildSound];
    }
    
    [self.emitterManager addSnowWithEdge:kPhysicsWorldInsert];
    
    //开始游戏的按钮
    GameButton *startGameBtn = [GameButton buttonWithImageNamed:@"startGame"];
    startGameBtn.position = CGPointMake(self.size.width/2.f, self.size.height/2.f);
    [startGameBtn setScale:3.f];
    [GameEmitterManager addFireForNode:startGameBtn];
    [self addChild:startGameBtn];
    WeakSelf;
    [startGameBtn setOnSelectCallback:^(GameButton *button) {
        button.userInteractionEnabled = NO;
        [weakSelf setUpStartGameContent];
        [button runAction:[SKAction sequence:@[
                                               [SKAction fadeOutWithDuration:2.f],
                                               [SKAction removeFromParent],
                                               ]]];
    }];
    
    GameLevelLabel *levelLabel = [GameLevelLabel levelLabelWithLevel:self.configs.level];
    levelLabel.position =CGPointMake(self.size.width/2.f+95, self.size.height - kPhysicsWorldInsert.top/2.f-16);
    [self addChild:levelLabel];
    
    [self setupProgressBar];
    
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

- (void)setupProgressBar {
    
    CGFloat barHeight = 460;
    CGFloat barWidth = 34;
    CGFloat barYPos = 277;
    
    self.bubbleAddBar = [GameProgressBar barWithType:GameProgressBarTypeBubbleAdd frame:CGRectMake(51, barYPos, barWidth, barHeight)];
    [self addChild:self.bubbleAddBar];
    [self.bubbleAddBar updateProgress:0.f animation:NO];
    
    
    self.timeBar = [GameProgressBar barWithType:GameProgressBarTypeTime frame:CGRectMake(self.size.width - 75, barYPos, barWidth, barHeight)];
    [self addChild:self.timeBar];
    [self.timeBar updateProgress:1.f animation:NO];
    
    
}


@end


@implementation MainGameSceneCreatConfig

+ (instancetype)firstConfig {
    MainGameSceneCreatConfig *config = [MainGameSceneCreatConfig new];
    config.isFirst = YES;
    return config;
}

@end
