//
//  RunoffCityViewController.m
//  Runoff
//
//  Created by Kim Ngo on 2/1/14.
//  Copyright (c) 2014 EiE. All rights reserved.
//

#import "RunoffCityViewController.h"

@interface RunoffCityViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewCityGrid;

@end

@implementation RunoffCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self scrollViewSetUp];
}


//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)sender {
//    
//}


- (void)scrollViewSetUp {
 /*
  set image to image view
  set image view size to image
  set image view as subview of scroll view
  set bounds of scroll view to size of image
  set zoom limits
  */
    UIImage * cityImage = [UIImage imageNamed:@"City1"];
    UIImageView *cityImageView = [[UIImageView alloc] initWithImage:cityImage];
    cityImageView.frame = CGRectMake(0, 0, cityImage.size.width, cityImage.size.height);
    [self.scrollViewCityGrid addSubview:cityImageView];

    
    self.scrollViewCityGrid.contentSize = cityImageView.frame.size;
    self.scrollViewCityGrid.minimumZoomScale = 0.5; // 0.5 means half its normal size
    self.scrollViewCityGrid.maximumZoomScale = 2.0; // 2.0 means twice its normal size
}

//- (void)scrollViewDidEndZooming:(UIScrollView *)sender
 //                      withView:(UIView *)zoomView // from delegate method above
 //                       atScale:(CGFloat)scale;

@end
