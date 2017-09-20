//
//  MDVerticalSwipPopViewController.m
//  Demo
//
//  Created by 徐 林峰 on 2017/9/21.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <MDTransitioning/MDTransitioning.h>
#import "MDVerticalSwipPopViewController.h"
#import "MDVerticalSwipPopInteractionController.h"

@interface MDVerticalSwipPopViewController ()

@end

@implementation MDVerticalSwipPopViewController

- (void)loadView{
    [super loadView];
    
    self.view.backgroundColor = [UIColor greenColor];
}

- (id<MDInteractionController>)requirePopInteractionController{
    return [MDVerticalSwipPopInteractionController interactionControllerWithViewController:self];
}

@end
