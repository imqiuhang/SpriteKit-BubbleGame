//
//  MianSoundManager.h
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/10.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface MianSoundManager : NSObject

- (instancetype)initWithScene:(SKScene *)scene;
@property (nonatomic,weak,readonly)SKScene *relateScene;

- (instancetype)init NS_UNAVAILABLE;//using initWithScene:
+ (instancetype)new  NS_UNAVAILABLE;//using initWithScene:

- (void)controlBgMusicWithPlay:(BOOL)play;
- (void)controlBubbleGrowingSoundWithPlay:(BOOL)play;
- (void)playMakeBubbleFaildSoundForTooSmall;
- (void)playMakeBubbleFaildSoundForByHit;
- (void)playReadyGoSound;
- (void)playGameSucceedSound;
- (void)playGameFaildSound;


@end

