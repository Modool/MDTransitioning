//
//  UINavigationControllerDelegate.m
//  MDTransitioning
//
//  Created by Jave on 2017/7/26.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <objc/runtime.h>

#import "UINavigationControllerDelegate.h"
#import "MDNavigationAnimationController.h"
#import "MDInteractionControllerDelegate.h"
#import "UIViewController+MDNavigationAnimatedTransitioning.h"

@implementation UINavigationController (MDNavigationAnimationController)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL origSel = @selector(pushViewController:animated:);
        SEL altSel = @selector(swizzle_pushViewController:animated:);
        Method origMethod = class_getInstanceMethod(class, origSel);
        Method altMethod = class_getInstanceMethod(class, altSel);
        IMP origIMP = class_getMethodImplementation(class, origSel);
        if (origIMP != NULL) {
            method_exchangeImplementations(origMethod, altMethod);
        }
    });
}

- (void)swizzle_pushViewController:(UIViewController*)viewController animated:(BOOL)animated{
    self.view.userInteractionEnabled = NO;
    
    if ([[self childViewControllers] count]) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    if ([self topViewController] && ![[self topViewController] snapshot]) {
        self.topViewController.snapshot = [[self view] snapshotViewAfterScreenUpdates:NO];
    }
    
    [self swizzle_pushViewController:viewController animated:animated];
}

@end

@implementation UINavigationControllerDelegate

+ (instancetype)defaultDelegate;{
    static UINavigationControllerDelegate *delegate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        delegate = [UINavigationControllerDelegate new];
    });
    return delegate;
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animate{
    navigationController.view.userInteractionEnabled = YES;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(MDNavigationAnimationController *)animationController {
    return [[[animationController fromViewController] interactiveController] interactiveTransition];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromViewController
                                                 toViewController:(UIViewController *)toViewController {
    return [fromViewController animationForNavigationOperation:operation fromViewController:fromViewController toViewController:toViewController];
}
@end
