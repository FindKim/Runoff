//
//  RunoffCityViewController.m
//  Runoff
//
//  Created by Kim Ngo on 2/1/14.
//  Copyright (c) 2014 EiE. All rights reserved.
//

#import "RunoffCityViewController.h"

@interface RunoffCityViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewCityGrid;
@property (nonatomic, strong) UIImage *cityImage; //_cityImage instance variable
@property (nonatomic, strong) UIImageView *cityImageView;

@end

@implementation RunoffCityViewController

//property builds an instance variable, a setter, a getter

-(UIImage *)cityImage
{
    if (!_cityImage) {
        _cityImage = [[UIImage alloc] init];
    }
    return _cityImage;
}

- (void)scrollViewSetUp {
    /*
     set image to image view
     set image view size to image
     set image view as subview of scroll view
     set bounds of scroll view to size of image
     set zoom limits
     */
    self.cityImage = [UIImage imageNamed:@"City1"];
    self.cityImageView = [[UIImageView alloc] initWithImage:self.cityImage];
    self.cityImageView.frame = CGRectMake(0, 0, self.cityImage.size.width, self.cityImage.size.height);
    // 320 scrollview width
    [self.scrollViewCityGrid addSubview:self.cityImageView];
    self.scrollViewCityGrid.contentSize = self.cityImageView.bounds.size;

    self.scrollViewCityGrid.minimumZoomScale = 1.0;
    self.scrollViewCityGrid.maximumZoomScale = 2.0; // twice its normal size
    self.scrollViewCityGrid.delegate = self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self scrollViewSetUp];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)sender {
  return self.cityImageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)sender withView:(UIView *)zoomView atScale:(CGFloat)scale {

}
- (IBAction)mapDoubleTap:(UITapGestureRecognizer *)sender {
    CGPoint mypoint = [sender locationInView:self.scrollViewCityGrid];
    //determines point at which the user double taps the screen
    NSLog(@"x = %f,y = %f", mypoint.x, mypoint.y);
    CGFloat scale = [self.scrollViewCityGrid zoomScale];
    //determines scale at which the user has zoomed
    NSLog(@"scale = %f", scale);
    CGPoint offset = [self.scrollViewCityGrid contentOffset];
    //determines the offset of the scrollView
    NSLog(@"offset x = %f, offset y = %f", offset.x, offset.y);
    float col = (8.0/1200.0)*(offset.y + scale*mypoint.y);
    float row = (8.0/1200.0)*(offset.x + scale*mypoint.x);
    NSLog(@"col = %f, row = %f", col, row);
    //Scale factor S
    //Iy = inset y
    //Ix = inset x
    //1200 points down and across
    //8 units down and across
    //column = (8/1200)(Iy + S*y)
    //row = (8/1200)(Ix + S*x)
}

@end
