<!--可以在 https://macdown.uranusjr.com/  下载Markdown支持工具Macdown-->
### iOS 2D游戏框架-SpriteKit的一些实践过程
###### @author [imqiuhang](https://github.com/imqiuhang)

##### 传送门🚪 imqiuhang其他文章
1. [CoreAnimation深入学习的愉快探讨](https://github.com/imqiuhang/CoreAnimationLearning/blob/master/README.md)
2. [CoreML2-iOS12机器学习的一些了解和实践过程](https://github.com/imqiuhang/CoreML2-Learning)
3. [关于设计模式的一些思考和改进](https://www.jianshu.com/p/1d1ae95078ee)
4. [iOS SpriteKit的一些实践过程](https://github.com/imqiuhang/BubbleGame)
5. ...努力定时更新中...^_^



### 📣前言
>如果你是iOS开发者，刚好对2D游戏感兴趣，或者想在你的APP中增加一些有趣的场景互动，那么SpriteKit会是一个很好的选择，优秀的物理引擎，熟悉的OC/swift语言配方，和UIKit的无缝对接，使得学习成本非常的低，假如你刚好也了解Cocos2D相关，那么学习成本几乎为0。不过即使之前没有任何物理引擎和2D游戏的了解也没关系，因为我们的Apple已经把生涩难懂的部分封装成了非常简单的API供我们调用即可。

<br>

### 📣说明

###### 1. 📎[本文Demo](https://github.com/imqiuhang/BubbleGame)  由于时间问题，目前尺寸没有适配，使用12.9的iPad pro模拟器或者真机进行游戏，模拟器启动后可以在hardware -> rotate left进行旋转方便查看


###### 2. ❓由于才疏学浅，错误在所难免，有错误的地方以及补充欢迎在[issues](https://github.com/imqiuhang/BubbleGame/issues)中提出，第一时间更正，谢谢！

###### 3. 本游戏的是本人之前在大二的时候基于XNA制作的Windows游戏的改写的，素材都直接用的之前的素材，所以所有的P图，音效等都显得比较[幼稚]^_^，还请谅解。

##### BubbleGame的游戏大致截图

![bubbleGame.gif](https://upload-images.jianshu.io/upload_images/3058688-38bc8b8b544c552f.gif?imageMogr2/auto-orient/strip)

###### 首先，先解释下这个游戏的规则，这个游戏是个关卡游戏，每一关会生成N+3个红球。我们可以点击屏幕创建一个泡泡，泡泡创建完成后会获得分数，左边是对应的进度，进度满了以后进入下一关。当泡泡过小，或者在创建的过程中被红球碰到都会移除并扣分，右边是时间进度，时间结束后分数不足则失败。泡泡有2种类型，普通和冰泡泡。冰泡泡会受到重力影响，创建后下沉，并且红球碰到冰泡泡会减少50%的移动速度，碰到普通泡泡后恢复速度。进入到下一关后红球数量变多，需要的分数变多，时间变少。

##### 这样我们这个游戏涉及到精灵（角色），音乐，关卡，物理碰撞，重力，动画等。

<br>
---

`🚪好了，让我们一起进入到SpriteKit的物理世界中吧。`

--- 

### 🔍 例行先看下SpriteKit目录
###### ✅表示本文涉及到，❤️表示重点探讨
<!--CoreAnimation头文件包含-->

```objc
#import <SpriteKit/SKScene.h> ❤️
#import <SpriteKit/SKCameraNode.h>
#import <SpriteKit/SKNode.h>❤️
#import <SpriteKit/SKSpriteNode.h>✅
#import <SpriteKit/SKEmitterNode.h>✅
#import <SpriteKit/SKShapeNode.h>✅
#import <SpriteKit/SKEffectNode.h>
#import <SpriteKit/SKFieldNode.h>
#import <SpriteKit/SKLabelNode.h>✅
#import <SpriteKit/SKVideoNode.h>
#import <SpriteKit/SKAudioNode.h>✅
#import <SpriteKit/SKCropNode.h>
#import <SpriteKit/SKLightNode.h>
#import <SpriteKit/SKReferenceNode.h>
#import <SpriteKit/SK3DNode.h>
#import <SpriteKit/SKTransformNode.h>
#import <SpriteKit/SKRegion.h>
#import <SpriteKit/SKView.h>❤️
#import <SpriteKit/SKTransition.h>
#import <SpriteKit/SKShader.h>
#import <SpriteKit/SKUniform.h>
#import <SpriteKit/SKAttribute.h>
#import <SpriteKit/SKWarpGeometry.h>
#import <SpriteKit/SKRenderer.h>

#import <SpriteKit/SKTileDefinition.h>
#import <SpriteKit/SKTileSet.h>
#import <SpriteKit/SKTileMapNode.h>

#import <SpriteKit/SKTexture.h>✅
#import <SpriteKit/SKMutableTexture.h>
#import <SpriteKit/SKTextureAtlas.h>

#import <SpriteKit/SKConstraint.h>
#import <SpriteKit/SKReachConstraints.h>

#import <SpriteKit/SKAction.h>❤️

#import <SpriteKit/SKPhysicsBody.h>❤️
#import <SpriteKit/SKPhysicsJoint.h>
#import <SpriteKit/SKPhysicsWorld.h>❤️

```

### 什么是SpriteKit

> 首先要知道什么是Sprite。Sprite的中文译名就是精灵，在游戏开发中，精灵指的是以图像方式呈现在屏幕上的一个图像。这个图像也许可以移动，用户可以与其交互，也有可能仅只是游戏的一个静止的背景图。塔防游戏中敌方源源不断涌来的每个小兵都是一个精灵，我方防御塔发出的炮弹也是精灵。可以说精灵构成了游戏的绝大部分主体视觉内容，而一个2D引擎的主要工作，就是高效地组织，管理和渲染这些精灵。SpriteKit是在iOS7 SDK中Apple新加入的一个2D游戏引擎框架，在SpriteKit出现之前，iOS开发平台上已经出现了像cocos2d这样的比较成熟的2D引擎解决方案。SpriteKit展现出的是Apple将Xcode和iOS/Mac SDK打造成游戏引擎的野心，但是同时也确实与IDE有着更好的集成，减少了开发者的工作。[这段摘录@onevcat WWDC 2013 Session笔记]


### 一些类似框架对比
| 框架 | 一句话 |平台 |语言 |引擎 |特点 | 
| :------: | :------: |:------: | :------: | :------: | :------: | 
| SpriteKit | Create 2D sprite-based games using an optimized animation  |iOS 7.0+ <br>macOS 10.9+ <br>tvOS 9.0+ <br>watchOS 3.0+<br> |OC/swift |Box2D（C++） |基于UIKit一套实现，实现和对接最为方便 | 
| SceneKit | A high-level 3D scene framework |iOS 8.0+ <br>macOS 10.8+ <br>tvOS 9.0+ <br>watchOS 3.0+<br> |OC/swift |/ |2D 3D两开花 |
| Cocos | a unified package of game development tools |跨平台 |C++/JS/lua |Cocos2d-x（C++） |跨平台 |
| XNA | XNA Runtime |Windows <br>Xbox <br>其他（可使用mono跨平台） |C# |/ |微软大法好 |


### 在进入开发之前，首先先聊一些无聊的概念
在开发之前，我们先了解一下SpriteKit或者说Cocos(两者的概念基本一直，甚至API的名字都大致相同)的一些基本概念，这些概念有别于我们平常的UIKit相关的开发。

#### SKNode
> SKNode在SpriteKit游戏场景中，就像是UIKit里的UIView，所有能感受到单元的都是一个Node，都是`SKNode`子类，包括可见的（例如各种图片，主角，精灵，技能展现，背景，按钮，人物角色，粒子，视频，甚至整个游戏场景也是一个Node）听见的（背景音乐，特效声音）等，Node和我们的UIView `- (void)addSubview:(UIView *)view;`非常相似，可以通过`- (void)addChild:(SKNode *)node;`来添加一个子Node,其他例如insert remove等操作也有一一对应。，另外SKNode继承UIResponder，也就是说每一个Node都可以处理交互事件。我们先过一次Node的基本属性，以了解他的基本特性。

| 属性/方法| 说明 |
| :------: | :------: |
|frame | readonly，这点区别于View，frame 无法直接修改|
|position | 需要注意和UIView的一些不同，Node的position是中心位置，不是左上角。另外游戏场景里的坐标系是左下角为0,0而不是左上角 |
| xScale/yScale|x和y方向的缩放，可以直接调用setScale:一起修改  |
| speed| 对这个node所有的action的速度做一次批量修改 |
|alpha |  |
| paused|  刚才也说了，游戏场景也继承于node,暂停后这个node和子node所有的事件都会暂停|
|userInteractionEnabled | 和UIView类似，NO表示不接受用户交互 |
|parent/children | 和UIView superView,subViews类似 |
| scene| node所在的场景 |
| physicsBody| node关联的刚体，node只有关联了刚体才能参与物理事件，否则就像是个背景图，对整个世界和其他物体没有任何碰撞等物理作用 |
|addChild:/insertChild:...|和UIView一样|
|runAction:|类似CALayer addAnimation:|
|convertPoint:|坐标系相关|
|||

就像是UIKit提供了button，label，textfield,imageview等UIView的子类。我们看下框架提供的的一些node种类

| Node| 说明 |
| :------: | :------: |
|SKSpriteNode |类似于UIImageView,最常用的，通过图片纹理图Texture或者颜色生成一个精灵，可以设置纹理，高光等 |
|SKShapeNode |通过形状创建，可以通过frame，CGPath等，和生成一个UIView及其相似，设置背景色，圆角，边框，阴影等。 |
|SKLabelNode| 通过字体名称创建一个Node，和label差不多，可以设置字体字号颜色，文本，富文本等 |
|SKLightNode |/ |
| SKAudioNode,SKVideoNode| 音视频|
|SKCropNode | /|
|SKEmitterNode | 粒子系统，通过速度，生命周期，角度得到范围，其中基本上的属性都是一个随机范围|


<br>
#### SKAction
> 知道Node类似于UIView之后我们下一步就是想办法让他动起来。那么让他动起来的就是SKAction ，Node和SKAction就像是CALayer和CAAnimation，是给Node提供了各式各样的动画。上面所述的Node，比如游戏里的主角，可以通过run一个action来执行自己的结构或者内容的变化并设置过程的动画，例如位置变化，大小变化，贴图变化等一系列的改变并伴随一个动画。`[node runAction: withKey:]`,这点和CALayer addAnimatio n:forKey:是不是有点像，一个动画也会对应一个action。和CoreAnimation动画类似，CAAction也能设置`duration` `timingMode` `timingFunction` `speed` ，也可以通过`reversedAction`获取一个相反的action。SKAction比较好用的一点就是能够嵌套使用，比如把一个普通的位移action和一个形变action嵌套到一个顺序执行的action里获得一个总的action，在把这个action嵌套到重复执行的action里，就像这样,就实现了一个每隔2秒进行一次变大变小动画。

<br>

```objc
[node runAction:[SKAction repeatActionForever:
                      [SKAction sequence:@[[SKAction scaleTo:1.35 duration:1.5],
                                           [SKAction scaleTo:1 duration:1.5],
                                           [SKAction waitForDuration:2]]]]]
                                           
                                         
```

我们大致看下系统提供的Action种类
![Action](https://upload-images.jianshu.io/upload_images/1396375-886c5afbec202d57.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/826)



### SKPhysicsBody刚体，参与物理世界交互的必要条件

> 那我们刚才说了一个Node只有关联了一个刚体physicsBody才能参与物理世界的交互，其实也很好理解，毕竟一个Node只不过是一张图或者一个形状，而物理世界有质量，摩擦力，速度，动量，密度等等等等。physicsBody是Node的一个属性，默认为nil,如果我们需要让某个node参与到物理世界，比如参与到重力，碰撞等的影响，那么我们需要主动给他赋值一个physicsBody。


| 属性/方法| 说明 |
| :------: | :------: |
|mass | 质量,和物体的密度挂钩，质量=密度*size，改变质量会改变密度 |
|density | 密度，和质量挂钩，设置密度会自动获得质量 |
|velocity |线性速度(1000,1000)，x,y代表两个方向的分速度  |
| linearDamping| 移动速度衰减系数,类似摩擦力，空气阻力之类的 |
|angularVelocity| 自旋速度 |
| Dynamic| 是否是动态刚体，NO不收任何力的影响 |
|BitMask | 各种BitMask，碰撞掩码，标识自身的掩码和自己能接受的碰撞物体的掩码以及碰撞需要通知的掩码 |
|applyForce: | 对刚体施加一个力|
|applyLinearImpulse | 施加一个冲量（百度百科：在经典力学里，物体所受合外力的冲量等于它的动量的增量（即末动量减去初动量）） |
| restitution|  弹性恢复系数，即这个东西碰到别人后弹性好不好，默认0.2|
| affectedByGravity| 是否受重力影响 |
|SKPhysicsJoint | 非常重要的概念，将两个物体链接，可以想象下割绳子游戏 |

### 最后几个比较重要的概念

| 类| 说明 |
| :------: | :------: |
|SKView| 创建的所有内容都是在SKView中进行的，继承UIView，可以add到具体业务里，也可以作为一个VC的根view视图，通过presentScene 来推入一个场景，显示在最上层|
|SKScene |也是一个Node，不过是一个特殊的Node,是一个游戏的场景，例如游戏的欢迎界面，游戏界面，每一关的界面，失败界面，帮助界面等都是一个个的场景，场景只能运行在SKView中 (void)update:(NSTimeInterval)currentTime; 这个方法会每个0.01秒执行，是计算游戏时间最重要的方法，也通过NSTimer来实现时间的计算，但是不使用SK提供的内容不会被管理，也就是暂停恢复等需要自己处理 |
|physicsWorld | SKScene的一个属性，设置每个独立场景的物理世界的一些参数， 每一个SKScene场景中都对应一个物理世界，所有在场景里运行的刚体都收到物理世界的影响，可以设置最重要的物理世界的重力gravity，默认是（0，9.8），碰撞的代理方法也是在其中。|

<br>

### 了解了这些基本概念后，接下来，我们正式开始开发这个泡泡游戏。（游戏GIF以及规则解释在最上面）


> 首先我们新建一个项目,项目类型选择Game,game technology选择
> 我们可以看到系统为我们自动创建的一些文件如图

![创建项目](https://upload-images.jianshu.io/upload_images/3058688-e07ec43b042b866d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

> 系统为我们自动创建的GameViewController，对应的XIB中我们可以看到这个View是一个SKView



删掉系统已有的scene，我们自己建立一个`MainGameScene`来作为我们游戏场景。我们的游戏就在这个scene中进行。
 
我们刚才上面说了，一个scene场景都是运行在skview中的，那么我们在GameViewController中推入我们的scene

```objc

    self.scene = [MainGameScene sceneWithSize:self.view.bounds.size config:config];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    
    SKView *skView = (SKView *)self.view;
    [skView presentScene:self.scene];

```

这样我们就可以开始在我们的`MainGameScene`中开始我们的表演了。


> 首先刚才我们说游戏都是在scene中进行的，那么我们现在GameViewController中推入我们自己的MainGameScene



```objc

@interface GameViewController ()

@property (nonatomic,strong)MainGameScene *scene;
@property (nonatomic)NSInteger currentLevel;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGameWithConfig:MainGameSceneCreatConfig.firstConfig];
}

- (void)setupGameWithConfig:(MainGameSceneCreatConfig *)config {
    
    [self.scene removeFromParent];
    self.scene = nil;
    
    self.scene = [MainGameScene sceneWithSize:self.view.bounds.size config:config];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    
    SKView *skView = (SKView *)self.view;
    [skView presentScene:self.scene];
    
    //debug
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    //简单关卡控制
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

@end

```

> 细节我们可以先忽略，这里主要是在viewDidLoad中setupGameWithConfig初始化一次我们的Main Scene,然后通过SKView presentScene来将我们的scene推到上层显示，然后我们监听了Main Scene中闯关成功和失败的回调，重新通过setupGameWithConfig重新生成新的scene并present。


##### 因此，我们完成了我们的第一步，成功推入我们的游戏界面，下一步我们便开始游戏的开发。

> 首先，我们进入到MainGameScene的开发中，首先我们也需要构建一下我们的游戏场景，根据我们的规则，我们的泡泡或者红球都是不能超出边界范围的，碰撞会反弹，切冰球会受到重力的影响，这一切说明我们的游戏背景将会是一个封闭的，带有重力的矩形，那么我们根据需求在MainGameScene初始化一下我们的scene的物理世界。



```objc
//因为坐标系是从下往上的，和现实世界相反，所以重力是负数
    self.physicsWorld.gravity = CGVectorMake(0, -9.8);
    
    //设置世界的碰撞代理
    self.physicsWorld.contactDelegate = self;
    
    //设置这个世界的边界，任何刚体都无法通过力的作用逃离这个世界的边界
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(kPhysicsWorldInsert.left, kPhysicsWorldInsert.top, self.size.width-kPhysicsWorldInsert.left-kPhysicsWorldInsert.right, self.size.height-kPhysicsWorldInsert.top-kPhysicsWorldInsert.bottom)];
    
    
```
> 可以看到，一个Scene中都对应着一个physicsWorld，我们设置了physicsWorld的重力，以及碰撞代理和物理世界的边界，这里我们选择是矩形边界。

##### 现在，世界有了，是不是差点背景音乐？

> 在上面我们也说到了声音的3种播放方式，那么一般像背景音乐这种需要较多控制和持续播放的我们选择add 声音node的方式，一般像一次的音效我们使用run一个action的方法，集体我们可以在MianSoundManager这个类中查看，这里列举一下这两种的播放


```objc

//我们在MainGameScene刚才初始化的地方增加声音的初始化

//初始化声音，例子系统
    self.soundManager = [[MianSoundManager alloc] initWithScene:self];
    [self.soundManager controlBgMusicWithPlay:YES];


//以下是MianSoundManager的方法
- (void)controlBgMusicWithPlay:(BOOL)play {

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

//播放进入游戏 ready go的音效
- (void)playReadyGoSound {
    [self.relateScene runAction:[SKAction playSoundFileNamed:@"game_readyGo.wav" waitForCompletion:NO]];
}

```
> 上面列举了播放背景声音和音效的两种不同方法。其中self.relateScene使我们调用方也就是MainGameScene传进去的，也就是方法1播放背景声音其实是通过向MainGameScene中add了一个声音node，方法2种则是通过MainGameScene run了有个Sound action。


##### 至此，物理世界和音效我们都已经完成了，那么我们在增加一个背景图以及开始游戏的按钮

```objc


    SKSpriteNode *bgImageNode = [[SKSpriteNode alloc] initWithImageNamed:@"background"];
    bgImageNode.size = self.size;
    //position是物体的中间点
    bgImageNode.position = CGPointMake(self.size.width/2.f, self.size.height/2.f);
    //addChild，和addSubView类似
    [self addChild:bgImageNode];
    
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

```

> 至于背景图我们没有特别的，只是add了一个图片node而已，而游戏button我们则需要自己稍加处理一下，因为游戏中没有现成的按钮可以提供给我们使用，但是一个node是继承自UIResponder,因为我们可以继承一个图片node，然后重新touch相关的UIResponder方法，来模拟一个按钮，具体可以看GameButton中，这里我只是在touchesBegan 方法里直接回调，如果想要更好的交互，可以参考UIButton的api,增加各种手势以及状态的回调。


##### 细心的你一定会发现背景在下雪，已经开始按钮在冒火，这其实是框架给我们提供了非常好用的粒子系统，新建一个例子系统，我们可以非常方便的通过可视化界面随意调节我们的粒子效果

> 我们file - new - file,拉到比较下面的位置 选择sprite particle file,选择例如下雨下雪烟雾等的其中一个，新建一个粒子文件。选择刚才的粒子文件，我们可以看到xcode给我们提供了比较丰富的可视化操作，当然这些都有对应的属性通过代码设置，在粒子系统里，我们通过position range，lifetime speed range等的作用设置密度和范围的发小。

![](https://upload-images.jianshu.io/upload_images/3058688-fcda9c522344ae53.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/700)

```objc

//我们通过在我们的按钮node上add一个粒子node
+ (void)addFireForNode:(SKNode *)node {
    
    SKEmitterNode *fire = [SKEmitterNode nodeWithFileNamed:@"Fire.sks"];
    fire.position =  CGPointMake(0, 16);
    
    [node addChild:fire];
}


```

##### 以上都是一些游戏的附属相关的开始，那么现在我们的主角应该登场，也就是我们的红球redball和泡泡bubble，那么我们抽象一下主角的模型，并且在初始化的赋值一些物理属性，首先我们看红球。

```objc
#import <SpriteKit/SpriteKit.h>
#import "CommUtil.h"
#import "GameConfigs.h"

typedef NS_ENUM(NSUInteger, RedBallEffectType) {
    RedBallEffectTypeNone,
    RedBallEffectTypeIceing,
};

@interface RedBall : SKSpriteNode

@property (nonatomic,readwrite)RedBallEffectType effectType;

//random
+ (instancetype)redBall;

@end


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
    redBall.physicsBody.restitution = 1.f;//反弹的动量 1即无限反弹，不丢失动量，相当于一个永动机=。=
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
    
    //也可以通过action动画b换图
    self.texture  = [SKTexture textureWithImageNamed:effectType==RedBallEffectTypeIceing?@"ball_ice":@"ball"];
    
    //碰撞后拿出原有的角速度的方向 赋值到新速度，方向不变 d速度减半或者恢复
    //当然也可以角速度直接操作 angularVelocity
    CGVector originalVelocity = self.physicsBody.velocity ;
    CGFloat dxv = originalVelocity.dx>=0?1:-1;
    CGFloat dyv = originalVelocity.dy>=0?1:-1;
    CGFloat v = effectType==RedBallEffectTypeIceing?GameConfigs.redBallSpeedIce:GameConfigs.redBallSpeedNormal;
    self.physicsBody.velocity = CGVectorMake(v*dxv, v*dyv);
}

@end


```
> 以上我们定义了红球的类型，普通已经减速效果，我们先看红球的初始化，红球其实也是一个图片node，和我们的背景图或者按钮没有什么差别而physicsBody才是红球加入到物理世界的最重要的条件，按照上面我们说的，我们给红球赋值一个.physicsBody，设置质量等，然后我们设置physicsBody.restitution = 1.f，也就是没有衰减的弹性，这样红球碰到泡泡或者朋友我们游戏边界的时候就能原速度返回了，这里红球的质量是10。  在下面setEffectType的方法中，我们判定红球是否受到了减速，如果是我们则取出他的速度，减少一半。但是方向不变（这个是碰撞后调用的，所以方向什么的碰撞引擎已经给我们做好了，我们只需要将速度减半）


##### 再来看下bubble

```objc

+ (instancetype)bubbleWithType:(BubbleType)bubbleType {
   Bubble *bubble =  bubbleType==BubbleTypeNormal?[self spriteNodeWithImageNamed:@"bubble"]:[self spriteNodeWithImageNamed:@"bubble_ice"];
    
    bubble.bubbleType = bubbleType;
    bubble.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:bubble.size.width/2.f];
    [bubble setScale:0.f];
    bubble.physicsBody.affectedByGravity = NO;
    bubble.physicsBody.mass = 500;//质量是红球的50倍
    bubble.physicsBody.restitution = 0.2;//动量传递衰减80%（即看着弹性很小,设置为1碰撞后可以一直弹）
    bubble.physicsBody.angularDamping = 0.4;
    bubble.physicsBody.linearDamping = 0.3f;
    
    return bubble;
}


- (void)fadeOut {
    [self runAction:[SKAction sequence:@[
                                         [SKAction fadeOutWithDuration:0.5],
                                         [SKAction removeFromParent],
                                         ]]];
}

- (void)beganGrowthingWithTargetScale:(CGFloat)scale duration:(NSTimeInterval)duration{
    [self stopGrowthing];
    _growthing = YES;
    [self runAction:[SKAction scaleTo:scale duration:duration] withKey:kGrowthingAnimationName];
}

- (void)stopGrowthing {
    _growthing = NO;
    [self removeActionForKey:kGrowthingAnimationName];
}

```
> 我们先忽略其他无关的代码，首先创建bubble，我们可以看到bubble的质量为500，而红球我们刚才设置的是10，所以bubble被红球碰撞后会有微量的偏移（其实都设置密度会比较好，这样红球撞到不同大小的bubble会出现不同的位移变化更加逼真，这里我们为了方便），在来看下`beganGrowthingWithTargetScale`方法，这个方法其实是在mianScene中点击创建bubble调用的，也就是bubble的增大我们是通过给bubble run一个scale的action来达到，这样也达到了很多我们想要的效果，1是变大，而是有个5秒的过程，3是因为scale是指定的，所以当达到最大的时候手指还按着就不会在变大了，省去了我们人工判断的过程。再看下`fadeOut `方法，其实就是bubble在生成过程被红球碰到后的消失过程，可以看到我们通过嵌套了几个action，线性执行。


##### bubble和redball我们都已经完成，那么就是在开始游戏后生成红球开始运动，按钮在点击屏幕的时候创建红球。并且开始倒计时。细节demo里都有，我们只讲几个重要的方法。

##### 1是红球的运动，我们上面也说了很多种使刚体动起来的方法，其中我们可以通过直接赋值速度的方法最快达到

```objc

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


```

##### 第二是碰撞的检测

> 在上面初始化scene物理世界的时候，有一段`self.physicsWorld.contactDelegate = self;`其实就是设置了物理设置的碰撞代理为scene，那我们就可以在碰撞代理回调里拿到红球和bubble的碰撞了，另外一点，碰撞必须设置collisionBitMask和contactTestBitMask，也就是谁，以及碰撞了谁需要通知，这里设置为对方的掩码就行。

```objc

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

```

> 以上就是我们可以分别在碰撞前和碰撞后的代码里实现我们的需求，碰撞后的话速度的方向之类的已经受到了改变。


##### 再就是倒计时的实现，之前我们也说可以通过NSTimer实现，但是NSTimer不会受到SK的管理。也就是暂停等需要我们自己的维护，非常不方便，而我们其实可以通过重写scene的update:方法来实现毫秒级的时间监测，来实现倒计时之类的实现。

```objc

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


```

##### 以上是对我们这个泡泡游戏的一些实现过程的解释，其中的细节在demo里也有非常详细的注释，其实我们只是用到了SK里面非常少的功能，起还有其他强大之处可以给我们使用，也期待会有更多的场景能在我们APP中用到SK这个强大的框架。


<br>

[↑↑↑↑回到顶部↑↑↑↑](#readme)

[↑↑↑↑回到顶部↑↑↑↑](#readme)

[↑↑↑↑回到顶部↑↑↑↑](#readme)











