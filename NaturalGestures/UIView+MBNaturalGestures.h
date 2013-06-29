//
//  UIView+MBNaturalGestures.h
//  NaturalGesturesExample
//
//  Created by Michael Berg on 29.06.13.
//  Copyright (c) 2013 Michael Berg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBNaturalGestureHandler.h"


@interface UIView (MBNaturalGestures)

- (MBNaturalGestureHandler *)addNaturalGesturesWithFromBounds:(CGRect)fromBounds toBounds:(CGRect)toBounds completion:(void (^)(BOOL shouldClose))completion;
- (MBNaturalGestureHandler *)naturalGestureHandler;
- (void)removeNaturalGestureHandler;

@end
