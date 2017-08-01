//
//  MDImageDraggingDismissInteractionController.h
//  MDTransitioning
//
//  Created by Jave on 2017/7/27.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <MDTransitioning/MDTransitioning.h>

@interface MDImageDraggingDismissInteractionController : MDSwipeInteractionController

@property (nonatomic, assign) CGFloat translation; // Default is controller.view.width / 3.f.

@end
