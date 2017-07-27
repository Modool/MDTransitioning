//
//  MDTransationingDelegate.h
//  MDTransitioning
//
//  Created by Jave on 2017/7/26.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MDInteractionControllerDelegate;
@protocol MDViewControllerAnimatedTransitioning<UIViewControllerAnimatedTransitioning>

@property (nonatomic, weak, readonly) UIViewController *fromViewController;
@property (nonatomic, weak, readonly) UIViewController *toViewController;

@end

@protocol MDNavigationAnimatedTransitioning <MDViewControllerAnimatedTransitioning>

@property (nonatomic, assign, readonly) UINavigationControllerOperation operation;

@end

@protocol MDNavigationInteractivePopTransitioning <NSObject>

@property (nonatomic, strong) UIView *snapshot;
@property (nonatomic, strong) id<MDInteractionControllerDelegate> interactiveController;

@property (nonatomic, assign) BOOL allowPopInteractive; // Default is YES.
@property (nonatomic, assign) BOOL allowCustomePopInteractive;  // Default is NO.

- (id<MDInteractionControllerDelegate>)requirePopInteractionController;
- (id<MDNavigationAnimatedTransitioning>)animationForNavigationOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;

@end

// Present and dismiss
typedef NS_ENUM(NSInteger, MDPresentionAnimatedOperation) {
    MDPresentionAnimatedOperationNone,
    MDPresentionAnimatedOperationPresent,
    MDPresentionAnimatedOperationDismiss,
};

@protocol MPresentionAnimatedTransitioning <MDViewControllerAnimatedTransitioning>

@property (nonatomic, assign, readonly) MDPresentionAnimatedOperation operation;

@end

@protocol MDPresentionInteractiveTransitioning <NSObject>

@optional
@property (nonatomic, strong) id<MDInteractionControllerDelegate> presentionInteractiveController;

- (id<MPresentionAnimatedTransitioning>)animationForPresentionOperation:(MDPresentionAnimatedOperation)operation fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;

@end
