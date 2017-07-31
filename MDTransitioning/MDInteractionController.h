//
//  MDInteractionController.h
//  MDTransitioning
//
//  Created by Jave on 2017/7/26.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDAnimatedTransitioning.h"
#import "MDInteractiveTransitioning.h"

@protocol MDNavigationPopController <NSObject>

@property (nonatomic, strong) UIView *snapshot;
@property (nonatomic, strong) id<MDInteractionController> interactiveController;

@property (nonatomic, assign) BOOL allowPopInteractive; // Default is YES.
@property (nonatomic, assign) BOOL allowCustomePopInteractive;  // Default is NO.

- (id<MDInteractionController>)requirePopInteractionController;
- (id<MDNavigationAnimatedTransitioning>)animationForNavigationOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;

@end

@protocol MDPresentionController <NSObject>

@optional
@property (nonatomic, strong) id<MDInteractionController> presentionInteractiveController;

- (id<MPresentionAnimatedTransitioning>)animationForPresentionOperation:(MDPresentionAnimatedOperation)operation fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;

@end

@protocol MDInteractionController <NSObject>

@property (nonatomic, weak, readonly) UIViewController *viewController;
@property (nonatomic, strong, readonly) id<MDPercentDrivenInteractiveTransitioning> interactiveTransition;

@property (nonatomic, assign, readonly) BOOL interactionInProgress;
@property (nonatomic, assign) BOOL enable;

@property (nonatomic, copy) CGFloat (^allowSwipe)(CGPoint location, CGPoint velocity);
@property (nonatomic, copy) CGFloat (^progress)(CGPoint location, CGPoint translation, CGPoint velocity);

@property (nonatomic, copy) void (^begin)(); // Default is called requireInteractiveTransition.
@property (nonatomic, copy) void (^end)(id<MDPercentDrivenInteractiveTransitioning> interactiveTransition, BOOL finished);
@property (nonatomic, copy) void (^update)(id<MDPercentDrivenInteractiveTransitioning> interactiveTransition, CGFloat progress);

- (id<MDPercentDrivenInteractiveTransitioning>)requireInteractiveTransition;

+ (instancetype)interactionControllerWithViewController:(UIViewController *)viewController;
- (instancetype)initWithViewController:(UIViewController *)viewController;

@end
