//
//  MDTransitioning+Private.m
//  MDTransitioning
//
//  Created by Jave on 2017/7/31.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDTransitioning+Private.h"

void MDTransitioningMethodSwizzle(Class class, SEL origSel, SEL altSel) {
    Method origMethod = class_getInstanceMethod(class, origSel);
    Method altMethod = class_getInstanceMethod(class, altSel);
    
    class_addMethod(class, origSel, class_getMethodImplementation(class, origSel), method_getTypeEncoding(origMethod));
    class_addMethod(class, altSel, class_getMethodImplementation(class, altSel), method_getTypeEncoding(altMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(class, origSel), class_getInstanceMethod(class, altSel));
}
