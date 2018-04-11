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

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitioning {
    return [self duration];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitioning {
    if ([self presentionAnimatedOperation] == MDPresentionAnimatedOperationPresent) {
        [self presentTransitioning:transitioning];
    } else {
        [self dismissTransitioning:transitioning];
    }
}

- (void)presentTransitioning:(id<UIViewControllerContextTransitioning>)transitioning {
    UIViewController *fromViewController   = [transitioning viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitioning viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect initialFrame = [transitioning initialFrameForViewController:fromViewController];
    CGRect finalFrame = [transitioning finalFrameForViewController:toViewController];
    CGRect origin = CGRectOffset(initialFrame, 0, CGRectGetHeight(finalFrame));
    
    toViewController.view.frame = origin;
    [[transitioning containerView] addSubview:[toViewController view]];
    
    NSTimeInterval duration = [self transitionDuration:transitioning];
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         toViewController.view.frame = finalFrame;
                     }
                     completion:^(BOOL finished) {
                         [transitioning completeTransition:YES];
                     }];
}

- (void)dismissTransitioning:(id<UIViewControllerContextTransitioning>)transitioning {
    UIViewController *fromViewController = [transitioning viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitioning viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect initialFrame = [transitioning initialFrameForViewController:fromViewController];
    CGRect finalFrame = [transitioning finalFrameForViewController:toViewController];
    CGRect destination = CGRectOffset(initialFrame, 0, CGRectGetHeight(finalFrame));
    
    [[transitioning containerView] addSubview:[toViewController view]];
    [[transitioning containerView] sendSubviewToBack:[toViewController view]];
    
    NSTimeInterval duration = [self transitionDuration:transitioning];
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         fromViewController.view.frame = destination;
                     }
                     completion:^(BOOL finished) {
                         fromViewController.view.frame = initialFrame;
                         
                         if ([transitioning transitionWasCancelled]) {
                             [[toViewController view] removeFromSuperview];
                         }
                         
                         [transitioning completeTransition:![transitioning transitionWasCancelled]];
                     }];
}

@end
