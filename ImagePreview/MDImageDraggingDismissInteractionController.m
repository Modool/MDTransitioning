// Copyright (c) 2017 Modool. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "MDImageDraggingDismissInteractionController.h"
#import "MDImageZoomAnimationController.h"

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
        self.viewController.imageView.transform = CGAffineTransformIdentity;
        self.viewController.imageView.transform = CGAffineTransformScale(CGAffineTransformTranslate(CGAffineTransformIdentity, translation.x, translation.y), 1 - progress / 2., 1 - progress / 2.);
        self.viewController.backgroundView.alpha = (1 - progress);
    } else if ([recognizer state] == UIGestureRecognizerStateEnded || [recognizer state] == UIGestureRecognizerStateCancelled) {
        CGFloat progress = sqrt(pow(translation.x, 2) + pow(translation.y, 2)) / [self translation];
        progress = MIN(1.0, MAX(0.0, progress));
        // Finish or cancel the interactive transition
        if (progress > 0.5) {
            [[self viewController] dismissViewControllerAnimated:YES completion:nil];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                self.viewController.backgroundView.alpha = 1.f;
                self.viewController.imageView.transform = CGAffineTransformIdentity;
            }];
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
