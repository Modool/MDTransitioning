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
#import <MDTransitioning_ImagePriview/MDTransitioning+ImagePreview.h>
#import "MDViewController.h"
#import "MDPresentedViewController.h"

@interface MDViewController () <MDImageZoomViewControllerDelegate, UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MDViewController

- (instancetype)init{
    if (self = [super init]) {
        self.allowPopInteractive = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - actions

- (IBAction)didClickImageButton:(id)sender {
    MDImageViewController *imageViewController = [[MDImageViewController alloc] initWithImage:[[self imageView] image]];
    imageViewController.transitioningDelegate = self;
    
    [self presentViewController:imageViewController animated:YES completion:nil];
}

- (IBAction)didClickPresent:(id)sender {
    MDPresentedViewController *presentViewController = [MDPresentedViewController new];
    presentViewController.transitioningDelegate = self;
    
    [self presentViewController:presentViewController animated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(MDImageViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [presented animationForPresentionOperation:MDPresentionAnimatedOperationPresent fromViewController:self toViewController:presented];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(MDImageViewController *)dismissed {
    return [dismissed animationForPresentionOperation:MDPresentionAnimatedOperationDismiss fromViewController:dismissed toViewController:self];
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<MDViewControllerAnimatedTransitioning>)animator;{
    return [[[animator fromViewController] presentionInteractionController] interactiveTransition];
}


@end
