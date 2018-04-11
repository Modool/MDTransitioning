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
        self.snapshotEnable = YES;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitioning {
    return [self navigationControllerOperation] == UINavigationControllerOperationPush ? 0.35f : [self duration];
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext; {
    if ([self navigationControllerOperation] == UINavigationControllerOperationPush) {
        [self pushTransitioning:transitionContext];
    } else {
        [self popTransitioning:transitionContext];
    }
}

- (void)pushTransitioning:(id<UIViewControllerContextTransitioning>)transitioning {
    UIViewController *fromViewController = [transitioning viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitioning viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSTimeInterval duration = [self transitionDuration:transitioning];
    
    CGRect initialFrame = [transitioning initialFrameForViewController:fromViewController];
    CGRect finalFrame = [transitioning finalFrameForViewController:toViewController];
    CGRect fromViewDestination = CGRectOffset(initialFrame, -CGRectGetWidth(initialFrame) / 2., 0);
    
    UIView *overlayer = [[UIView alloc] initWithFrame:(CGRect){0, 0, initialFrame.size}];
    overlayer.alpha = 0;
    overlayer.backgroundColor = [UIColor colorWithWhite:0 alpha:.2f];
    
    UIView *fromView = [self isSnapshotEnabled] ? [fromViewController snapshot] : [fromViewController view];
    
    fromViewController.view.hidden = [self isSnapshotEnabled];
    toViewController.view.frame = CGRectOffset(finalFrame, CGRectGetWidth(finalFrame), 0);
    
    [fromView addSubview:overlayer];
    [[transitioning containerView] addSubview:fromView];
    [[transitioning containerView] addSubview:[toViewController view]];
    
    [UIView animateWithDuration:duration
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         overlayer.alpha = 1.f;
                         fromView.frame = fromViewDestination;
                         toViewController.view.frame = finalFrame;
                     }
                     completion:^(BOOL finished) {
                         toViewController.view.frame = finalFrame;
                         fromViewController.view.frame = initialFrame;
                         fromViewController.view.hidden = NO;
                         
                         [fromView removeFromSuperview];
                         [overlayer removeFromSuperview];
                         
                         [transitioning completeTransition:![transitioning transitionWasCancelled]];
                     }];
}

- (void)popTransitioning:(id<UIViewControllerContextTransitioning>)transitioning {
    UIViewController *fromViewController = [transitioning viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitioning viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSTimeInterval duration = [self transitionDuration:transitioning];
    
    CGRect initialFrame = [transitioning initialFrameForViewController:fromViewController];
    CGRect finalFrame = [transitioning finalFrameForViewController:toViewController];
    CGRect toViewOrigin = CGRectOffset(finalFrame, -CGRectGetWidth(finalFrame) / 2., 0);;
    CGRect fromViewDestination = CGRectOffset(finalFrame, CGRectGetWidth(finalFrame), 0);
    
    toViewController.view.frame = toViewOrigin;
    fromViewController.view.hidden = [self isSnapshotEnabled];
    
    UIView *fromView = [self isSnapshotEnabled] ? [fromViewController snapshot] : [fromViewController view];
    fromView.frame = initialFrame;
    
    UIView *overlayer = [[UIView alloc] initWithFrame:(CGRect){0, 0, finalFrame.size}];
    overlayer.backgroundColor = [UIColor colorWithWhite:0 alpha:.2f];
    
    [[toViewController view] addSubview:overlayer];
    [[transitioning containerView] addSubview:[toViewController view]];
    [[transitioning containerView] addSubview:fromView];
    [[transitioning containerView] bringSubviewToFront:fromView];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         overlayer.alpha = 0;
                         fromView.frame = fromViewDestination;
                         toViewController.view.frame = finalFrame;
                     }
                     completion:^(BOOL finished) {
                         toViewController.view.frame = finalFrame;
                         fromViewController.view.frame = initialFrame;
                         fromViewController.view.hidden = NO;
                         
                         [fromView removeFromSuperview];
                         [overlayer removeFromSuperview];
                         // Reset toViewController's `snapshot` to nil
                         if ([transitioning transitionWasCancelled]) {
                             [[toViewController view] removeFromSuperview];
                         } else {
                             toViewController.snapshot = nil;
                         }
                         [transitioning completeTransition:![transitioning transitionWasCancelled]];
                     }];
}

@end
