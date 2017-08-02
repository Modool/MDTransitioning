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

#import "MDAnimatedTransitioning.h"
#import "MDInteractiveTransitioning.h"

// This is navigation controller with pop interaction, contain an interaction controler
// and animation provider.
@protocol MDNavigationPopController <NSObject>

// Snapshot is created before view controller is disappearing.
@property (nonatomic, strong) UIView *snapshot;

// Interaction controller control both geture and transitioning progress.
@property (nonatomic, strong) id<MDInteractionController> interactionController;

// The interaction controller is invalid if it's NO, default is YES.
@property (nonatomic, assign) BOOL allowPopInteractive;

// Needs to provide an interaction controller without inner control if it's YES,
// and needs to control outside gesture, default is NO.
@property (nonatomic, assign) BOOL allowCustomPopInteractive;

/**
 Require an pop interaction controller.

 @return an instance base on protocol MDInteractionController, default is MDPopInteractionController.
 */
- (id<MDInteractionController>)requirePopInteractionController;

/**
 Provide an navigation transitioning, ignored push interaction.

 @param operation   navigation controller operation, push or pop.
 @param fromViewController  view controller appearing.
 @param toViewController    view controller will be appearing.
 @return    an instance of animated transitioning, default is MDNavigationAnimationController.
 */
- (id<MDNavigationAnimatedTransitioning>)animationForNavigationOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;

@end

// This is presention controller with present or dismiss interaction,
// also contain an interaction controler and animation provider.
@protocol MDPresentionController <NSObject>

// Interaction controller control both geture and transitioning progress.
@property (nonatomic, strong) id<MDInteractionController> presentionInteractionController;

/**
 Provide an presention transitioning.
 
 @param operation   presention controller operation, presnt or dismiss.
 @param fromViewController  view controller appearing.
 @param toViewController    view controller will be appearing.
 @return    an instance of animated transitioning, default is MDPresentionAnimationController.
 */
- (id<MPresentionAnimatedTransitioning>)animationForPresentionOperation:(MDPresentionAnimatedOperation)operation fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;

@end

// This is interaction controller control, control interaction of gesture
// and progress of interactive transition, the gesture will be added in view of view controller,
// Needs to care conflict for gestures if overrides.
@protocol MDInteractionController <NSObject>

// The view controller with gesture.
@property (nonatomic, weak, readonly) UIViewController *viewController;

// The interactive transition, control progress animation.
@property (nonatomic, strong, readonly) id<MDPercentDrivenInteractiveTransitioning> interactiveTransition;

// The current interaction state.
@property (nonatomic, assign, readonly) BOOL interactionInProgress;

// To control ability of gesture.
@property (nonatomic, assign) BOOL enable;

// To control ability of gesture dynamic.
@property (nonatomic, copy) CGFloat (^allowSwipe)(CGPoint location, CGPoint velocity);

// To provide progress with location, translation and velocity.
@property (nonatomic, copy) CGFloat (^progress)(CGPoint location, CGPoint translation, CGPoint velocity);

// It be called after begginning of gesture.
@property (nonatomic, copy) void (^begin)(); // Default is called requireInteractiveTransition.

// It be called after end of gesture.
@property (nonatomic, copy) void (^end)(id<MDPercentDrivenInteractiveTransitioning> interactiveTransition, BOOL finished);

// It be called after updating progress of gesture.
@property (nonatomic, copy) void (^update)(id<MDPercentDrivenInteractiveTransitioning> interactiveTransition, CGFloat progress);

/**
 Require an interactive transition base on percent driven.
 
 @return an instance base on protocol MDPercentDrivenInteractiveTransitioning, default is UIPercentDrivenInteractiveTransition.
 */
- (id<MDPercentDrivenInteractiveTransitioning>)requireInteractiveTransition;

+ (instancetype)interactionControllerWithViewController:(UIViewController *)viewController;
- (instancetype)initWithViewController:(UIViewController *)viewController;

@end
