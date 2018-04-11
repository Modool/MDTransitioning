//
//  MDVerticalSwipInteractionController.m
//  Demo
//
//  Created by Jave on 2017/9/24.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDVerticalSwipInteractionController.h"

@implementation MDVerticalSwipInteractionController

- (instancetype)initWithViewController:(UIViewController *)viewController{
    if (self = [super initWithViewController:viewController]) {
        __block __weak MDVerticalSwipInteractionController *weak_self = self;
        self.verticalTranslation = 200.f;
        self.allowSwipe = ^CGFloat(CGPoint location, CGPoint velocity) {
            return velocity.y > 0;
        };
        self.progress = ^CGFloat(CGPoint location, CGPoint translation, CGPoint velocity) {
            return translation.y / weak_self.verticalTranslation;
        };
    }
    return self;
}

@end
