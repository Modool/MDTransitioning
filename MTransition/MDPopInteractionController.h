//
//  MDPopInteractionController.h
//  MDTransitioning
//
//  Created by Jave on 2017/7/25.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDSwipeInteractionController.h"

@interface MDPopInteractionController : MDSwipeInteractionController

@property (nonatomic, assign) CGFloat horizontalOffset; // Default is 20.f.

@end
