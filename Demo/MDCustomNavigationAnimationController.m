// Copyright (c) 2017 Modool. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "MDCustomNavigationAnimationController.h"

@implementation MDCustomNavigationAnimationController

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if ([self operation] == UINavigationControllerOperationPush) {
        [self customAnimatePushTransition:transitionContext];
    } else {
        [self customAnimatePopTransition:transitionContext];
    }
}

- (void)customAnimatePushTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    CGRect initialFrame = [[fromViewController view] frame];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    
    [[transitionContext containerView] addSubview:[toViewController view]];
    
    UIView *toNavigationBarSnapshot = [[[fromViewController navigationController] view] resizableSnapshotViewFromRect:CGRectMake(0, 0, CGRectGetWidth(initialFrame), 64) afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    CGRect toNavigationBarFrame = [toNavigationBarSnapshot frame];
    
    toNavigationBarSnapshot.frame = CGRectOffset(toNavigationBarFrame, CGRectGetWidth(finalFrame), 0);
    toViewController.view.frame = CGRectOffset(finalFrame, CGRectGetWidth(finalFrame), 0);
    
    [[transitionContext containerView] addSubview:[fromViewController snapshot]];
    [[transitionContext containerView] addSubview:toNavigationBarSnapshot];
    [[transitionContext containerView] sendSubviewToBack:[fromViewController snapshot]];
    fromViewController.view.hidden = YES;
    fromViewController.navigationController.navigationBar.hidden = YES;
    UIApplication.sharedApplication.delegate.window.backgroundColor = [UIColor blackColor];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         fromViewController.snapshot.alpha = 0.5;
                         fromViewController.snapshot.frame = CGRectInset(initialFrame, 20, 20);
                         toViewController.view.frame = finalFrame;
                         toNavigationBarSnapshot.frame = toNavigationBarFrame;
                     }
                     completion:^(BOOL finished) {
                         fromViewController.view.hidden = NO;
                         fromViewController.snapshot.frame = CGRectInset(initialFrame, 20, 20);
                         
                         toViewController.view.frame = finalFrame;
                         toViewController.navigationController.navigationBar.hidden = NO;
                         UIApplication.sharedApplication.delegate.window.backgroundColor = [UIColor whiteColor];
                         
                         [[fromViewController snapshot] removeFromSuperview];
                         [toNavigationBarSnapshot removeFromSuperview];
                         
                         [transitionContext completeTransition:YES];
                     }];
}

- (void)customAnimatePopTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    CGRect initialFrame = [[fromViewController view] frame];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    
    toViewController.view.hidden = YES;
    toViewController.snapshot.alpha = 0.5;
    toViewController.snapshot.frame = CGRectInset(finalFrame, 20, 20);
    
    fromViewController.navigationController.navigationBar.hidden = YES;
    UIApplication.sharedApplication.delegate.window.backgroundColor = [UIColor blackColor];
    
    [[fromViewController view] addSubview:[fromViewController snapshot]];
    [[transitionContext containerView] addSubview:[toViewController view]];
    [[transitionContext containerView] addSubview:[toViewController snapshot]];
    [[transitionContext containerView] sendSubviewToBack:[toViewController snapshot]];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         fromViewController.view.frame = CGRectOffset(initialFrame, CGRectGetWidth(initialFrame), 0);
                         toViewController.snapshot.alpha = 1.0;
                         toViewController.snapshot.frame = finalFrame;
                     }
                     completion:^(BOOL finished) {
                         toViewController.view.hidden = NO;
                         toViewController.navigationController.navigationBar.hidden = NO;
                         UIApplication.sharedApplication.delegate.window.backgroundColor = [UIColor whiteColor];
                         
                         [[fromViewController snapshot] removeFromSuperview];
                         [[toViewController snapshot] removeFromSuperview];
                         
                         // Reset toViewController's `snapshot` to nil
                         if (![transitionContext transitionWasCancelled]) {
                             toViewController.snapshot = nil;
                         }
                         
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];

}

@end
