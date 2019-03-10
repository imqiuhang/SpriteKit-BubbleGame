//
//  GameScene.h
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/10.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class MainGameSceneCreatConfig;

@interface MainGameScene : SKScene

@property (nonatomic,copy)void(^onGameNeedRestart)(BOOL isWin);

+ (instancetype)sceneWithSize:(CGSize)size config:(MainGameSceneCreatConfig *)configs;

@property (nonatomic,strong,readonly)MainGameSceneCreatConfig *configs;

@end

@interface MainGameSceneCreatConfig : NSObject

@property (nonatomic)BOOL isWin;
@property (nonatomic)BOOL isFirst;
@property (nonatomic)BOOL level;

+ (instancetype)firstConfig;

@end
