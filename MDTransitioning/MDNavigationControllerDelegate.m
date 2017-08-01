//
//  MDNavigationControllerDelegate.m
//  MDTransitioning
//
//  Created by Jave on 2017/7/26.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <objc/runtime.h>

#import "MDNavigationControllerDelegate.h"
#import "MDNavigationAnimationController.h"
#import "MDInteractionController.h"
#import "UIViewController+MDNavigationTransitioning.h"
#import "MDTransitioning+Private.h"

@implementation UINavigationController (MDNavigationAnimationController)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MDTransitioningMethodSwizzle([self class], @selector(pushViewController:animated:), @selector(swizzle_pushViewController:animated:));
    });
}

- (void)swizzle_pushViewController:(UIViewController*)viewController animated:(BOOL)animated{
    self.view.userInteractionEnabled = NO;
    
    if ([self topViewController] && ![[self topViewController] snapshot]) {
        self.topViewController.snapshot = [[self view] snapshotViewAfterScreenUpdates:NO];
    }
    
    [self swizzle_pushViewController:viewController animated:animated];
}

@end

@implementation MDNavigationControllerDelegate

+ (instancetype)defaultDelegate;{
    static MDNavigationControllerDelegate *delegate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        delegate = [MDNavigationControllerDelegate new];
    });
    return delegate;
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animate{
    navigationController.view.userInteractionEnabled = YES;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(MDNavigationAnimationController *)animationController {
    return [[[animationController fromViewController] interactionController] interactiveTransition];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromViewController
                                                 toViewController:(UIViewController *)toViewController {
    return [fromViewController animationForNavigationOperation:operation fromViewController:fromViewController toViewController:toViewController];
}

@end