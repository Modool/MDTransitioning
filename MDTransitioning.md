<img src="https://github.com/Modool/Resources/blob/master/images/project/transitioning.jpg?raw=true" width=100%>

## <a href='https://github.com/Modool/MDTransitioning.git'>MDTransitioning</a>
@copyright <a href='https://github.com/Modool'>Modool</a>

### 前言

转场动画就是以某种方式从一个场景以动画的形式过渡到另一个场景。

然而，动画的可变性太强，每个设计师都有自己的想法，对于开发来说，是无法用固定的模式来限制动画的实现。   
其次，系统已经为我们提供了一套很好的动画模板，我们只需要实现其相关方法，就能够很容易的实现各种各样的动画。

所以，本文将要介绍的并不是转场所需要的动画，而是针对"转场过程控制"的一种设计方案，以便提供一种具有可定制，可扩展的设计方案。

为了方便集成，我们也提供了很多套可选的动画方案，比如传统的侧滑、缩放、图片预览等等。

###iOS7 以前

在 iOS7 以前，系统不支持手势右划返回的，只能实现一些过度动画，如以下方案：

```
// Code here
// Custom present
[toViewController willMoveToParentViewController:self];
[fromViewController willMoveToParentViewController:nil];

[self addChildViewController:toViewController];
[[self view] addSubview:[toViewController view]];

[self transitionFromViewController:fromViewController
                  toViewController:toViewController
                   		  duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                        	 // 过度效果
                        }
                        completion:^(BOOL finished) {
    [fromViewController removeFromSuperView];
    [fromViewController removeFromParentViewController];
    [fromViewController didMoveToParentViewController:nil];
    [toViewController didMoveToParentViewController:self];
}];
```
或者

```
// Code here
[navigationController pushViewController:toViewController animated:NO];
[UIView animateWithDuration:0.3
                    options:UIViewAnimationOptionTransitionCrossDissolve
                 animations:^{
                        	 // 过度效果
                        }
                        completion:nil];
```
iOS7以前，没有为`Controller` 提供 `transitioningDelegate`

```
// Code here
@interface UIViewController(UIViewControllerTransitioning)

@property (nullable, nonatomic, weak) id <UIViewControllerTransitioningDelegate> transitioningDelegate;

@end

```
所以对于`Present`、`Dismiss`来说，尚且还是可以实现，而对于`Push` 和 `Pop`的定制非常困难，就更不要说针对转场来进行交互控制。

###iOS7 以后

在 iOS7 以后，系统针对交互转场这方面出现了很大变化，不仅支持了手势交互，还提供了一套标准的转场协议和动画协议。

####默认交互方案

首先，我们来看下 `Push` 和 `Pop`，在我们不去实现任何交互，以及任何动画的时候，系统所提供给我们的交互方案：

```
// Code here
@interface UINavigationController : UIViewController

// 系统默认提供的侧滑手势（从屏幕边界往右划）
@property(nullable, nonatomic, readonly) UIGestureRecognizer *interactivePopGestureRecognizer

@end

```
我们看到，系统默认的手势是基于`UINavigationController`的，也就是说，手势是加在 `UINavigationController` 的 transitionView 上的，而且是只读的，我们无法篡改手势，以及无法定制手势，当然，这其中其他的问题，我们待会再说。

我们继续再看下系统默认的`Push`和`Pop`转场定制方案：

#####默认转场方案 

* `UIViewControllerInteractiveTransitioning`    
	转场协议：虽然说是控制转场交互的，但是并没有达到字面意思上所具备动能。   
	
	* `UIPercentDrivenInteractiveTransition`   
	转场进度控制器：系统默认提供的，通过百分比来控制转场的播放进度。
	
```
// Code here
// UINavigationControllerDelegate 
// 如果需要定制转场控制方案，需提供UIViewControllerInteractiveTransitioning实例，
// 默认情况下不需要实现此代理，

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(MDNavigationAnimationController *)animationController {
    return [UIPercentDrivenInteractiveTransition new];
}

```
###默认动画方案

* `UIViewControllerAnimatedTransitioning`    
	动画协议：当`Push`或者`Pop`动作发生后，会通过代理获取到该协议的具体动画实例。

```
// Code here
// UINavigationControllerDelegate 
// 如果需要定制动画方案，需提供UIViewControllerAnimatedTransitioning实例，
// 默认情况下不需要实现此代理，

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromViewController
                                                 toViewController:(UIViewController *)toViewController {
    if (operation == UINavigationControllerOperationPush) return push animation;
    if (operation == UINavigationControllerOperationPop) return pop animation;
	return nil;
}
```

