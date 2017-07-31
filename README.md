# MDTransitioning

[![](https://img.shields.io/travis/rust-lang/rust.svg?style=flat)](https://github.com/Modool)
[![](https://img.shields.io/badge/language-Object--C-1eafeb.svg?style=flat)](https://developer.apple.com/Objective-C)
[![](https://img.shields.io/badge/license-MIT-353535.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![](https://img.shields.io/badge/platform-iOS-lightgrey.svg?style=flat)](https://github.com/Modool)
[![](https://img.shields.io/badge/QQ群-662988771-red.svg)](http://wpa.qq.com/msgrd?v=3&uin=662988771&site=qq&menu=yes)

## Introduction

- Animation based with transtion,easy to custom gesture control by developer.
- Quick Integrate global gesture,sideslip or local animation

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

### InteractiveController

* `<MDNavigationPopController>`
* `<MDPresentionController>`
* `<MDInteractionController>`
* MDSwipeInteractionController
* MDPopInteractionController
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

* 2017.7.30 Add README and adjust project class name.



## License
`MDTransitioning` is released under the MIT license. See LICENSE for details.
