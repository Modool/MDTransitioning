//
//  UIViewController+MDPresentionTransitioning.m
//  MDTransitioning
//
//  Created by Jave on 2017/7/26.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <objc/runtime.h>
#import "UIViewController+MDPresentionTransitioning.h"
#import "MDPresentionAnimationController.h"

@implementation UIViewController (MDPresentionTransitioning)

- (void)setPresentionInteractionController:(id<MDInteractionController>)presentionInteractionController{
    objc_setAssociatedObject(self, @selector(presentionInteractionController), presentionInteractionController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<MDInteractionController>)presentionInteractionController{
    return objc_getAssociatedObject(self, @selector(presentionInteractionController));
}

- (id<MPresentionAnimatedTransitioning>)animationForPresentionOperation:(MDPresentionAnimatedOperation)operation fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;{
    return [[MDPresentionAnimationController alloc] initWithOperation:operation fromViewController:fromViewController toViewController:toViewController];
}

@end
