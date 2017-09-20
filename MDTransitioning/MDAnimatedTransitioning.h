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

#import <UIKit/UIKit.h>

@protocol MDInteractionController;

// This is baseic protocol of animated transitioning, extend to access view controllers in transition view.
@protocol MDPresentionControlViewControllerAnimatedTransitioning<UIViewControllerAnimatedTransitioning>

// Access appearing view controller in transition view.
@property (nonatomic, weak, readonly) UIViewController *fromViewController;

// Access view controller will be appearing in transition view.
@property (nonatomic, weak, readonly) UIViewController *toViewController;

@end

// This is navigation transitioning protocol, extend to access operation.
@protocol MDNavigationAnimatedTransitioning <MDPresentionControlViewControllerAnimatedTransitioning>

// Access operation, push or pop.
@property (nonatomic, assign, readonly) UINavigationControllerOperation operation;

@end

// Enum of presention operations, present and dismiss.
typedef NS_ENUM(NSInteger, MDPresentionAnimatedOperation) {
    MDPresentionAnimatedOperationNone,
    MDPresentionAnimatedOperationPresent,
    MDPresentionAnimatedOperationDismiss,
};

// This is presention transitioning protocol, extend to access operation.
@protocol MPresentionAnimatedTransitioning <MDPresentionControlViewControllerAnimatedTransitioning>

// Access operation, present or dismiss.
@property (nonatomic, assign, readonly) MDPresentionAnimatedOperation operation;

@end


