//
//  GameButton.m
//  BubbleGame
//
//  Created by imqiuhang on 2019/3/10.
//  Copyright © 2019 imqiuhang. All rights reserved.
//

#import "GameButton.h"

@implementation GameButton

+ (instancetype)buttonWithImageNamed:(NSString *)imageNamed {
    GameButton *button =  [[GameButton alloc] initWithImageNamed:imageNamed];
    button.userInteractionEnabled = YES;
    return button;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.onSelectCallback) {
        self.onSelectCallback(self);
    }
}

@end
