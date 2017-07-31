//
//  MDSwipeInteractionController.h
//  MDTransitioning
//
//  Created by Jave on 2017/7/26.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDInteractionController.h"

@interface MDSwipeInteractionController : NSObject<MDInteractionController, UIGestureRecognizerDelegate>

@property (nonatomic, copy) CGFloat (^allowSwipe)(CGPoint location, CGPoint velocity);
@property (nonatomic, copy) CGFloat (^progress)(CGPoint location, CGPoint translation, CGPoint velocity);

@property (nonatomic, copy) void (^begin)(); 
@property (nonatomic, copy) void (^end)(id<MDPercentDrivenInteractiveTransitioning> interactiveTransition, BOOL finished);
@property (nonatomic, copy) void (^update)(id<MDPercentDrivenInteractiveTransitioning> interactiveTransition, CGFloat progress);

@property (nonatomic, assign) BOOL enable;

- (instancetype)init DEPRECATED_MSG_ATTRIBUTE(" Use interactionControllerWithViewController:operation: instead");

@end
