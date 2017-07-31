//
//  MDPopInteractionController.m
//  MDTransitioning
//
//  Created by Jave on 2017/7/25.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDPopInteractionController.h"

@implementation MDPopInteractionController

- (instancetype)initWithViewController:(UIViewController *)viewController{
    if (self = [super initWithViewController:viewController]) {
        __block __weak id weak_self = self;
        self.horizontalOffset = 20.f;
        self.begin = ^(id<MDPercentDrivenInteractiveTransitioning> interactiveTransition){
            [[viewController navigationController] popViewControllerAnimated:YES];
        };
        self.allowSwipe = ^CGFloat(CGPoint location, CGPoint velocity) {
            return velocity.x > 0 && location.x < [weak_self horizontalOffset];
        };
        self.progress = ^CGFloat(CGPoint location, CGPoint translation, CGPoint velocity) {
            return translation.x / CGRectGetWidth([[viewController view] frame]);
        };
    }
    return self;
}

@end
