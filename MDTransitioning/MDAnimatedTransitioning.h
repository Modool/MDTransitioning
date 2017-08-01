//
//  MDAnimatedTransitioning.h
//  MDTransitioning
//
//  Created by Jave on 2017/7/26.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MDInteractionController;

// This is baseic protocol of animated transitioning, extend to access view controllers in transition view.
@protocol MDViewControllerAnimatedTransitioning<UIViewControllerAnimatedTransitioning>

// Access appearing view controller in transition view.
@property (nonatomic, weak, readonly) UIViewController *fromViewController;

// Access view controller will be appearing in transition view.
@property (nonatomic, weak, readonly) UIViewController *toViewController;

@end

// This is navigation transitioning protocol, extend to access operation.
@protocol MDNavigationAnimatedTransitioning <MDViewControllerAnimatedTransitioning>

// Access operation, push or pop.
@property (nonatomic, assign, readonly) UINavigationControllerOperation operation;

@end

// Enum of presention operations, present and dismiss.
typedef NS_ENUM(NSInteger, MDPresentionAnimatedOperation) {
    MDPresentionAnimatedOperationNone,
    MDPresentionAnimatedOperationPresent,
    MDPresentionAnimatedOperationDismiss,
};

// This is presention transitioning protocol, extend to access operation.
@protocol MPresentionAnimatedTransitioning <MDViewControllerAnimatedTransitioning>

// Access operation, present or dismiss.
@property (nonatomic, assign, readonly) MDPresentionAnimatedOperation operation;

@end


