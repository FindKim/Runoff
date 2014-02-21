//
//  RunoffCityViewController.h
//  Runoff
//
//  Created by Kim Ngo on 2/1/14.
//  Copyright (c) 2014 EiE. All rights reserved.
//
//Delete This Comment Please

#import <UIKit/UIKit.h>

@interface RunoffCityViewController : UIViewController

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)sender;

- (void)scrollViewDidEndZooming:(UIScrollView *)sender withView:(UIView *)zoomView
                        atScale:(CGFloat)scale;

@end
