//
//  MDNavigationControllerDelegate.h
//  MDTransitioning
//
//  Created by Jave on 2017/7/26.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>

// The default delegate of UINavigationControllerDelegate, to provide default implementation.
@interface MDNavigationControllerDelegate : NSObject<UINavigationControllerDelegate>

+ (instancetype)defaultDelegate;

@end
