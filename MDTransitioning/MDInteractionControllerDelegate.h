//
//  MDInteractionControllerDelegate.h
//  MDTransitioning
//
//  Created by Jave on 2017/7/26.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MDInteractionOperation) {
    MDInteractionOperationPop,
    MDInteractionOperationPresent,
    MDInteractionOperationDismiss,
    MDInteractionOperationTab
};

@protocol MDPercentDrivenInteractiveTransition <UIViewControllerInteractiveTransitioning>

@property (nonatomic, assign, readonly) CGFloat duration;
@property (nonatomic, assign, readonly) CGFloat percentComplete;

- (void)pauseInteractiveTransition NS_AVAILABLE_IOS(10_0);
- (void)updateInteractiveTransition:(CGFloat)percentComplete;
- (void)cancelInteractiveTransition;
- (void)finishInteractiveTransition;

@end

@protocol MDInteractionControllerDelegate <NSObject>

@property (nonatomic, weak, readonly) UIViewController *viewController;
@property (nonatomic, strong, readonly) id<MDPercentDrivenInteractiveTransition> interactiveTransition;

@property (nonatomic, assign, readonly) BOOL interactionInProgress;
@property (nonatomic, assign) BOOL enable;

@property (nonatomic, copy) CGFloat (^allowSwipe)(CGPoint location, CGPoint velocity);
@property (nonatomic, copy) CGFloat (^progress)(CGPoint location, CGPoint translation, CGPoint velocity);

@property (nonatomic, copy) void (^begin)(); // Default is called requireInteractiveTransition.
@property (nonatomic, copy) void (^end)(id<MDPercentDrivenInteractiveTransition> interactiveTransition, BOOL finished);
@property (nonatomic, copy) void (^update)(id<MDPercentDrivenInteractiveTransition> interactiveTransition, CGFloat progress);

- (id<MDPercentDrivenInteractiveTransition>)requireInteractiveTransition;

+ (instancetype)interactionControllerWithViewController:(UIViewController *)viewController;
- (instancetype)initWithViewController:(UIViewController *)viewController;

@end

@interface UIPercentDrivenInteractiveTransition (MDPercentDrivenInteractiveTransition)<MDPercentDrivenInteractiveTransition>
@end
