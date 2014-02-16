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
@property (nonatomic, strong) UIImage *cityArrowGrid;
@property (nonatomic, strong) UIImageView *cityArrowGridView;
@property (nonatomic, strong) UIView *container;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic) int biofilterCount;
@property (nonatomic) int swapBiofilter; // 0 = leaf; 1 = sprout;

- (IBAction)resetButton:(UIButton *)sender;
- (IBAction)biofilterButton:(UIButton *)sender;
- (IBAction)arrowButton:(UIButton *)sender;

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
    
    self.cityArrowGrid = [UIImage imageNamed:@"ArrowGrid1"];
    self.cityArrowGridView = [[UIImageView alloc] initWithImage:self.cityArrowGrid];
    self.cityArrowGridView.frame = CGRectMake(0, 0, self.scrollViewCityGrid.bounds.size.width, self.scrollViewCityGrid.bounds.size.width);
    self.container = [[UIView alloc] initWithFrame:self.cityArrowGridView.frame];
    
    [self.scrollViewCityGrid addSubview:self.container];
    [self.container addSubview:self.cityImageView];
    [self.container addSubview:self.cityArrowGridView];
    
    // Hides top layer, arrowGrid, displays cityImage
    self.cityArrowGridView.hidden = YES;
    
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

- (void)setBiofilterImage1:(UIImage *)biofilterImage1 {
    self.biofilterImage1 = [UIImage imageNamed:@"Biofilter"];
}

- (void)setBiofilterImage2:(UIImage *)biofilterImage2 {
    self.biofilterImage2 = [UIImage imageNamed:@"Biofilter2"];
}


- (IBAction)resetButton:(UIButton *)sender {
    
    // Resets biofilter count to 0
    while (self.biofilterCount > 0) {
        self.biofilterCount--;  // resets count to 0
    }
    
    // Removes all subviews
    for (UIView *subview in self.container.subviews) {
        [subview removeFromSuperview];
    }
    
    // Adds cityImageView back
    [self.container addSubview:self.cityImageView];
    [self.container addSubview:self.cityArrowGridView];
}

- (IBAction)biofilterButton:(UIButton *)sender {
        
    UIImage * biofilterImage1 = [UIImage imageNamed:@"Biofilter"];
    UIImage * biofilterImage2 = [UIImage imageNamed:@"Biofilter2"];
    
    
    // Switches button image on touch; default: leaf, selected: sprout
    if(sender.selected == NO) {
        [sender setImage:biofilterImage2
                forState:UIControlStateSelected];
        self.swapBiofilter++;
    } else if(sender.selected == YES) {
        [sender setImage:biofilterImage1
                forState:UIControlStateNormal];
        self.swapBiofilter--;
    }

    sender.selected = !sender.selected;

}

- (IBAction)arrowButton:(UIButton *)sender {

    if (sender.selected == NO) {
        
        // Displays arrowGrid on top of cityGrid
        self.cityArrowGridView.hidden = NO;
        
    } else if(sender.selected == YES) {
        
        // Hides arrowGrid, displays cityGrid
        self.cityArrowGridView.hidden = YES;
    }
    
    sender.selected = !sender.selected;
}


- (void)placeBiofilterAtPoint:(CGPoint)mypoint{
    
    UIImage * biofilterImage1 = [UIImage imageNamed:@"Biofilter"];
    UIImage * biofilterImage2 = [UIImage imageNamed:@"Biofilter2"];
    
    UIImageView * biofilterView;
    
    if (self.swapBiofilter == 0) { // places leaf at mypoint
        biofilterView = [[UIImageView alloc] initWithImage:biofilterImage1];
    } else if (self.swapBiofilter == 1) { // places sprout at mypoint
        biofilterView = [[UIImageView alloc] initWithImage:biofilterImage2];
    }
    
    [self.container addSubview:biofilterView];
    biofilterView.frame = CGRectMake(mypoint.x, mypoint.y, 20, 20);
    biofilterView.center = mypoint;

}

- (void)setBiofilterCount:(int)biofilterCount {
    _biofilterCount = biofilterCount;
    self.countLabel.text = [NSString stringWithFormat:@"count: %d", self.biofilterCount];
}


- (BOOL) point:(CGPoint) pt isonRect:(CGRect)rpt {
    if (pt.x >= rpt.origin.x && pt.x <= rpt.size.width + rpt.origin.x) {
        // within x bounds
        if (pt.y > rpt.origin.y && pt.y < rpt.size.height + rpt.origin.y) {
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
    
    if(self.biofilterCount<20){
        
        int deleted = 0;    // If deleted = 1, don't add
        
        // Loops through all subviews for existing biofilters
        for (UIView *view in self.container.subviews) {
            
            if(view != self.cityImageView && view != self.cityArrowGridView) {    // Ignores cityView

                NSLog([self point:mypoint isonRect:view.bounds] ? @"YES":@"NO");
                
                if([self point:mypoint isonRect:view.bounds]){
                    
                    NSLog(@"removing?");
                    [view removeFromSuperview];
                    self.biofilterCount--;
                    deleted = 1;
                    
                }
            }
        }
        
        if(deleted == 0){
            
            [self placeBiofilterAtPoint:mypoint];
            self.biofilterCount++;
            
        }

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
    //                CGPoint pt = [mypoint locationInView:self.container];
    //                view.frame;

@end
