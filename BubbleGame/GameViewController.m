//
//  GameViewController.m
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/5.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import "GameViewController.h"
#import "MainGameScene.h"

@interface GameViewController ()

@property (nonatomic,strong)MainGameScene *scene;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGame];
}

- (void)setupGame {
    
    self.scene = [MainGameScene sceneWithSize:self.view.bounds.size];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    
    SKView *skView = (SKView *)self.view;
    [skView presentScene:self.scene];
    
    //debug
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
}

#pragma mark - config
- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
