//
//  MDVerticalSwipDismissInteractionController.m
//  MDTransitioning
//
//  Created by xulinfeng on 2018/4/11.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "MDVerticalSwipDismissInteractionController.h"

@implementation MDVerticalSwipDismissInteractionController

- (instancetype)initWithViewController:(UIViewController *)viewController{
    if (self = [super initWithViewController:viewController]) {
        self.begin = ^(id<MDPercentDrivenInteractiveTransitioning> interactiveTransition){
            [viewController dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return self;
}

@end
