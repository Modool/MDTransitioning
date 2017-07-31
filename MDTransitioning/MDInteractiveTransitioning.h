//
//  MDAnimatedTransitioning.h
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

@protocol MDPercentDrivenInteractiveTransitioning <UIViewControllerInteractiveTransitioning>

@property (nonatomic, assign, readonly) CGFloat duration;
@property (nonatomic, assign, readonly) CGFloat percentComplete;

- (void)pauseInteractiveTransition NS_AVAILABLE_IOS(10_0);
- (void)updateInteractiveTransition:(CGFloat)percentComplete;
- (void)cancelInteractiveTransition;
- (void)finishInteractiveTransition;

@end

@interface UIPercentDrivenInteractiveTransition (MDPercentDrivenInteractiveTransitioning)<MDPercentDrivenInteractiveTransitioning>
@end
