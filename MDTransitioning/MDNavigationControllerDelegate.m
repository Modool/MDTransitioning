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

#import <objc/runtime.h>

#import "MDNavigationControllerDelegate.h"
#import "MDNavigationAnimationController.h"
#import "MDInteractionController.h"
#import "UIViewController+MDNavigationTransitioning.h"
#import "MDTransitioning+Private.h"

@implementation UINavigationController (MDNavigationAnimationController)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MDTransitioningMethodSwizzle([self class], @selector(pushViewController:animated:), @selector(swizzle_pushViewController:animated:));
    });
}

- (void)swizzle_pushViewController:(UIViewController*)viewController animated:(BOOL)animated{
    self.view.userInteractionEnabled = NO;
    
    if ([self topViewController] && ![[self topViewController] snapshot]) {
        self.topViewController.snapshot = [[self view] snapshotViewAfterScreenUpdates:NO];
    }
    
    [self swizzle_pushViewController:viewController animated:animated];
}

- (BOOL)allowPushAnimation{
    return [objc_getAssociatedObject(self, @selector(allowPushAnimation)) boolValue];
}

- (void)setAllowPushAnimation:(BOOL)allowPushAnimation{
    objc_setAssociatedObject(self, @selector(allowPushAnimation), @(allowPushAnimation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation MDNavigationControllerDelegate

+ (instancetype)defaultDelegate;{
    static MDNavigationControllerDelegate *delegate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        delegate = [MDNavigationControllerDelegate new];
    });
    return delegate;
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animate{
    navigationController.view.userInteractionEnabled = YES;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(MDNavigationAnimationController *)animationController {
    return [[[animationController fromViewController] interactionController] interactiveTransition];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromViewController
                                                 toViewController:(UIViewController *)toViewController {
    if (operation == UINavigationControllerOperationPush && ![navigationController allowPushAnimation]) return nil;
    UIViewController *displayingViewController = operation == UINavigationControllerOperationPush ? toViewController : fromViewController;
    return [displayingViewController animationForNavigationOperation:operation fromViewController:fromViewController toViewController:toViewController];
}

@end
