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

#import <MDTransitioning/MDTransitioning.h>

// Image zoom custom transition.
@interface MDImageZoomAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

// The image view that will be used as the source (zoom in) or destination
// (zoom out) of the transition.
@property (nonatomic, weak, readonly) UIImageView *referenceImageView;

@property (nonatomic, assign) BOOL hideReferenceImageViewWhenZoomIn; // Default is YES.

// Initializes the receiver with the specified reference image view to other image view.
- (instancetype)initWithReferenceImageView:(UIImageView *)referenceImageView;

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

+ (id<MPresentionAnimatedTransitioning>)animationForPresentOperation:(MDPresentionAnimatedOperation)presentionAnimatedOperation fromViewController:(UIViewController<MDImageZoomViewControllerDelegate> *)fromViewController toViewController:(UIViewController<MDImageZoomViewControllerDelegate> *)toViewController;

- (instancetype)initWithPresentionAnimatedOperation:(MDPresentionAnimatedOperation)presentionAnimatedOperation fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;

@end
