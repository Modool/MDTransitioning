//  MDImageZoomAnimationController.h
//  MDTransitioning
//
//  Created by Jave on 2017/7/25.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDAnimatedTransitioning.h"
#import "MDSwipeInteractionController.h"

// Image zoom custom transition.
@interface MDImageZoomAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

// The image view that will be used as the source (zoom in) or destination
// (zoom out) of the transition.
@property (nonatomic, weak, readonly) UIImageView *referenceImageView;

@property (nonatomic, assign) BOOL hideReferenceImageViewWhenZoomIn; // Default is YES.

// Initializes the receiver with the specified reference image view to other image view.
- (id)initWithReferenceImageView:(UIImageView *)referenceImageView;

@end

// Support MPresentionAnimatedTransitioning
@protocol MDImageZoomViewControllerDelegate <NSObject>

@property (nonatomic, weak, readonly) UIImageView *imageView;

@end

@protocol MDImageContainerViewControllerDelegate <MDImageZoomViewControllerDelegate>

@property (nonatomic, weak, readonly) UIView *backgroundView;
@property (nonatomic, weak, readonly) UIScrollView *scrollView;

@end

@interface MDImageZoomAnimationController (MPresentionAnimatedTransitioning)<MPresentionAnimatedTransitioning>

+ (id<MPresentionAnimatedTransitioning>)animationForPresentOperation:(MDPresentionAnimatedOperation)operation fromViewController:(UIViewController<MDImageZoomViewControllerDelegate> *)fromViewController toViewController:(UIViewController<MDImageZoomViewControllerDelegate> *)toViewController;

@end
