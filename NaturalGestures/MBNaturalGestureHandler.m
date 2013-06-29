//
//  MBNaturalGestureHandler.m
//  NaturalGesturesExample
//
//  Created by Michael Berg on 29.06.13.
//  Copyright (c) 2013 Michael Berg. All rights reserved.
//

#import "MBNaturalGestureHandler.h"
#import <objc/runtime.h>

@interface MBNaturalGestureHandler () {
    CGPoint _startCenterPoint;
    
    CGFloat _direction;
}

@property (nonatomic, retain) UIGestureRecognizer *pan;
@property (nonatomic, retain) UIGestureRecognizer *rotate;
@property (nonatomic, retain) UIGestureRecognizer *pinch;

-(IBAction)handlePinch:(id)sender;
-(IBAction)handleRotation:(id)sender;
-(IBAction)handlePan:(id)sender;

extern inline BOOL    MB_CGRectIsGreaterThanRect(CGRect rect1, CGRect rect2);
extern inline CGPoint MB_CGPointAddPoint(CGPoint point1, CGPoint point2);
extern inline CGRect  MB_CGRectInterpolation(CGRect rect1, CGRect rect2, CGFloat percentage);

@end


@implementation MBNaturalGestureHandler

- (void)dealloc
{
    self.completion = nil;
    self.scaleDidChangeBlock = nil;
    self.gestureWillStartBlock = nil;
    
    self.pan = nil;
    self.rotate = nil;
    self.pinch = nil;
}

-(id)initWithView:(UIView *)view
       fromBounds:(CGRect)fromBounds
         toBounds:(CGRect)toBounds
       completion:(void (^)(BOOL))completion {
    self = [super init];
    
    if (self) {
        [self setFromBounds:fromBounds toBounds:toBounds];
        
        self.completion = completion;
        
        UIPinchGestureRecognizer    *pinch  = [[UIPinchGestureRecognizer alloc]     initWithTarget:self action:@selector(handlePinch:)];
        UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc]  initWithTarget:self action:@selector(handleRotation:)];
        UIPanGestureRecognizer      *pan    = [[UIPanGestureRecognizer alloc]       initWithTarget:self action:@selector(handlePan:)];
        
        pinch.delegate  = self;
        rotate.delegate = self;
        pan.delegate    = self;
        
        pan.minimumNumberOfTouches = 2;
        pan.maximumNumberOfTouches = 2;
        
        [view addGestureRecognizer:pinch];
        [view addGestureRecognizer:rotate];
        [view addGestureRecognizer:pan];
        
        self.targetView = view;
        
        self.pinch      = pinch;
        self.rotate     = rotate;
        self.pan        = pan;
    }
    
    return self;
}

- (void)removeFromView:(UIView *)view {
    [view removeGestureRecognizer:self.pinch];
    [view removeGestureRecognizer:self.pan];
    [view removeGestureRecognizer:self.rotate];
    
    self.targetView = nil;
}

- (void)setFromBounds:(CGRect)fromBounds toBounds:(CGRect)toBounds {
    if(MB_CGRectIsGreaterThanRect(fromBounds, toBounds)){
        _bigBounds      = fromBounds;
        _smallBounds    = toBounds;
    }else {
        _bigBounds      = toBounds;
        _smallBounds    = fromBounds;
    }
}


#pragma mark - Gesture Recognition

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer.view == otherGestureRecognizer.view){
        return YES;
    }
    
    return NO;
}

-(IBAction)handlePinch:(UIPinchGestureRecognizer *)pinchRecognizer {
    CGFloat scale = MIN(MAX((pinchRecognizer.scale - _direction) - 0.4f,0.0f) / 0.6f,1.0f);
    
    switch (pinchRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            //check if the recognizer is moving from big to small bounds or vica versa
            if (CGRectEqualToRect(self.targetView.bounds, _smallBounds)) {
                _direction = 1.0;
            }else {
                _direction = 0.0;
            }
            
            if (self.gestureWillStartBlock) {
                self.gestureWillStartBlock();
            }
        }   break;
        case UIGestureRecognizerStateChanged:
        {
            self.targetView.bounds   = MB_CGRectInterpolation(_bigBounds, _smallBounds, scale);
            
            if (self.scaleDidChangeBlock) {
                self.scaleDidChangeBlock(scale);
            }
        }   break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            BOOL shouldClose = TRUE;
            
            if (
                (ABS(pinchRecognizer.velocity) < 200) &&
                scale > 0.5
                ) {
                shouldClose = FALSE;
            }else if (pinchRecognizer.velocity > 0.0f) {
                shouldClose = FALSE;
            }
            
            if (self.completion) {
                self.completion(shouldClose);
            }
        }   break;
        default:
            break;
    }
}

-(IBAction)handleRotation:(UIRotationGestureRecognizer *)rotationRecognizer {
    if (rotationRecognizer.state == UIGestureRecognizerStateChanged) {
        self.targetView.transform = CGAffineTransformMakeRotation(rotationRecognizer.rotation);
    }
}

-(IBAction)handlePan:(UIPanGestureRecognizer *)panRecognizer {
    switch (panRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            _startCenterPoint           = panRecognizer.view.center;
            break;
        case UIGestureRecognizerStateChanged:
        {
            self.targetView.center      = MB_CGPointAddPoint(_startCenterPoint, [panRecognizer translationInView:panRecognizer.view.superview]);
        }   break;
        default:
            break;
    }
}


#pragma mark - Geometry

extern inline BOOL    MB_CGRectIsGreaterThanRect(CGRect rect1, CGRect rect2) {
    return (rect1.size.height + rect1.size.width) > (rect2.size.height + rect2.size.width);
}

extern inline CGRect MB_CGRectInterpolation(CGRect rect1, CGRect rect2, CGFloat percentage) {
    CGRect interpolatedRect      = CGRectZero;
    
    interpolatedRect.origin.x    = ((rect1.origin.x     - rect2.origin.x)       * (percentage)) + rect2.origin.x;
    interpolatedRect.origin.y    = ((rect1.origin.y     - rect2.origin.y)       * (percentage)) + rect2.origin.y;
    interpolatedRect.size.width  = ((rect1.size.width   - rect2.size.width)     * (percentage)) + rect2.size.width;
    interpolatedRect.size.height = ((rect1.size.height  - rect2.size.height)    * (percentage)) + rect2.size.height;
    
    return interpolatedRect;
}

extern inline CGPoint MB_CGPointAddPoint(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}

@end
