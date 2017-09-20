//
//  MDVerticalSwipPopInteractionController.m
//  Demo
//
//  Created by 徐 林峰 on 2017/9/21.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDVerticalSwipPopInteractionController.h"

@implementation MDVerticalSwipPopInteractionController

- (instancetype)initWithViewController:(UIViewController *)viewController{
    if (self = [super initWithViewController:viewController]) {
        __block __weak id weak_self = self;
        self.verticalOffset = 100.f;
        self.begin = ^(id<MDPercentDrivenInteractiveTransitioning> interactiveTransition){
            [[viewController navigationController] popViewControllerAnimated:YES];
        };
        self.allowSwipe = ^CGFloat(CGPoint location, CGPoint velocity) {
            return velocity.y > 0 && location.y < [weak_self verticalOffset];
        };
        self.progress = ^CGFloat(CGPoint location, CGPoint translation, CGPoint velocity) {
            return translation.y / CGRectGetHeight([[viewController view] frame]);
        };
    }
    return self;
}

@end
