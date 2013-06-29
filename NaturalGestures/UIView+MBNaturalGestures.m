//
//  UIView+MBNaturalGestures.m
//  NaturalGesturesExample
//
//  Created by Michael Berg on 29.06.13.
//  Copyright (c) 2013 Michael Berg. All rights reserved.
//

#import "UIView+MBNaturalGestures.h"
#import <objc/runtime.h>

static char MB_NATURAL_GESTURE_RECOGNIZER_VIEW_KEY;

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
    
    MBNaturalGestureHandler *handler = [[MBNaturalGestureHandler alloc] initWithView:self
                                                                          fromBounds:fromBounds
                                                                            toBounds:toBounds
                                                                          completion:completion];
    
    objc_setAssociatedObject(self, &MB_NATURAL_GESTURE_RECOGNIZER_VIEW_KEY, handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return handler;
}

- (MBNaturalGestureHandler *)naturalGestureHandler {
    return objc_getAssociatedObject(self, &MB_NATURAL_GESTURE_RECOGNIZER_VIEW_KEY);
}

- (void)removeNaturalGestureHandler {
    [self.naturalGestureHandler removeFromView:self];
    
    objc_setAssociatedObject(self, &MB_NATURAL_GESTURE_RECOGNIZER_VIEW_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
