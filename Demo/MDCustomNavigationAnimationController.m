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
