//
//  MDTransitioning+Private.h
//  MDTransitioning
//
//  Created by Jave on 2017/7/31.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

extern void MDTransitioningMethodSwizzle(Class class, SEL origSel, SEL altSel);
