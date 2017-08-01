//
//  MDPopInteractionController.h
//  MDTransitioning
//
//  Created by Jave on 2017/7/25.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDSwipeInteractionController.h"

// The controller of pop interaction.
@interface MDPopInteractionController : MDSwipeInteractionController

// The horizontal offset is left edge of content view, default is 20.f.
@property (nonatomic, assign) CGFloat horizontalOffset;

@end
