//
//  MDCustomImageViewController.m
//  Demo
//
//  Created by 徐 林峰 on 2017/9/21.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <MDTransitioning/MDTransitioning.h>
#import <MDTransitioning_ImagePriview/MDTransitioning+ImagePreview.h>
#import "MDCustomImageViewController.h"

@interface MDCustomImageViewController ()

@end

@implementation MDCustomImageViewController

- (id)initWithImage:(UIImage *)image;{
    if (self = [super initWithImage:image]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

#pragma mark - MDPresentionController

- (id<MPresentionAnimatedTransitioning>)animationForPresentionOperation:(MDPresentionAnimatedOperation)operation fromViewController:(UIViewController<MDImageZoomViewControllerDelegate> *)fromViewController toViewController:(UIViewController<MDImageZoomViewControllerDelegate> *)toViewController;{
    if (operation == MDPresentionAnimatedOperationPresent) {
        MDImageZoomAnimationController *controller = [MDImageZoomAnimationController animationForPresentOperation:operation fromViewController:fromViewController toViewController:toViewController];
        controller.hideReferenceImageViewWhenZoomIn = NO;
        return controller;
    } else {
        return [[MDPresentionAnimationController alloc] initWithPresentionAnimatedOperation:operation fromViewController:fromViewController toViewController:toViewController];
    }
}

@end
