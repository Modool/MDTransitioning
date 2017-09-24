//
//  MDRootViewController.m
//  Demo
//
//  Created by 徐 林峰 on 2017/9/21.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <MDTransitioning/MDTransitioning.h>
#import "MDRootViewController.h"
#import "MDCustomViewController.h"
#import "MDPresentionControlViewController.h"
#import "MDVerticalSwipPopViewController.h"

@interface MDRootViewController ()

@end

@implementation MDRootViewController

- (void)loadView{
    [super loadView];
    
    self.view.backgroundColor = [UIColor yellowColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickSystemPush:(id)sender {
    MDPresentionControlViewController * presentControlViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MDPresentionControlViewController"];
    
    self.navigationController.delegate = nil;
    [[self navigationController] pushViewController:presentControlViewController animated:YES];
}

- (IBAction)didClickNormalPush:(id)sender {
    MDRootViewController *viewController = [MDRootViewController new];
    
    self.navigationController.allowPushAnimation = YES;
    self.navigationController.delegate = [MDNavigationControllerDelegate defaultDelegate];
    
    [[self navigationController] pushViewController:viewController animated:YES];
}

- (IBAction)didClickScalePush:(id)sender {
    MDCustomViewController *viewController = [MDCustomViewController new];
    
    self.navigationController.allowPushAnimation = YES;
    self.navigationController.delegate = [MDNavigationControllerDelegate defaultDelegate];
    
    [[self navigationController] pushViewController:viewController animated:YES];
}

- (IBAction)didClickVerticalPush:(id)sender {
    MDVerticalSwipPopViewController *viewController = [MDVerticalSwipPopViewController new];
    
    self.navigationController.allowPushAnimation = YES;
    self.navigationController.delegate = [MDNavigationControllerDelegate defaultDelegate];
    
    [[self navigationController] pushViewController:viewController animated:YES];
}

@end
