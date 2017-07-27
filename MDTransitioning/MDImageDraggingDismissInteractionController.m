//
//  MDImageDraggingDismissInteractionController.m
//  MDTransitioning
//
//  Created by Jave on 2017/7/27.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDImageDraggingDismissInteractionController.h"

@interface MDImageDraggingDismissInteractionController ()

@property (nonatomic, weak, readonly) UIViewController<MDImageContainerViewControllerDelegate> *viewController;

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, assign) BOOL interactionInProgress;

@end

@implementation MDImageDraggingDismissInteractionController
@dynamic interactiveTransition, interactionInProgress, viewController, panGestureRecognizer;

- (instancetype)initWithViewController:(UIViewController<MDImageContainerViewControllerDelegate> *)viewController{
    if (self = [super initWithViewController:viewController]) {
        NSParameterAssert([viewController conformsToProtocol:@protocol(MDImageContainerViewControllerDelegate)]);
        self.translation = CGRectGetWidth([[viewController view] bounds]) / 3.;
    }
    return self;
}

#pragma mark - UIPanGestureRecognizer handlers

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:[[self viewController] view]];
    
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        self.interactionInProgress = YES;
    } else if ([recognizer state] == UIGestureRecognizerStateChanged) {
        CGFloat progress = sqrt(pow(translation.x, 2) + pow(translation.y, 2)) / [self translation];
        progress = MIN(1.0, MAX(0.0, progress));
        self.viewController.imageView.transform = CGAffineTransformScale(CGAffineTransformTranslate(CGAffineTransformIdentity, translation.x, translation.y), 1 - progress / 2., 1 - progress / 2.);
        self.viewController.backgroundView.alpha = (1 - progress);
    } else if ([recognizer state] == UIGestureRecognizerStateEnded || [recognizer state] == UIGestureRecognizerStateCancelled) {
        CGFloat progress = sqrt(pow(translation.x, 2) + pow(translation.y, 2)) / [self translation];
        progress = MIN(1.0, MAX(0.0, progress));
        // Finish or cancel the interactive transition
        if (progress > 0.5) {
            [[self viewController] dismissViewControllerAnimated:YES completion:nil];
        } else {
            self.viewController.backgroundView.alpha = 1.f;
            self.viewController.imageView.transform = CGAffineTransformIdentity;
        }
        self.interactionInProgress = NO;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)recognizer {
    UIScrollView *scrollView = [[self viewController] scrollView];
    
    return recognizer == [self panGestureRecognizer] && [scrollView zoomScale] <= [scrollView minimumZoomScale];
}

@end
