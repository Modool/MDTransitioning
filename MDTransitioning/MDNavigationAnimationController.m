//
//  MDNavigationAnimationController.m
//  MDTransitioning
//
//  Created by Jave on 2017/7/25.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDNavigationAnimationController.h"
#import "MDPopInteractionController.h"
#import "UIViewController+MDNavigationAnimatedTransitioning.h"

@interface MDNavigationAnimationController ()

@property (nonatomic, assign) UINavigationControllerOperation operation;
@property (nonatomic, weak) UIViewController *fromViewController;
@property (nonatomic, weak) UIViewController *toViewController;

@end

@implementation MDNavigationAnimationController

- (instancetype)init {
    return nil;
}

- (instancetype)initWithOperation:(UINavigationControllerOperation)operation
               fromViewController:(UIViewController *)fromViewController
                 toViewController:(UIViewController *)toViewController {
    self = [super init];
    if (self) {
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
    if ([self operation] == UINavigationControllerOperationPush) {
        [self animatePushTransition:transitionContext];
    } else {
        [self animatePopTransition:transitionContext];
    }
}

- (void)animatePushTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [[transitionContext containerView] addSubview:[fromViewController snapshot]];
    fromViewController.view.hidden = YES;
    
    CGRect frame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.frame = CGRectOffset(frame, CGRectGetWidth(frame), 0);
    [[transitionContext containerView] addSubview:[toViewController view]];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         fromViewController.snapshot.alpha = 0.0;
                         fromViewController.snapshot.frame = CGRectInset(fromViewController.view.frame, 20, 20);
                         toViewController.view.frame = CGRectOffset(toViewController.view.frame, -CGRectGetWidth(toViewController.view.frame), 0);
                     }
                     completion:^(BOOL finished) {
                         fromViewController.view.hidden = NO;
                         [[fromViewController snapshot] removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];
}

- (void)animatePopTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIView *fromSnapshot = [fromViewController snapshot];
    UIView *toSnapshot = [toViewController snapshot];
    
    fromSnapshot.frame = [[fromViewController view] frame];
    toSnapshot.frame = [[toViewController view] frame];
    
    UIView *toOverlayerView = [[UIView alloc] initWithFrame:[toSnapshot bounds]];
    toOverlayerView.backgroundColor = [UIColor colorWithWhite:0 alpha:.2f];
    
    CGAffineTransform transformer = CGAffineTransformMakeTranslation(CGRectGetWidth([[toViewController view] bounds]), 0);
    toSnapshot.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth([[toViewController view] bounds]) / 2., 0);
    toViewController.view.hidden = YES;
    
    [toSnapshot addSubview:toOverlayerView];
    [[transitionContext containerView] addSubview:[toViewController view]];
    [[transitionContext containerView] addSubview:toSnapshot];
    [[transitionContext containerView] addSubview:fromSnapshot];
    [[transitionContext containerView] sendSubviewToBack:toSnapshot];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         fromViewController.view.transform = transformer;
                         fromSnapshot.transform = transformer;
                         toOverlayerView.alpha = 0;
                         toSnapshot.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         
                         toViewController.view.hidden = NO;
                         fromViewController.view.transform = CGAffineTransformIdentity;
                         fromSnapshot.transform = CGAffineTransformIdentity;
                         toSnapshot.transform = CGAffineTransformIdentity;
                         
                         [fromSnapshot removeFromSuperview];
                         [toSnapshot removeFromSuperview];
                         [toOverlayerView removeFromSuperview];
                         
                         // Reset toViewController's `snapshot` to nil
                         if (![transitionContext transitionWasCancelled]) {
                             toViewController.snapshot = nil;
                         }
                         
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

@end
