//
//  MDVerticalSwipInteractionController.h
//  Demo
//
//  Created by Jave on 2017/9/24.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDSwipeInteractionController.h"

@interface MDVerticalSwipInteractionController : MDSwipeInteractionController

// The vertical offset is top edge of content view, default is 20.f.
@property (nonatomic, assign) CGFloat verticalTranslation;

@end
