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
}

@property (nonatomic, retain) UIGestureRecognizer *pan;
@property (nonatomic, retain) UIGestureRecognizer *rotate;
@property (nonatomic, retain) UIGestureRecognizer *pinch;

-(IBAction)handlePinch:(id)sender;
-(IBAction)handleRotation:(id)sender;
-(IBAction)handlePan:(id)sender;

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
        
        UIPinchGestureRecognizer *pinch     = [[UIPinchGestureRecognizer alloc]     initWithTarget:self action:@selector(handlePinch:)];
        UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc]  initWithTarget:self action:@selector(handleRotation:)];
        UIPanGestureRecognizer *pan         = [[UIPanGestureRecognizer alloc]       initWithTarget:self action:@selector(handlePan:)];
        
        pinch.delegate  = self;
        rotate.delegate = self;
        pan.delegate    = self;
        
        pan.minimumNumberOfTouches = 2;
        pan.maximumNumberOfTouches = 2;
        
        //Memory Management --> View should maintain the natural gesture handler until the view is destroyed
        objc_setAssociatedObject(view, &MB_NATURAL_GESTURE_RECOGNIZER_VIEW_KEY, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        self.targetView = view;
    }
    
    return self;
}

- (void)removeFromView:(UIView *)view {
    [view removeGestureRecognizer:self.pinch];
    [view removeGestureRecognizer:self.pan];
    [view removeGestureRecognizer:self.rotate];
    
    self.targetView = nil;
    
    objc_setAssociatedObject(view,              &MB_NATURAL_GESTURE_RECOGNIZER_VIEW_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setTargetView:(UIView *)targetView {
    //remove old connection
    objc_setAssociatedObject(self.targetView, &MB_NATURAL_GESTURE_TARGET_VIEW_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    _targetView = targetView;
    
    //assign new connection
    objc_setAssociatedObject(targetView, &MB_NATURAL_GESTURE_TARGET_VIEW_KEY, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
    CGFloat scale = MIN(MAX(pinchRecognizer.scale - 0.4f,0.0f) / 0.6f,1.0f);
    
    switch (pinchRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            //check if the recognizer is moving from big to small bounds or vica versa
            if (CGRectEqualToRect(self.targetView.bounds, _smallBounds)) {
                pinchRecognizer.scale = 0.0;
            }
            
            if (self.gestureWillStartBlock) {
                self.gestureWillStartBlock();
            }
        }   break;
        case UIGestureRecognizerStateChanged:
        {
            if (self.scaleDidChangeBlock) {
                self.scaleDidChangeBlock(scale);
            }
            
            self.targetView.bounds   = MB_CGRectInterpolation(_bigBounds, _smallBounds, scale);
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

inline BOOL    MB_CGRectIsGreaterThanRect(CGRect rect1, CGRect rect2) {
    return (rect1.size.height + rect1.size.width) > (rect2.size.height + rect2.size.width);
}

inline CGRect MB_CGRectInterpolation(CGRect rect1, CGRect rect2, CGFloat percentage) {
    CGRect interpolatedRect      = CGRectZero;
    
    interpolatedRect.origin.x    = ((rect1.origin.x     - rect2.origin.x)       * (percentage)) + rect2.origin.x;
    interpolatedRect.origin.y    = ((rect1.origin.y     - rect2.origin.y)       * (percentage)) + rect2.origin.y;
    interpolatedRect.size.width  = ((rect1.size.width   - rect2.size.width)     * (percentage)) + rect2.size.width;
    interpolatedRect.size.height = ((rect1.size.height  - rect2.size.height)    * (percentage)) + rect2.size.height;
    
    return interpolatedRect;
}

inline CGPoint MB_CGPointAddPoint(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}

@end
