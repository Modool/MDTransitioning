//
//  MDSwipeInteractionController.h
//  MDTransitioning
//
//  Created by Jave on 2017/7/26.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDInteractionController.h"

// The controller of swipe interaction.
@interface MDSwipeInteractionController : NSObject<MDInteractionController, UIGestureRecognizerDelegate>

- (instancetype)init DEPRECATED_MSG_ATTRIBUTE(" Use interactionControllerWithViewController:operation: instead");

@end
