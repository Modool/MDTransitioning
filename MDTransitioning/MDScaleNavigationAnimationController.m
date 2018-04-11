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

#import "MDScaleNavigationAnimationController.h"

@implementation MDScaleNavigationAnimationController

- (instancetype)initWithNavigationControllerOperation:(UINavigationControllerOperation)navigationControllerOperation fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController{
    if (self = [super initWithNavigationControllerOperation:navigationControllerOperation fromViewController:fromViewController toViewController:toViewController]) {
        self.scaleOffset = CGSizeMake(20, 20);
        self.transitionBackgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)setTransitionBackgroundColor:(UIColor *)transitionBackgroundColor{
    _transitionBackgroundColor = transitionBackgroundColor;
    
    self.pushTransitionBackgroundColor = transitionBackgroundColor;
    self.popTransitionBackgroundColor = transitionBackgroundColor;
}

- (void)setPushTransitionBackgroundColor:(UIColor *)pushTransitionBackgroundColor{
    if (_pushTransitionBackgroundColor != pushTransitionBackgroundColor) {
        _pushTransitionBackgroundColor = pushTransitionBackgroundColor;
        
        if (_pushTransitionBackgroundColor != _transitionBackgroundColor) {
            _transitionBackgroundColor = nil;
        }
    }
}

- (void)setPopTransitionBackgroundColor:(UIColor *)popTransitionBackgroundColor{
    if (_popTransitionBackgroundColor != popTransitionBackgroundColor) {
        _popTransitionBackgroundColor = popTransitionBackgroundColor;
        
        if (popTransitionBackgroundColor != _transitionBackgroundColor) {
            _transitionBackgroundColor = nil;
        }
    }
}

- (void)pushTransitioning:(id<UIViewControllerContextTransitioning>)transitioning {
    UIViewController *fromViewController = [transitioning viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitioning viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSTimeInterval duration = [self transitionDuration:transitioning];
    
    CGRect initialFrame = [transitioning initialFrameForViewController:fromViewController];
    CGRect finalFrame = [transitioning finalFrameForViewController:toViewController];
    CGAffineTransform fromViewDestinationTransform = CGAffineTransformScale(CGAffineTransformIdentity, 1 - self.scaleOffset.width / CGRectGetWidth(initialFrame), 1 - self.scaleOffset.height / CGRectGetHeight(initialFrame));
    
    UIView *overlayer = [[UIView alloc] initWithFrame:(CGRect){0, 0, initialFrame.size}];
    overlayer.alpha = 0;
    overlayer.backgroundColor = [UIColor colorWithWhite:0 alpha:.2f];
    
    UIView *fromView = [self isSnapshotEnabled] ? [fromViewController snapshot] : [fromViewController view];
    fromViewController.view.hidden = [self isSnapshotEnabled];
    
    UINavigationBar *navigationBar = [[fromViewController navigationController] navigationBar];
    CGRect navigationBarFrame = [navigationBar frame];
    
    navigationBar.frame = CGRectOffset(navigationBarFrame, CGRectGetWidth(navigationBarFrame), 0);
    toViewController.view.frame = CGRectOffset(finalFrame, CGRectGetWidth(finalFrame), 0);
    
    [fromView addSubview:overlayer];
    [[transitioning containerView] addSubview:fromView];
    [[transitioning containerView] addSubview:[toViewController view]];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIColor *backgroundColor = [window backgroundColor];
    
    window.backgroundColor = self.pushTransitionBackgroundColor;
    [UIView animateWithDuration:duration
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         overlayer.alpha = 1.f;
                         fromView.transform = fromViewDestinationTransform;
                         toViewController.view.frame = finalFrame;
                         navigationBar.frame = navigationBarFrame;
                     }
                     completion:^(BOOL finished) {
                         fromView.transform = CGAffineTransformIdentity;
                         navigationBar.frame = navigationBarFrame;
                         toViewController.view.frame = finalFrame;
                         fromViewController.view.frame = initialFrame;
                         
                         fromViewController.view.hidden = NO;
                         window.backgroundColor = backgroundColor;
                         
                         [fromView removeFromSuperview];
                         [overlayer removeFromSuperview];
                         
                         [transitioning completeTransition:YES];
                     }];
}

- (void)popTransitioning:(id<UIViewControllerContextTransitioning>)transitioning {
    UIViewController *fromViewController = [transitioning viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitioning viewControllerForKey:UITransitionContextToViewControllerKey];
    NSTimeInterval duration = [self transitionDuration:transitioning];
    
    CGRect initialFrame = [transitioning initialFrameForViewController:fromViewController];
    CGRect finalFrame = [transitioning finalFrameForViewController:toViewController];
    CGRect fromViewDestination = CGRectOffset(initialFrame, CGRectGetWidth(initialFrame), 0);
    CGAffineTransform toViewOriginTransform = CGAffineTransformScale(CGAffineTransformIdentity, 1 - self.scaleOffset.width / CGRectGetWidth(finalFrame), 1 - self.scaleOffset.height / CGRectGetHeight(finalFrame));
    
    UIView *overlayer = [[UIView alloc] initWithFrame:(CGRect){0, 0, initialFrame.size}];
    overlayer.backgroundColor = [UIColor colorWithWhite:0 alpha:.2f];
    
    UIView *fromView = [self isSnapshotEnabled] ? [fromViewController snapshot] : [fromViewController view];
    fromViewController.view.hidden = [self isSnapshotEnabled];
    
    UIView *toView = [self isSnapshotEnabled] ? [toViewController snapshot] : [toViewController view];
    
    [toView addSubview:overlayer];
    [[transitioning containerView] addSubview:[toViewController view]];
    [[transitioning containerView] addSubview:toView];
    [[transitioning containerView] addSubview:fromView];
    [[transitioning containerView] bringSubviewToFront:fromView];
    
    toView.transform = toViewOriginTransform;
    toViewController.view.hidden = [self isSnapshotEnabled];
    
    UINavigationBar *navigationBar = [[fromViewController navigationController] navigationBar];
    navigationBar.hidden = YES;
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIColor *backgroundColor = [window backgroundColor];
    
    window.backgroundColor = self.popTransitionBackgroundColor;
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         overlayer.alpha = 0.f;
                         fromView.frame = fromViewDestination;
                         toView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         toView.transform = CGAffineTransformIdentity;
                         toViewController.view.frame = finalFrame;
                         fromViewController.view.frame = initialFrame;
                         
                         navigationBar.hidden = NO;
                         fromViewController.view.hidden = NO;
                         toViewController.view.hidden = NO;
                         window.backgroundColor = backgroundColor;
                         
                         if ([self isSnapshotEnabled]) [toView removeFromSuperview];
                         [fromView removeFromSuperview];
                         [overlayer removeFromSuperview];
                         
                         if ([transitioning transitionWasCancelled]) {
                             [[toViewController view] removeFromSuperview];
                         }
                         [transitioning completeTransition:![transitioning transitionWasCancelled]];
                     }];
}

@end
