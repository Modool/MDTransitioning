//
//  MDPresentionControllerDelegate.m
//  MDTransitioning
//
//  Created by 徐 林峰 on 2017/9/20.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDPresentionControllerDelegate.h"
#import "UIViewController+MDPresentionTransitioning.h"

@interface MDPresentionControllerDelegate ()

@property (nonatomic, weak) UIViewController *referenceViewController;

@end

@implementation MDPresentionControllerDelegate

+ (MDPresentionControllerDelegate *)delegateWithReferenceViewControllerClass:(Class)referenceViewControllerClass{
    static NSMutableDictionary<NSString *, MDPresentionControllerDelegate *> *delegates = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        delegates = [NSMutableDictionary new];
    });
    NSString *key = NSStringFromClass(referenceViewControllerClass);
    MDPresentionControllerDelegate *delegate = delegates[key];
    if (!delegate) {
        delegate = [MDPresentionControllerDelegate new];
        delegates[key] = delegate;
    }
    return delegate;
}

+ (instancetype)delegateWithReferenceViewController:(UIViewController *)viewController;{
    MDPresentionControllerDelegate *delegate = [self delegateWithReferenceViewControllerClass:[viewController class]];
    delegate.referenceViewController = viewController;
    return delegate;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [presented animationForPresentionOperation:MDPresentionAnimatedOperationPresent fromViewController:[self referenceViewController] toViewController:presented];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [dismissed animationForPresentionOperation:MDPresentionAnimatedOperationDismiss fromViewController:dismissed toViewController:[self referenceViewController]];
}

//- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <MDViewControllerAnimatedTransitioning>)animator;{
//    return [[[animator fromViewController] presentionInteractionController] interactiveTransition];
//}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<MDViewControllerAnimatedTransitioning>)animator;{
    return [[[animator fromViewController] presentionInteractionController] interactiveTransition];
}


@end
