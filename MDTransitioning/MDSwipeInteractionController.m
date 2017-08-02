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

#import "MDSwipeInteractionController.h"

@interface MDSwipeInteractionController ()

@property (nonatomic, assign) BOOL interactionInProgress;

@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, strong) id<MDPercentDrivenInteractiveTransitioning> interactiveTransition;

@end

@implementation MDSwipeInteractionController
@synthesize enable = _enable;
@synthesize allowSwipe = _allowSwipe, progress = _progress;
@synthesize begin = _begin, end = _end, update = _update;

- (instancetype)init {
    return nil;
}

+ (instancetype)interactionControllerWithViewController:(UIViewController *)viewController{
    return [[self alloc] initWithViewController:viewController];
}

- (instancetype)initWithViewController:(UIViewController *)viewController{
    if (self = [super init]) {
        self.viewController = viewController;
        
        [self prepareGestureRecognizerInView:[viewController view]];
    }
    return self;
}

#pragma mark - accessor

- (void)setEnable:(BOOL)enable{
    self.panGestureRecognizer.enabled = enable;
}

- (BOOL)enable{
    return [[self panGestureRecognizer] isEnabled];
}

#pragma mark - protected

- (id<MDPercentDrivenInteractiveTransitioning>)requireInteractiveTransition;{
    return [UIPercentDrivenInteractiveTransition new];
}

- (void)prepareGestureRecognizerInView:(UIView*)view {
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
    self.panGestureRecognizer.delegate = self;
    [view addGestureRecognizer:[self panGestureRecognizer]];
}

#pragma mark - UIPanGestureRecognizer handlers

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[[self viewController] view]];
    CGPoint translation = [recognizer translationInView:[[self viewController] view]];
    CGPoint velocity = [recognizer velocityInView:[[self viewController] view]];
    
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        self.interactionInProgress = YES;
        // Create a interactive transition and pop the view controller
        self.interactiveTransition = [self requireInteractiveTransition];
        if ([self begin]) {
            self.begin([self interactiveTransition]);
        }
    } else if ([recognizer state] == UIGestureRecognizerStateChanged) {
        CGFloat progress = [self progress] ? self.progress(location, translation, velocity) : 1.f;
        progress = MIN(1.0, MAX(0.0, progress));
        // Update the interactive transition's progress
        if ([self update]) {
            self.update([self interactiveTransition], progress);
        }
        [[self interactiveTransition] updateInteractiveTransition:progress];
    } else if ([recognizer state] == UIGestureRecognizerStateEnded || [recognizer state] == UIGestureRecognizerStateCancelled) {
        CGFloat progress = [self progress] ? self.progress(location, translation, velocity) : 1.f;
        progress = MIN(1.0, MAX(0.0, progress));
        // Finish or cancel the interactive transition
        if (progress > 0.25) {
            [[self interactiveTransition] finishInteractiveTransition];
        } else {
            [[self interactiveTransition] cancelInteractiveTransition];
        }
        if ([self end]) {
            self.end([self interactiveTransition], progress > 0.25);
        }
        self.interactiveTransition = nil;
        self.interactionInProgress = NO;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[[self viewController] view]];
    CGPoint velocety = [recognizer velocityInView:[[self viewController] view]];
    
    return recognizer == [self panGestureRecognizer] && [self allowSwipe] && self.allowSwipe(location, velocety);
}

@end
