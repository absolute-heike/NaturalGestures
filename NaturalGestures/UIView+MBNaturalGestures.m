//
//  UIView+MBNaturalGestures.m
//  NaturalGesturesExample
//
//  Created by Michael Berg on 29.06.13.
//  Copyright (c) 2013 Michael Berg. All rights reserved.
//

#import "UIView+MBNaturalGestures.h"
#import <objc/runtime.h>

@implementation UIView (MBNaturalGestures)

-(MBNaturalGestureHandler *)addNaturalGesturesWithFromBounds:(CGRect)fromBounds
                                                    toBounds:(CGRect)toBounds
                                                  completion:(void (^)(BOOL))completion {
    if (self.naturalGestureHandler) {
        //reuse existing gestureHandler
        MBNaturalGestureHandler *naturalGestureHandler  = self.naturalGestureHandler;
        
        [naturalGestureHandler setFromBounds:fromBounds toBounds:toBounds];
        naturalGestureHandler.completion                = completion;
        naturalGestureHandler.gestureWillStartBlock     = nil;
        naturalGestureHandler.scaleDidChangeBlock       = nil;
        
        return naturalGestureHandler;
    }
    
    return [[MBNaturalGestureHandler alloc] initWithView:self
                                             startBounds:fromBounds
                                               endBounds:toBounds
                                              completion:completion];
}

- (MBNaturalGestureHandler *)naturalGestureHandler {
    return objc_getAssociatedObject(self, &MB_NATURAL_GESTURE_TARGET_VIEW_KEY);
}

- (void)removeNaturalGestureHandler {
    [self.naturalGestureHandler removeFromView:self];
}

@end
