//
//  MDAnimatedTransitioning.h
//  MDTransitioning
//
//  Created by Jave on 2017/7/26.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>

// This is baseic protocol of interactive transitioning, interactive progress base on percent.
@protocol MDPercentDrivenInteractiveTransitioning <UIViewControllerInteractiveTransitioning>

// Duration of transitioning.
@property (nonatomic, assign, readonly) CGFloat duration;

// Current completed percent of transition.
@property (nonatomic, assign, readonly) CGFloat percentComplete;

// Pause playing transition.
- (void)pauseInteractiveTransition NS_AVAILABLE_IOS(10_0);

// Update progress of playing transition.
- (void)updateInteractiveTransition:(CGFloat)percentComplete;

// Cancel playing transition.
- (void)cancelInteractiveTransition;

// Finish playing transition.
- (void)finishInteractiveTransition;

@end

// System interactive transition
@interface UIPercentDrivenInteractiveTransition (MDPercentDrivenInteractiveTransitioning)<MDPercentDrivenInteractiveTransitioning>
@end
