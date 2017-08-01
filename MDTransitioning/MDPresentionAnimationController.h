//
//  MDPresentionAnimationController.h
//  MDTransitioning
//
//  Created by Jave on 2017/7/26.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDAnimatedTransitioning.h"

// The default presention animation controller base on MPresentionAnimatedTransitioning
@interface MDPresentionAnimationController : NSObject<MPresentionAnimatedTransitioning>

// The duration of animation, default is 0.25f.
@property (nonatomic, assign) CGFloat duration; // Default is 0.25f.

/**
 The designated initializer. If you subclass MDNavigationAnimationController, you must call the super implementation of this
 method.
 
 @param operation   presention controller operation, present or dismiss.
 @param fromViewController  view controller appearing.
 @param toViewController    view controller will be appearing.
 @return    an instance of MDPresentionAnimationController or sub class.
 */
- (instancetype)initWithOperation:(MDPresentionAnimatedOperation)operation fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;

- (instancetype)init DEPRECATED_MSG_ATTRIBUTE(" Use initWithOperation:fromViewController:toViewController: instead");

@end
