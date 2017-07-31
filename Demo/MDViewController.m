//
//  MDViewController.m
//  MDTransitioning
//
//  Created by Jave on 2017/7/26.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <MDTransitioning/MDTransitioning.h>
#import "MDViewController.h"
#import "MDPresentedViewController.h"

@interface MDViewController () <MDImageZoomViewControllerDelegate, UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MDViewController

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
    return [[[animator fromViewController] presentionInteractiveController] interactiveTransition];
}

@end
