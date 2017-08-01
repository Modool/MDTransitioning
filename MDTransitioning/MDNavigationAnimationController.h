//
//  MDNavigationAnimationController.h
//  MDTransitioning
//
//  Created by Jave on 2017/7/25.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDAnimatedTransitioning.h"

// The default navigation animation controller base on MDNavigationAnimatedTransitioning
@interface MDNavigationAnimationController : NSObject<MDNavigationAnimatedTransitioning>

// The duration of animation, default is 0.25f.
@property (nonatomic, assign) CGFloat duration;

/**
 The designated initializer. If you subclass MDNavigationAnimationController, you must call the super implementation of this
 method.
 
 @param operation   navigation controller operation, push or pop.
 @param fromViewController  view controller appearing.
 @param toViewController    view controller will be appearing.
 @return    an instance of MDNavigationAnimationController or sub class.
 */
- (instancetype)initWithOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;

- (instancetype)init DEPRECATED_MSG_ATTRIBUTE(" Use initWithOperation:fromViewController:toViewController: instead");

@end
