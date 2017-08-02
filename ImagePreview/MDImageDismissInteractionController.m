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

#import "MDImageDismissInteractionController.h"
#import "MDImageZoomAnimationController.h"

@implementation MDImageDismissInteractionController

- (instancetype)initWithViewController:(UIViewController<MDImageContainerViewControllerDelegate> *)viewController{
    if (self = [super initWithViewController:viewController]) {
        NSParameterAssert([viewController conformsToProtocol:@protocol(MDImageContainerViewControllerDelegate)]);
        
        __block __weak id weak_self = self;
        self.translation = CGRectGetWidth([[viewController view] bounds]) / 3.;
        self.begin = ^{
            [viewController dismissViewControllerAnimated:YES completion:nil];
        };
        self.allowSwipe = ^CGFloat(CGPoint location, CGPoint velocity) {
            return [[viewController scrollView] zoomScale] <= [[viewController scrollView] minimumZoomScale] && velocity.y > 0;
        };
        self.progress = ^CGFloat(CGPoint location, CGPoint translation, CGPoint velocity) {
            CGFloat distance = sqrt(pow(translation.x, 2) + pow(translation.y, 2));
            return  distance / [weak_self translation];
        };
    }
    return self;
}

@end
