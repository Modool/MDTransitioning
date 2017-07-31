//
//  MDAnimatedTransitioning.h
//  MDTransitioning
//
//  Created by Jave on 2017/7/26.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MDInteractionController;
@protocol MDViewControllerAnimatedTransitioning<UIViewControllerAnimatedTransitioning>

@property (nonatomic, weak, readonly) UIViewController *fromViewController;
@property (nonatomic, weak, readonly) UIViewController *toViewController;

@end

@protocol MDNavigationAnimatedTransitioning <MDViewControllerAnimatedTransitioning>

@property (nonatomic, assign, readonly) UINavigationControllerOperation operation;

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


