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
@property (nonatomic, strong) UIView *container;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic) int biofilterCount;
//@property (nonatomic, strong) NSArray *biofilterArray;
//@property (nonatomic, strong) UIImage *biofilterImage;


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
    self.cityImageView.frame = CGRectMake(0, 0, self.scrollViewCityGrid.bounds.size.width, self.scrollViewCityGrid.bounds.size.width);
        // 320 = width of scrollView
        // 320 = height of image (square)
    self.container = [[UIView alloc] initWithFrame:self.cityImageView.frame];
    // 320 scrollview width
    [self.scrollViewCityGrid addSubview:self.container];
    [self.container addSubview:self.cityImageView];
    self.scrollViewCityGrid.contentSize = self.container.bounds.size;

    self.scrollViewCityGrid.minimumZoomScale = 1.0;
    self.scrollViewCityGrid.maximumZoomScale = 4.0; // twice its normal size
    self.scrollViewCityGrid.delegate = self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self scrollViewSetUp];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)sender {
    return self.container;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)sender withView:(UIView *)zoomView atScale:(CGFloat)scale {
}

- (void)setBiofilterImage:(UIImage *)biofilterImage {
    self.biofilterImage = [UIImage imageNamed:@"Biofilter"];
}

//- (void)setBiofilterArray:(NSArray *)biofilterArray {
//    self.biofilterArray = [NSArray arrayWithObjects:
//                            [UIImage imageNamed:@"Biofilter"],
//                            [UIImage imageNamed:@"Biofilter"],
//                            [UIImage imageNamed:@"Biofilter"],
//                            nil];
//}


- (void)placeBiofilterAtPoint:(CGPoint)mypoint{
    UIImage * biofilterImage = [UIImage imageNamed:@"Biofilter"];
    UIImageView * biofilterView = [[UIImageView alloc] initWithImage:biofilterImage];
    [self.container addSubview:biofilterView];
    biofilterView.frame = CGRectMake(mypoint.x, mypoint.y, 20, 20);
    biofilterView.center = mypoint;
    // trying to make image recognize touch gestures to double tap to remove image
//    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureCaptured:)];
//    [biofilterView addGestureRecognizer:doubleTap];
//    [biofilterView setMultipleTouchEnabled:YES];
//    [biofilterView setUserInteractionEnabled:YES];
}
/*
- (void)doubleTapGestureCaptured:(UITapGestureRecognizer *)gesture {
    self.biofilterView = [gesture.view hitTest:gesture locationInView:gesture.view withEvent:nil];
}
*/
- (void)setBiofilterCount:(int)biofilterCount {
    _biofilterCount = biofilterCount;
    self.countLabel.text = [NSString stringWithFormat:@"count: %d", self.biofilterCount];
}


- (BOOL) point:(CGPoint) pt isonRect:(CGRect)rpt {
    if (pt.x >= rpt.origin.x && pt.x <= rpt.size.width + rpt.origin.x) {
        // within x bounds
        if (pt.y >= rpt.origin.y && pt.y <= rpt.size.height + rpt.origin.y) {
            // within y bounds
            return YES;
        }
    }
    return NO;
}


// Needs to delete biofilter within range of nearest biofilter

- (IBAction)mapDoubleTap:(UITapGestureRecognizer *)sender {

    CGPoint mypoint = [sender locationInView:self.container];
    //determines point at which the user double taps the screen

    NSLog(@"x = %f,y = %f", mypoint.x, mypoint.y);
    
    float col = (8.0/320.0)*(mypoint.y);
    float row = (8.0/320.0)*(mypoint.x);
    
    NSLog(@"col = %f, row = %f", col, row);
    
    if(self.biofilterCount<5){
        
        for (UIView *view in self.container.subviews) {
            
            if(view != self.cityImageView) {
                
//                CGPoint pt = [mypoint locationInView:self.container];
//                view.frame;
                if([self point:mypoint isonRect:self.container.bounds]) {
                    
                    [view removeFromSuperview];
                    
                }
                
            }
            
        }
    
        [self placeBiofilterAtPoint:mypoint];
        self.biofilterCount++;
        NSLog(@"count = %d", self.biofilterCount);
    }
    //Scale factor S
    //Iy = inset y
    //Ix = inset x
    //1200 points down and across
    //8 units down and across
    //column = (8/1200)(Iy + S*y)
    //row = (8/1200)(Ix + S*x)
}



@end
