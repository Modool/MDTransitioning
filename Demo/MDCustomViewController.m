//
//  MDCustomViewController.m
//  Demo
//
//  Created by Jave on 2017/8/1.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDCustomViewController.h"
#import "MDCustomNavigationAnimationController.h"

@interface MDCustomViewController ()

@end

@implementation MDCustomViewController

#pragma mark - MDNavigationPopController

- (id<MDNavigationAnimatedTransitioning>)animationForNavigationOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;{
    return [[MDCustomNavigationAnimationController alloc] initWithOperation:operation fromViewController:fromViewController toViewController:toViewController];
}

@end
