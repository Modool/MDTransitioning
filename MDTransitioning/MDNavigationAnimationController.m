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

#import "MDNavigationAnimationController.h"
#import "MDPopInteractionController.h"
#import "UIViewController+MDNavigationTransitioning.h"

@interface MDNavigationAnimationController ()

@property (nonatomic, assign) UINavigationControllerOperation navigationControllerOperation;
@property (nonatomic, weak) UIViewController *fromViewController;
@property (nonatomic, weak) UIViewController *toViewController;

@end

@implementation MDNavigationAnimationController

- (instancetype)init {
    return nil;
}

- (instancetype)initWithNavigationControllerOperation:(UINavigationControllerOperation)navigationControllerOperation fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {
    self = [super init];
    if (self) {
        self.duration = 0.25;
        self.navigationControllerOperation = navigationControllerOperation;
        self.fromViewController = fromViewController;
        self.toViewController = toViewController;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return [self navigationControllerOperation] == UINavigationControllerOperationPush ? 0.35f : [self duration];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if ([self navigationControllerOperation] == UINavigationControllerOperationPush) {
        [self animatePushTransition:transitionContext];
    } else {
        [self animatePopTransition:transitionContext];
    }
}

- (void)animatePushTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    CGRect frame = [transitionContext finalFrameForViewController:toViewController];
    
    UIView *fromSnapshot = [fromViewController snapshot];
    UIView *fromOverlayerView = [[UIView alloc] initWithFrame:[fromSnapshot bounds]];
    fromOverlayerView.alpha = 0;
    fromOverlayerView.backgroundColor = [UIColor colorWithWhite:0 alpha:.2f];
    
    fromViewController.view.hidden = YES;
    toViewController.view.frame = CGRectOffset(frame, CGRectGetWidth(frame), 0);
    
    [fromSnapshot addSubview:fromOverlayerView];
    [[transitionContext containerView] addSubview:fromSnapshot];
    [[transitionContext containerView] addSubview:[toViewController view]];
    
    [UIView animateWithDuration:duration
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         fromOverlayerView.alpha = 1.;
                         fromSnapshot.frame = CGRectOffset([[fromViewController view] frame], -CGRectGetWidth([[fromViewController view] frame]) / 2., 0);
                         toViewController.view.frame = CGRectOffset([[toViewController view] frame], -CGRectGetWidth([[toViewController view] frame]), 0);
                     }
                     completion:^(BOOL finished) {
                         fromViewController.view.hidden = NO;
                         
                         [fromSnapshot removeFromSuperview];
                         [fromOverlayerView removeFromSuperview];
                         
                         [transitionContext completeTransition:YES];
                     }];
}

- (void)animatePopTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    CGRect initialFrame = [[fromViewController view] frame];
    CGRect finalFrame = [[toViewController view] frame];
    
    UIView *fromSnapshot = [fromViewController snapshot];
    UIView *toSnapshot = [toViewController snapshot];

    fromSnapshot.frame = initialFrame;
    toSnapshot.frame = CGRectOffset(finalFrame, -CGRectGetWidth(finalFrame) / 2., 0);
    
    UIView *toOverlayerView = [[UIView alloc] initWithFrame:[toSnapshot bounds]];
    toOverlayerView.backgroundColor = [UIColor colorWithWhite:0 alpha:.2f];
    
    toViewController.view.hidden = YES;
    fromViewController.view.hidden = YES;
    
    [toSnapshot addSubview:toOverlayerView];
    [[transitionContext containerView] addSubview:[toViewController view]];
    [[transitionContext containerView] addSubview:toSnapshot];
    [[transitionContext containerView] addSubview:fromSnapshot];
    [[transitionContext containerView] sendSubviewToBack:toSnapshot];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         toOverlayerView.alpha = 0;
                         toSnapshot.frame = finalFrame;
                         fromSnapshot.frame = CGRectOffset(finalFrame, CGRectGetWidth(finalFrame), 0);
                     }
                     completion:^(BOOL finished) {
                         toSnapshot.frame = finalFrame;
                         fromSnapshot.frame = CGRectOffset(finalFrame, CGRectGetWidth(finalFrame), 0);
                         fromViewController.view.frame = initialFrame;
                         
                         toViewController.view.hidden = NO;
                         
                         [fromSnapshot removeFromSuperview];
                         [toSnapshot removeFromSuperview];
                         [toOverlayerView removeFromSuperview];
                         // Reset toViewController's `snapshot` to nil
                         if (![transitionContext transitionWasCancelled]) {
                             toViewController.snapshot = nil;
                         } else {
                             fromViewController.view.hidden = NO;
                         }
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

@end
