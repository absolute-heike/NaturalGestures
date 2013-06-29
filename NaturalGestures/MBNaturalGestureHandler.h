//
//  MBNaturalGestureHandler.h
//  NaturalGesturesExample
//
//  Created by Michael Berg on 29.06.13.
//  Copyright (c) 2013 Michael Berg. All rights reserved.
//

#import <Foundation/Foundation.h>

static char MB_NATURAL_GESTURE_RECOGNIZER_VIEW_KEY;
static char MB_NATURAL_GESTURE_TARGET_VIEW_KEY;

@interface MBNaturalGestureHandler : NSObject <UIGestureRecognizerDelegate>

//gestureWillStartBlock: invoked, when the gesture recognizer starts recognizing
@property (nonatomic, copy)     void(^gestureWillStartBlock)(void);

//scaleDidChangeBlock: invoked, everytime the scale if changing
@property (nonatomic, copy)     void(^scaleDidChangeBlock)(CGFloat scale);

//completion: invoked, when the gesture recognizers stop recognizing
@property (nonatomic, copy)     void(^completion)(BOOL shouldClose);

//targetView: the view, that is moved by the gesture handler. by default the view, that the recognizers are added to
@property (nonatomic, assign)   UIView *targetView;

@property (nonatomic, readonly) CGRect smallBounds;
@property (nonatomic, readonly) CGRect bigBounds;

- (id)initWithView:(UIView *)view fromBounds:(CGRect)fromBounds toBounds:(CGRect)toBounds completion:(void (^)(BOOL shouldClose))completion;
- (void)removeFromView:(UIView *)view;
- (void)setFromBounds:(CGRect)fromBounds toBounds:(CGRect)toBounds;

//for autocompletion ;-)
-(void)setGestureWillStartBlock:(void (^)(void))gestureWillStartBlock;
-(void)setScaleDidChangeBlock:(void (^)(CGFloat scale))scaleDidChangeBlock;

@end
