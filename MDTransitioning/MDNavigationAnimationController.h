//
//  MDNavigationAnimationController.h
//  MDTransitioning
//
//  Created by Jave on 2017/7/25.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDTransationingDelegate.h"

@interface MDNavigationAnimationController : NSObject<MDNavigationAnimatedTransitioning>

@property (nonatomic, assign) CGFloat duration; // Default is 0.25f.

- (instancetype)initWithOperation:(UINavigationControllerOperation)operation
                                   fromViewController:(UIViewController *)fromViewController
                                     toViewController:(UIViewController *)toViewController;

- (instancetype)init DEPRECATED_MSG_ATTRIBUTE(" Use initWithOperation:fromViewController:toViewController: instead");

@end
