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
#import "MDPresentionControlViewController.h"
#import "MDPresentedViewController.h"
#import "MDCustomImageViewController.h"

@interface MDPresentionControlViewController () <MDImageZoomViewControllerDelegate, UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MDPresentionControlViewController

- (instancetype)init{
    if (self = [super init]) {
        self.allowPopInteractive = NO;
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    self.view.backgroundColor = [UIColor brownColor];
}

#pragma mark - actions

- (IBAction)didClickImageButton:(id)sender {
//    MDCustomImageViewController *imageViewController = [[MDCustomImageViewController alloc] initWithImage:[[self imageView] image]];
    
    MDImageViewController *imageViewController = [[MDImageViewController alloc] initWithImage:[[self imageView] image]];
    imageViewController.transitioningDelegate = [MDPresentionControllerDelegate delegateWithReferenceViewController:self];
    
    [self presentViewController:imageViewController animated:YES completion:nil];
}

- (IBAction)didClickPresent:(id)sender {
    MDPresentedViewController *presentViewController = [MDPresentedViewController new];
    presentViewController.transitioningDelegate = [MDPresentionControllerDelegate delegateWithReferenceViewController:self];
    
    [self presentViewController:presentViewController animated:YES completion:nil];
}

@end
