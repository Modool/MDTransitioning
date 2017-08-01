//
//  MDSwipeInteractionController.m
//  MDTransitioning
//
//  Created by Jave on 2017/7/26.
//  Copyright © 2017年 markejave. All rights reserved.
//

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
