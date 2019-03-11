//
//  MianSoundManager.m
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/10.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import "MianSoundManager.h"
#import "GameConfigs.h"

@interface MianSoundManager ()

@property (nonatomic,strong)SKAudioNode *backgroundAudio;
@property (nonatomic,strong)SKAudioNode *bubbleGroweningAudio;

@end

@implementation MianSoundManager
{
    BOOL __playedNomuchTimeSound;
}

- (instancetype)initWithScene:(id)scene {
    if (self=[super init]) {
        _relateScene = scene;
    }
    return self;
}

/*播放音视频有多种方法，1种是通过action，例如下面的playReadyGoSound，一种是通过音视频node，哈可以通过AVFundation播放，
 但是使用非SKKit提供的类和方法都不能被自动管理 */
- (void)controlBgMusicWithPlay:(BOOL)play {
    //也可以通过action来循环播放，但是会偶现bug
//    [self.relateScene runAction:[SKAction repeatAction:[[[SKAudioNode alloc] initWithFileNamed:@"bubble_growing.wav"]] count:0]
    
    if (play) {
        [self controlBgMusicWithPlay:NO];
        self.backgroundAudio = [[SKAudioNode alloc] initWithFileNamed:@"backmusic.wav"];
        self.backgroundAudio.autoplayLooped = YES;
        [self.relateScene addChild:self.backgroundAudio];
    }else {
        [self.backgroundAudio removeFromParent];
        self.backgroundAudio = nil;
    }
}

- (void)controlBubbleGrowingSoundWithPlay:(BOOL)play {
    
    if (play) {
        [self controlBubbleGrowingSoundWithPlay:NO];
        self.bubbleGroweningAudio = [[SKAudioNode alloc] initWithFileNamed:@"bubble_growing.wav"];
        self.bubbleGroweningAudio.autoplayLooped = YES;
        [self.relateScene addChild:self.bubbleGroweningAudio];
    }else {
        [self.bubbleGroweningAudio removeFromParent];
        self.bubbleGroweningAudio = nil;
    }
    
}

//如何重复播放呢？通过嵌套repeatAction
- (void)playMakeBubbleFaildSoundForTooSmall {
    [self.relateScene runAction:[SKAction playSoundFileNamed:@"bubble_made_faild_toosmall.wav" waitForCompletion:NO]];
}

- (void)playMakeBubbleFaildSoundForByHit {
    [self.relateScene runAction:[SKAction playSoundFileNamed:@"bubble_made_faild_byhit.wav" waitForCompletion:NO]];
}

- (void)playReadyGoSound {
    [self.relateScene runAction:[SKAction playSoundFileNamed:@"game_readyGo.wav" waitForCompletion:NO]];
}

- (void)playGameSucceedSound {
    [self.relateScene runAction:[SKAction playSoundFileNamed:@"game_succeed.wav" waitForCompletion:NO]];
}

- (void)playGameFaildSound {
    [self.relateScene runAction:[SKAction playSoundFileNamed:@"game_faild.wav" waitForCompletion:NO]];
}

- (void)playNomuchTimeSound {
    if (!__playedNomuchTimeSound) {
        __playedNomuchTimeSound = YES;
        SKAudioNode *audio = [[SKAudioNode alloc] initWithFileNamed:@"timer_nomuch.wav"];
        audio.autoplayLooped = YES;
        [self.relateScene addChild:audio];
    }
}

@end