我再来看下`Present`、`Dismiss`，和`Push`、`Pop`类似

```
// Code here
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(MDImageViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return present transitioning;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(MDImageViewController *)dismissed {
    return dismiss transitioning;
}
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <MDViewControllerAnimatedTransitioning>)animator;{
    return present interactive transitioning;
}
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<MDViewControllerAnimatedTransitioning>)animator;{
    return dismiss interactive transitioning;
}

```
无论是`Present`、`Dismiss`、`Push`、`Pop`中的哪一种，都要遵从下面这个流程
<img src="https://github.com/Modool/Resources/blob/master/images/flow/transationing.png?raw=true" width=1400>

由于基于系统的默认方案，我们会有以下三个问题：   

* 可以针对每个Controller定制动画，但是由于`UINavigationController`，`interactivePopGestureRecognizer`以及`transitioningDelegate`的局限性，在维护上相对离散，没有一个统一的方案;       
* 不可以针对每个Controller定制交互  
* 不可以针对每个Controller转场控制的
* 对第三方动画和交互控制器的集成相对复杂

###所有我们准备提供一套完整的可扩展方案来解决这几个问题

### Why `MDTransitioning`?

基于上面的流程图来看，倘若我们需要针对每个转场进行定制，工作相对繁琐，维护困难。     
所以`MDTransitioning`方案基于以下几个原则：

*  交互：从谁那里来，就由谁提供
*  动画：到哪里去，就由谁提供
*  控制：谁触发，就由谁维护

###类关系

###动画类


* MDViewControllerAnimatedTransitioning

	基于`UIViewControllerAnimatedTransitioning`协议的再次封装，对关联的主从`View Controller`进行定义
	
* `MDNavigationAnimatedTransitioning`       
	基于`MDViewControllerAnimatedTransitioning`协议的再次封装，定义`Push`和`Pop`的两种动画方式

* `MDNavigationAnimationController`           
	基于`MDNavigationAnimatedTransitioning`协议的默认实现，默认实现`Push`和`Pop`动画，呈现方式和系统保持一致
	
* `MPresentionAnimatedTransitioning`        
	基于`MDViewControllerAnimatedTransitioning`协议的再次封装，定义`Present`和`Dismiss`的两种动画方式

* `MDPresentionAnimationController`      
	基于`MPresentionAnimatedTransitioning `协议的默认实现，默认实现`Present `和`Dismiss `动画，呈现方式和系统保持一致
			
###交互驱动类

* `MDPercentDrivenInteractiveTransitioning`        
	基于系统UIViewControllerInteractiveTransitioning协议的再次封装，定义驱动所需的常规方法			

* `UIPercentDrivenInteractiveTransition`       
	系统提供的默认百分比驱动器，以便后期对驱动的扩展

###交互控制类

* `MDInteractionController` 			
	交互控制协议，负责控制交互的生命周期，手势变化，以及转场触发和进度维护		
						
* `MDSwipeInteractionController`    
	基于`MDInteractionController`协议的实现，实现对滑动手势交互的控制			         		
		
* `MDPopInteractionController`       
	基于`MDSwipeInteractionController`，提供`Pop`动作的滑动条件，以及进度计算
		
* `<MDNavigationPopController>`  
	`Pop`动作控制器，默认由`UIViewController`实现，负责控制交互的加载条件、初始化、以及手势依赖的`UIView`
	      
* `<MDPresentionController>`        
	`Present`、`Dismiss`动作控制器，默认由`UIViewController`实现，负责控制Presention交互的加载条件、初始化、以及手势依赖的`UIView`

###优点

* 提供一套默认的方案，和系统效果保持一致
* 提供所有定制方案的底层类，轻轻松松就能完成自定义交互和动画的集成
* 方便集成第三方动画和交互控制器，例如<a href='https://github.com/ColinEberhardt/VCTransitionsLibrary'>CE系列</a>
* 重点在这里，默认方案，**零写入**，**零入侵**
	
###到底有多简单？

****

### 案例一

* `MDNavigationControllerDelegate `        
为了方便接入，我们提供了默认的`Pop`和`Push`代理实现，只需要下面一行代码，就可以实现对系统转场的替换。

```
// Code here
navigationController.delegate = [MDNavigationControllerDelegate defaultDelegate];
    
```
效果和系统的保持一致           

