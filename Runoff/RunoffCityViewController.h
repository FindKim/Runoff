//
//  RunoffCityViewController.h
//  Runoff
//
//  Created by Kim Ngo on 2/1/14.
//  Copyright (c) 2014 EiE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RunoffCityViewController : UIViewController
@property (nonatomic, strong) NSString * dataFileName;

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)sender;

- (void)scrollViewDidEndZooming:(UIScrollView *)sender withView:(UIView *)zoomView
                        atScale:(CGFloat)scale;

@end
