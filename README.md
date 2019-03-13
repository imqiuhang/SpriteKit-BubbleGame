<!--可以在 https://macdown.uranusjr.com/  下载Markdown支持工具Macdown-->
### iOS 2D游戏框架-SpriteKit的一些实践过程
###### @author imqiuhang

### 📣前言
>如果你是iOS开发者，刚好对2D游戏感兴趣，或者想在你的APP中增加一些有趣的场景互动，那么SpriteKit会是一个很好的选择，优秀的物理引擎，熟悉的OC/swift语言配方，和UIKit的无缝对接，使得学习成本非常的低，假如你刚好也了解Cocos2D相关，那么学习成本几乎为0。不过即使之前没有任何物理引擎和2D游戏的了解也没关系，因为我们的Apple爸爸已经把生涩难懂的部分封装成了非常简单的API供我们调用即可。

<br>

📣说明

###### 1. 📎[本文Demo](https://github.com/imqiuhang/BubbleGame)  由于时间问题，目前尺寸没有适配，使用12.9的iPad pro模拟器或者真机进行游戏，模拟器启动后可以在hardware -> rotate left进行旋转方便查看


###### 2. ❓由于才疏学浅，错误在所难免，有错误的地方以及补充欢迎在[issues](https://github.com/imqiuhang/BubbleGame/issues)中提出，第一时间更正，谢谢！

###### 3. 本游戏的是本人之前在大二的时候基于XNA制作的Windows游戏的改写的，素菜都直接用的之前的素菜，所以所有的P图，音效等都显得比较[幼稚]^_^，还请谅解。

##### BubbleGame的游戏大致截图

![bubbleGame.gif](https://upload-images.jianshu.io/upload_images/3058688-38bc8b8b544c552f.gif?imageMogr2/auto-orient/strip)

<br>
<br>
> 🚪好了，让我们一起进入到SpriteKit的物理世界中吧。



