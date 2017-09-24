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

#import "MDPresentionAnimationController.h"
#import "UIViewController+MDPresentionTransitioning.h"

@interface MDPresentionAnimationController ()

@property (nonatomic, assign) MDPresentionAnimatedOperation presentionAnimatedOperation;
@property (nonatomic, weak) UIViewController *fromViewController;
@property (nonatomic, weak) UIViewController *toViewController;

@end

@implementation MDPresentionAnimationController

- (instancetype)init {
    return nil;
}

- (instancetype)initWithPresentionAnimatedOperation:(MDPresentionAnimatedOperation)presentionAnimatedOperation fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {
    self = [super init];
    if (self) {
        NSParameterAssert(presentionAnimatedOperation != MDPresentionAnimatedOperationNone);
        
        self.duration = 0.25;
        self.presentionAnimatedOperation = presentionAnimatedOperation;
        self.fromViewController = fromViewController;
        self.toViewController = toViewController;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return [self duration];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if ([self presentionAnimatedOperation] == MDPresentionAnimatedOperationPresent) {
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
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         toViewController.view.frame = CGRectOffset([[toViewController view] frame], 0, -CGRectGetHeight(frame));
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
