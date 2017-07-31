# MDTransitioning

[![](https://img.shields.io/travis/rust-lang/rust.svg?style=flat)](https://github.com/Modool)
[![](https://img.shields.io/badge/language-Object--C-1eafeb.svg?style=flat)](https://developer.apple.com/Objective-C)
[![](https://img.shields.io/badge/license-MIT-353535.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![](https://img.shields.io/badge/platform-iOS-lightgrey.svg?style=flat)](https://github.com/Modool)
[![](https://img.shields.io/badge/QQ群-662988771-red.svg)](http://wpa.qq.com/msgrd?v=3&uin=662988771&site=qq&menu=yes)

## Introduction

- 基于转场的动画，自定义手势控制拓展

- 快速集成全局手势侧滑返回，局部转场动画

## How To Get Started

* Download `MDTransitioning` and try run example app

## Communication

* QQ群：<img src="./images/qq.png" width=200>
* 微信群：<img src="./images/weichat.jpeg" width=200>
* Github：<img src="./images/github.png" width=200>

## Installation


* Installation with CocoaPods

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'MDTransitioning', '~> 3.0'
end

```

* Installation with Carthage

```
github "MDTransitioning/MDTransitioning" ~> 1.0
```

* Manual Import

```
drag “MDTransitioning” directory into your project

```


## Requirements
- Requires ARC

## Architecture

### AnimatedTransitioning

* `<UIViewControllerAnimatedTransitioning>`
	* `<MDViewControllerAnimatedTransitioning>`
		* `<MDNavigationAnimatedTransitioning>`
		* `<MPresentionAnimatedTransitioning>`



	* MDNavigationAnimationController
	* MDPresentionAnimationController

### InteractiveTransition

* `<MDInteractionControllerDelegate>`
	* MDSwipeInteractionController
	* MDPopInteractionController

### Transitioning

* UIViewController+MDNavigationTransitioning.h
* UIViewController+MDPresentionTransitioning.h

### ImageViewController
	
* AnimatedTransitioning
	* MDImageZoomAnimationController
* InteractiveTransition
	* MDImageDismissInteractionController
	* MDImageDraggingDismissInteractionController
* MDImageViewController
	

## Usage

* 暂无

## Update History

* 暂无



## License
`MDTransitioning` is released under the MIT license. See LICENSE for details.
