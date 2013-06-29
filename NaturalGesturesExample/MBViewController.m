//
//  MBViewController.m
//  NaturalGesturesExample
//
//  Created by Michael Berg on 29.06.13.
//  Copyright (c) 2013 Michael Berg. All rights reserved.
//

#import "MBViewController.h"
#import "MBNaturalGestures.h"
#import <QuartzCore/QuartzCore.h>


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
    
    //UI Stuff
    self.smallView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.bigView.layer.borderColor   = [UIColor darkGrayColor].CGColor;
    
    self.smallView.layer.borderWidth = 1.0;
    self.bigView.layer.borderWidth   = 1.0f;
	
    //Setup Gestures
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
        
        wself.smallView.backgroundColor = [UIColor colorWithWhite:0.66 alpha:1.0-scale];
        wself.bigView.backgroundColor   = [UIColor colorWithWhite:0.66 alpha:scale];
    }];
}


@end
