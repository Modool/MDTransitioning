//
//  MDCustomNavigationAnimationController.m
//  Demo
//
//  Created by Jave on 2017/8/1.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDCustomNavigationAnimationController.h"

@implementation MDCustomNavigationAnimationController

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if ([self operation] == UINavigationControllerOperationPush) {
        [super animateTransition:transitionContext];
    } else {
        [self customAnimatePopTransition:transitionContext];
    }
}

- (void)customAnimatePopTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [fromViewController.view addSubview:fromViewController.snapshot];
    fromViewController.navigationController.navigationBar.hidden = YES;
    
    toViewController.view.hidden = YES;
    toViewController.snapshot.alpha = 0.5;
    toViewController.snapshot.transform = CGAffineTransformMakeScale(0.95, 0.95);
    UIApplication.sharedApplication.delegate.window.backgroundColor = [UIColor whiteColor];
    
    [[transitionContext containerView] addSubview:toViewController.view];
    [[transitionContext containerView] addSubview:toViewController.snapshot];
    [[transitionContext containerView] sendSubviewToBack:toViewController.snapshot];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         fromViewController.view.frame = CGRectOffset(fromViewController.view.frame, CGRectGetWidth(fromViewController.view.frame), 0);
                         toViewController.snapshot.alpha = 1.0;
                         toViewController.snapshot.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         UIApplication.sharedApplication.delegate.window.backgroundColor = [UIColor whiteColor];
                         
                         toViewController.navigationController.navigationBar.hidden = NO;
                         toViewController.view.hidden = NO;
                         
                         [fromViewController.snapshot removeFromSuperview];
                         [toViewController.snapshot removeFromSuperview];
                         
                         // Reset toViewController's `snapshot` to nil
                         if (![transitionContext transitionWasCancelled]) {
                             toViewController.snapshot = nil;
                         }
                         
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];

}

@end
