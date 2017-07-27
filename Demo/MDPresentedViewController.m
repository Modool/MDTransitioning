//
//  MDPresentedViewController.m
//  MDTransitioning
//
//  Created by Jave on 2017/7/26.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDPresentedViewController.h"

@interface MDPresentedViewController ()

@end

@implementation MDPresentedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [dismissButton setTitle:@"dismiss" forState:UIControlStateNormal];
    [dismissButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [dismissButton addTarget:self action:@selector(didClickDismiss:) forControlEvents:UIControlEventTouchUpInside];
    
    [[self view] addSubview:dismissButton];
}

#pragma mark - actions

- (IBAction)didClickDismiss:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
