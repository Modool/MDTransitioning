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
#import "MDAnimatedTransitioning.h"

// The default presention animation controller base on MPresentionAnimatedTransitioning
@interface MDPresentionAnimationController : NSObject<MPresentionAnimatedTransitioning>

// The duration of animation, default is 0.25f.
@property (nonatomic, assign) NSTimeInterval duration; // Default is 0.25f.

/**
 The designated initializer. If you subclass MDNavigationAnimationController, you must call the super implementation of this
 method.
 
 @param presentionAnimatedOperation   presention controller operation, present or dismiss.
 @param fromViewController  view controller appearing.
 @param toViewController    view controller will be appearing.
 @return    an instance of MDPresentionAnimationController or sub class.
 */
- (instancetype)initWithPresentionAnimatedOperation:(MDPresentionAnimatedOperation)presentionAnimatedOperation fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;

- (instancetype)init DEPRECATED_MSG_ATTRIBUTE(" Use initWithOperation:fromViewController:toViewController: instead");

@end
