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

#import "UIViewController+MDNavigationTransitioning.h"
#import "MDTransitioning+Private.h"
#import "MDPopInteractionController.h"
#import "MDNavigationAnimationController.h"

MDTransitioningLoadCategory(UIViewController_MDNavigationTransitioning)

@implementation UIViewController (MDNavigationTransitioning)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MDTransitioningMethodSwizzle([self class], @selector(viewWillDisappear:), @selector(swizzle_viewWillDisappear:));
        MDTransitioningMethodSwizzle([self class], @selector(viewDidLoad), @selector(swizzle_viewDidLoad));
    });
}

- (void)swizzle_viewDidLoad{
    [self swizzle_viewDidLoad];
    
    if ([self allowPopInteractive] &&
        ![self allowCustomPopInteractive] &&
        [self navigationController] != nil &&
        [self navigationController] == [self parentViewController] &&
        [[[self navigationController] viewControllers] firstObject] != self) {
        
        self.interactionController = [self requirePopInteractionController];
    }
}

- (void)swizzle_viewWillDisappear:(BOOL)animated {
    [self swizzle_viewWillDisappear:animated];
    // Being popped, take a snapshot
    if ([self isMovingFromParentViewController]) {
        self.snapshot = [[[self navigationController] view] snapshotViewAfterScreenUpdates:NO];
    }
}

- (UIView *)snapshot{
    return objc_getAssociatedObject(self, @selector(snapshot));
}

- (void)setSnapshot:(UIView *)snapshot{
    if ([self snapshot] != snapshot) {
        objc_setAssociatedObject(self, @selector(snapshot), snapshot, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setAllowPopInteractive:(BOOL)allowPopInteractive{
    objc_setAssociatedObject(self, @selector(allowPopInteractive), @(allowPopInteractive), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)allowPopInteractive{
    id allowPopInteractiveAssociatedObject = objc_getAssociatedObject(self, @selector(allowPopInteractive));
    if (!allowPopInteractiveAssociatedObject) {
        allowPopInteractiveAssociatedObject = @YES;
        self.allowPopInteractive = YES;
    }
    return [allowPopInteractiveAssociatedObject boolValue];
}

- (void)setAllowCustomPopInteractive:(BOOL)allowCustomPopInteractive{
    objc_setAssociatedObject(self, @selector(allowCustomPopInteractive), @(allowCustomPopInteractive), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)allowCustomPopInteractive{
    return [objc_getAssociatedObject(self, @selector(allowCustomPopInteractive)) boolValue];
}

- (id<MDInteractionController>)interactionController{
    return objc_getAssociatedObject(self, @selector(interactionController));
}

- (void)setInteractionController:(id<MDInteractionController>)interactionController{
    if ([self interactionController] != interactionController) {
        objc_setAssociatedObject(self, @selector(interactionController), interactionController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (id<MDInteractionController>)requirePopInteractionController;{
    return [MDPopInteractionController interactionControllerWithViewController:self];
}

- (id<MDNavigationAnimatedTransitioning>)animationForNavigationOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;{
    return [[MDNavigationAnimationController alloc] initWithOperation:operation fromViewController:fromViewController toViewController:toViewController];
}

@end
