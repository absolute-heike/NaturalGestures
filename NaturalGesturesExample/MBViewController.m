//
//  MBViewController.m
//  NaturalGesturesExample
//
//  Created by Michael Berg on 29.06.13.
//  Copyright (c) 2013 Michael Berg. All rights reserved.
//

#import "MBViewController.h"
#import "MBNaturalGestures.h"


@interface MBViewController ()

@property (nonatomic, weak) IBOutlet UILabel *progressLabel;

@property (nonatomic, weak) IBOutlet UIView *smallView;
@property (nonatomic, weak) IBOutlet UIView *bigView;

@property (nonatomic, weak) IBOutlet UIView *imageView;
@end


@implementation MBViewController


- (void)dealloc
{
    NSLog(@"huhu");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    __weak MBViewController *wself = self;
    
    [self.imageView addNaturalGesturesWithFromBounds:self.bigView.bounds toBounds:self.smallView.bounds completion:^(BOOL shouldClose) {
        CGRect toFrame = shouldClose ? wself.smallView.frame : wself.bigView.frame;
        
        [UIView animateWithDuration:0.3 animations:^{
            wself.imageView.transform = CGAffineTransformIdentity;
            wself.imageView.frame     = toFrame;
        }];
        
        wself.progressLabel.text      = nil;
    }];
    
    [self.imageView.naturalGestureHandler setScaleDidChangeBlock:^(CGFloat scale) {
        wself.progressLabel.text = [NSString stringWithFormat:@"%.0f%%",scale * 100.0];
        
        wself.smallView.alpha    = 1.0-scale;
        wself.bigView.alpha      = scale;
    }];
}


@end
