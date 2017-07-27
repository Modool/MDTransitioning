//
//  MDSwipeInteractionController.h
//  MDTransitioning
//
//  Created by Jave on 2017/7/26.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDInteractionControllerDelegate.h"

@interface MDSwipeInteractionController : NSObject<MDInteractionControllerDelegate>

@property (nonatomic, copy) void (^begin)();
@property (nonatomic, copy) void (^end)();
@property (nonatomic, copy) CGFloat (^enableSwipeTransform)(CGPoint location, CGPoint velocity);
@property (nonatomic, copy) CGFloat (^progressTransform)(CGPoint location, CGPoint translation, CGPoint velocity);

@property (nonatomic, assign) BOOL enable;

- (instancetype)init DEPRECATED_MSG_ATTRIBUTE(" Use interactionControllerWithViewController:operation: instead");

@end
