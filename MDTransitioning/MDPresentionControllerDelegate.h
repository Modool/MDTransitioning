//
//  MDPresentionControllerDelegate.h
//  MDTransitioning
//
//  Created by 徐 林峰 on 2017/9/20.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDPresentionControllerDelegate : NSObject<UIViewControllerTransitioningDelegate>

@property (nonatomic, weak, readonly) UIViewController *referenceViewController;

+ (instancetype)delegateWithReferenceViewController:(UIViewController *)viewController;

@end
