//
//  MDVerticalSwipDismissInteractionController.m
//  Demo
//
//  Created by Jave on 2017/9/24.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDVerticalSwipDismissInteractionController.h"

@implementation MDVerticalSwipDismissInteractionController

- (instancetype)initWithViewController:(UIViewController *)viewController{
    if (self = [super initWithViewController:viewController]) {
        __block __weak id weak_self = self;
        self.verticalOffset = 20.f;
        self.begin = ^(id<MDPercentDrivenInteractiveTransitioning> interactiveTransition){
            [viewController dismissViewControllerAnimated:YES completion:nil];
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
