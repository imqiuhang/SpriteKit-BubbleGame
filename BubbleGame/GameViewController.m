//
//  GameViewController.m
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/10.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import "GameViewController.h"
#import "MainGameScene.h"
#import "GameConfigs.h"

@interface GameViewController ()

@property (nonatomic,strong)MainGameScene *scene;
@property (nonatomic)NSInteger currentLevel;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGameWithConfig:MainGameSceneCreatConfig.firstConfig];
    
    for(NSString *fontFamilyName in [UIFont familyNames])
    {
        NSLog(@"\nfamily:'%@'",fontFamilyName);
        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontFamilyName])
        {
            NSLog(@"\tfont:'%@'",fontName);
        }
        NSLog(@"-------------\n");
    }
}

- (void)setupGameWithConfig:(MainGameSceneCreatConfig *)config {
    
    [self.scene removeFromParent];
    self.scene = nil;
    
    self.scene = [MainGameScene sceneWithSize:self.view.bounds.size config:config];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    
    SKView *skView = (SKView *)self.view;
    [skView presentScene:self.scene transition:[SKTransition revealWithDirection:SKTransitionDirectionLeft duration:0.75]];
    
    //debug
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    WeakSelf
    [self.scene setOnGameNeedRestart:^(BOOL isWin) {
        if (isWin) {
            weakSelf.currentLevel++;
        }
        MainGameSceneCreatConfig *config = [MainGameSceneCreatConfig new];
        config.isFirst = NO;
        config.level = weakSelf.currentLevel;
        config.isWin = isWin;
        [weakSelf setupGameWithConfig:config];
    }];
}

#pragma mark - config
- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