<img src="https://github.com/Modool/MDTransitioning/blob/master/snapshots/system_push.gif?raw=true" width=320> 


<img src="https://github.com/Modool/MDTransitioning/blob/master/snapshots/custom_push.gif?raw=true" width=320>

### 案例二

* `MDPresentionControllerDelegate `        
当然对于`Present`和`Dismiss`我们也提供了默认的代理实现，同样只需要下面一行代码对系统转场的替换。

```
// Code here
viewController.transitioningDelegate = [MDPresentionControllerDelegate delegateWithReferenceViewController:referenceViewController];
    
```
效果和系统的保持一致           

<img src="https://github.com/Modool/MDTransitioning/blob/master/snapshots/system_present.gif?raw=true" width=320> 
<img src="https://github.com/Modool/MDTransitioning/blob/master/snapshots/custom_present.gif?raw=true" width=320>

### 为某个`View Contorller`定制一个缩放的`Pop`动画，但`Push`动画用默认的

```
// Code here
// 在将要显示的`View Contorller`内实现该方法，默认实现返回父类结果
- (id<MDNavigationAnimatedTransitioning>)animationForNavigationOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;{
	if (operation == UINavigationControllerOperationPush) {
        return [super animationForNavigationOperation:operation fromViewController:fromViewController toViewController:toViewController];
    } else {
        return [[MDScaleNavigationAnimationController alloc] initWithOperation:operation fromViewController:fromViewController toViewController:toViewController];
    }
}

```

### 案例三
### 因为水平pop是默认实现的，所以我们调整一下，为某个`View Contorller`定制一个垂直滑动的`Pop`手势交互，虽然有点变态，但是这仅为测试

```
// Code here
// 在将要显示的`View Contorller`中复写该方法，提供垂直滑动的交互控制器
- (id<MDInteractionController>)requirePopInteractionController{
    return [MDVerticalSwipPopInteractionController interactionControllerWithViewController:self];
}

```
效果如图：	   
  
<img src="https://github.com/Modool/MDTransitioning/blob/master/snapshots/scale_push.gif?raw=true" width=320>

### 案例四

#### 为某个`View Contorller`定制一个图片放大的`Present`动画，但`Dismiss`动画用默认抽屉式的

```
// Code here
// 在将要显示的`View Contorller`内实现该方法，默认实现返回父类结果
- (id<MPresentionAnimatedTransitioning>)animationForPresentionOperation:(MDPresentionAnimatedOperation)operation fromViewController:(UIViewController<MDImageZoomViewControllerDelegate> *)fromViewController toViewController:(UIViewController<MDImageZoomViewControllerDelegate> *)toViewController;{
    if (operation == MDPresentionAnimatedOperationPresent) {
        MDImageZoomAnimationController *controller = [MDImageZoomAnimationController animationForPresentOperation:operation fromViewController:fromViewController toViewController:toViewController];
        controller.hideReferenceImageViewWhenZoomIn = NO;
        return controller;
    } else {
        return [[MDPresentionAnimationController alloc] initWithOperation:operation fromViewController:fromViewController toViewController:toViewController];
    }
}

```
### 案例五

### 图片预览器，为某个`View Contorller`定制一个图片缩小的`Dismiss`手势交互

```
// Code here
// 在将要显示的`View Contorller`的`viewDidLoad`方法中添加交互控制器
- (void)viewDidLoad {
    [super viewDidLoad];
    
    MDImageDraggingDismissInteractionController *interactionController = [MDImageDraggingDismissInteractionController interactionControllerWithViewController:self];
    interactionController.translation = 200.f;
    
    self.presentionInteractionController = interactionController;
}

```

效果如图：   

<img src="https://github.com/Modool/MDTransitioning/blob/master/snapshots/image_present.gif?raw=true" width=320>

### 现成的动画和交互太少怎么办？

配合<a href='https://github.com/ColinEberhardt/VCTransitionsLibrary'>CE系列</a>的动画和交互一起使用，我们提供CE的扩展方案<a href='https://github.com/Modool/MDTransitioning-VCTransitionsLibrary'>MDTransitioning-VCTransitionsLibrary</a>.


## 联系方式

<img src="https://github.com/Modool/Resources/blob/master/images/social/qq_300.png?raw=true" width=200><img style="margin:0px 50px 0px 50px" src="https://github.com/Modool/Resources/blob/master/images/social/wechat_300.png?raw=true" width=200><img src="https://github.com/Modool/Resources/blob/master/images/social/github_300.png?raw=true" width=200>