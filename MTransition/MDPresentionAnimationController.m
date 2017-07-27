//
//  MDPresentionAnimationController.m
//  MDTransitioning
//
//  Created by Jave on 2017/7/26.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDPresentionAnimationController.h"
#import "UIViewController+MPresentionAnimatedTransitioning.h"

@interface MDPresentionAnimationController ()

@property (nonatomic, assign) MDPresentionAnimatedOperation operation;
@property (nonatomic, weak) UIViewController *fromViewController;
@property (nonatomic, weak) UIViewController *toViewController;

@end

@implementation MDPresentionAnimationController

- (instancetype)init {
    return nil;
}

- (instancetype)initWithOperation:(MDPresentionAnimatedOperation)operation
               fromViewController:(UIViewController *)fromViewController
                 toViewController:(UIViewController *)toViewController {
    self = [super init];
    if (self) {
        NSParameterAssert(operation != MDPresentionAnimatedOperationNone);
        
        self.duration = 0.25;
        self.operation = operation;
        self.fromViewController = fromViewController;
        self.toViewController = toViewController;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return [self duration];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if ([self operation] == MDPresentionAnimatedOperationPresent) {
        [self animatePresentTransition:transitionContext];
    } else {
        [self animateDismissTransition:transitionContext];
    }
}

- (void)animatePresentTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    CGRect frame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.frame = CGRectOffset(frame, 0, CGRectGetHeight(frame));
    [[transitionContext containerView] addSubview:[toViewController view]];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toViewController.view.frame = CGRectOffset(toViewController.view.frame, 0, -CGRectGetHeight(frame));
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}

- (void)animateDismissTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    CGRect frame = [transitionContext finalFrameForViewController:toViewController];
    fromViewController.view.frame = frame;
    
    [[transitionContext containerView] addSubview:[toViewController view]];
    [[transitionContext containerView] sendSubviewToBack:[toViewController view]];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         fromViewController.view.frame = CGRectOffset(frame, 0, CGRectGetHeight(frame));
                     }
                     completion:^(BOOL finished) {
                         fromViewController.view.frame = frame;
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

@end
