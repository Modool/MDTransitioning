//
//  MDImageDismissInteractionController.m
//  MDTransitioning
//
//  Created by Jave on 2017/7/27.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDImageDismissInteractionController.h"

@implementation MDImageDismissInteractionController

- (instancetype)initWithViewController:(UIViewController<MDImageContainerViewControllerDelegate> *)viewController{
    if (self = [super initWithViewController:viewController]) {
        NSParameterAssert([viewController conformsToProtocol:@protocol(MDImageContainerViewControllerDelegate)]);
        
        __block __weak id weak_self = self;
        self.translation = CGRectGetWidth([[viewController view] bounds]) / 3.;
        self.begin = ^{
            [viewController dismissViewControllerAnimated:YES completion:nil];
        };
        self.allowSwipe = ^CGFloat(CGPoint location, CGPoint velocity) {
            return [[viewController scrollView] zoomScale] <= [[viewController scrollView] minimumZoomScale] && velocity.y > 0;
        };
        self.progress = ^CGFloat(CGPoint location, CGPoint translation, CGPoint velocity) {
            CGFloat distance = sqrt(pow(translation.x, 2) + pow(translation.y, 2));
            return  distance / [weak_self translation];
        };
    }
    return self;
}

@end
