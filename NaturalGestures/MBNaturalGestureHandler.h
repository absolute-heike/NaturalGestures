//
//  MBNaturalGestureHandler.h
//  NaturalGesturesExample
//
//  Created by Michael Berg on 29.06.13.
//  Copyright (c) 2013 Michael Berg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBNaturalGestureHandler : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, copy)     void(^gestureWillStartBlock)(void);
@property (nonatomic, copy)     void(^scaleDidChangeBlock)(CGFloat scale);

//the view, that is moved by the gesture handler. by default the view, that the recognizers are added to
@property (nonatomic, assign)   UIView *targetView;

- (id)initWithView:(UIView *)view startBounds:(CGRect)startBounds endBounds:(CGRect)endBounds completion:(void (^)(BOOL shouldClose))completion;

//for autocompletion ;-)
-(void)setGestureWillStartBlock:(void (^)(void))gestureWillStartBlock;
-(void)setScaleDidChangeBlock:(void (^)(CGFloat scale))scaleDidChangeBlock;

@end
