//
//  RunoffCityViewController.m
//  Runoff
//
//  Created by Kim Ngo on 2/1/14.
//  Copyright (c) 2014 EiE. All rights reserved.
//

#import "RunoffCityViewController.h"
#import "Constants.h"

@interface RunoffCityViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewCityGrid;
@property (nonatomic, strong) UIImage *cityImage; //_cityImage instance variable
@property (nonatomic, strong) UIImageView *cityImageView;
@property (nonatomic, strong) UIImage *cityArrowGrid;
@property (nonatomic, strong) UIImageView *cityArrowGridView;
@property (nonatomic, strong) UIImage *biofilterImageLeaf;
@property (nonatomic, strong) UIImage *biofilterImageSprout;
@property (nonatomic, strong) UIView *container;
//@property (weak, nonatomic) IBOutlet UILabel *countLabel;
//@property (nonatomic) int biofilterCount;
@property (weak, nonatomic) IBOutlet UILabel *budgetLabel;
@property (nonatomic) int budgetCount;
@property (nonatomic) int swapBiofilter; // 0 = leaf; 1 = sprout;
@property (nonatomic, strong) UIImageView *rainEffectView;
@property (weak, nonatomic) IBOutlet UIButton *biofilterButtonLabel;
@property (nonatomic, strong) NSArray *locations;

- (IBAction)resetButton:(UIButton *)sender;
- (IBAction)biofilterButton:(UIButton *)sender;
- (IBAction)rainButton:(UIButton *)sender;
- (IBAction)arrowButton:(UIButton *)sender;

@end

@implementation RunoffCityViewController

//property builds an instance variable, a setter, a getter

- (UIImage *)cityImage
{
    if (!_cityImage) {
        _cityImage = [[UIImage alloc] init];
    }
    return _cityImage;
}

- (UIImageView *)rainEffectView {
    
    if (!_rainEffectView) {
        _rainEffectView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"Rain Effect"]];
    }
    return _rainEffectView;
}

- (UIImage *)biofilterImageLeaf {
    
    if (!_biofilterImageLeaf) {
        _biofilterImageLeaf = [UIImage imageNamed:@"Biofilter"];
    }
    return _biofilterImageLeaf;
}

- (UIImage *)biofilterImageSprout {
    
    if (!_biofilterImageSprout) {
        _biofilterImageSprout = [UIImage imageNamed:@"Biofilter2"];
    }
    return _biofilterImageSprout;
}


// Set up: cityView, arrowGridView, containerView, pinch zoom
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
    
    NSLog(@"place 10?");
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!self.cityImageView) {
        [self scrollViewSetUp];
        _budgetCount = RO_INITBUDGET;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)sender {
    return self.container;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)sender withView:(UIView *)zoomView atScale:(CGFloat)scale {
}


- (NSArray *)locations{
//Json Data
    if (!_locations) {
        NSData* locData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Data" ofType:@"json"]];
        
        NSError * error;
        _locations = [NSJSONSerialization JSONObjectWithData:locData options:0 error:&error];
        if(error)NSLog(@"JSON error: %@", error);
    }
    return _locations;
}

- (void)setBiofilterImage1:(UIImage *)biofilterImage1 {
    self.biofilterImage1 = [UIImage imageNamed:@"Biofilter"];
}

- (void)setBiofilterImage2:(UIImage *)biofilterImage2 {
    self.biofilterImage2 = [UIImage imageNamed:@"Biofilter2"];
}

- (float) distanceBetweenPoints:(CGPoint) touched and:(CGPoint) data{
    return sqrtf(powf((touched.x-data.x),2) + powf((touched.y-data.y),2));
}

- (CGPoint) getBiofilterLocation:(CGPoint) touched{
    //loop through the NSArray locations to find x and y values that are closest to the touched point
    //make a point that is from the dictionary
    //find the distance between the points
    //see if it is the smallest distance
    //if it is then store the point
    CGPoint spt;
    float min = INFINITY;
    float distance;
    for(NSDictionary * myDict in self.locations){
        CGPoint data = CGPointMake([myDict[@"x"] floatValue], [myDict[@"y"] floatValue]);
        distance = [self distanceBetweenPoints:touched and: data];
        if(distance < min){
            min = distance;
            spt = data;
        }
    }
    return spt;
}


- (IBAction)resetButton:(UIButton *)sender {
    
/*    // Resets biofilter count to 0
    while (self.biofilterCount > 0) {
        self.biofilterCount--;  // resets count to 0
    }
*/
    // Resets budget = $1000
    self.budgetCount = RO_INITBUDGET;
    
    // Removes all subviews
    for (UIView *subview in self.container.subviews) {
        [subview removeFromSuperview];
    }
    
    // Adds cityImageView back
    [self.container addSubview:self.cityImageView];
    [self.container addSubview:self.cityArrowGridView];
}


- (IBAction)biofilterButton:(UIButton *)sender {
    
    // Switches button image on touch; default: leaf, selected: sprout
    if(sender.selected == NO) {
        
        [sender setImage:self.biofilterImageSprout
                forState:UIControlStateSelected];
        self.swapBiofilter++;
    
    } else if(sender.selected == YES) {
        
        [sender setImage:self.biofilterImageLeaf
                forState:UIControlStateNormal];
        self.swapBiofilter--;
    }

    sender.selected = !sender.selected;

}

- (IBAction)rainButton:(UIButton *)sender {
    
    // Set center of rainEffectView to origin of map
    // Animate from origin of map to bottom of map
    
    self.rainEffectView.frame = CGRectMake(self.cityImageView.frame.origin.x, self.cityImageView.frame.origin.y, self.rainEffectView.image.size.width, self.rainEffectView.image.size.height);
    
    self.rainEffectView.hidden = NO;
    
    [self.container addSubview:self.rainEffectView];
    self.rainEffectView.center = self.cityImageView.frame.origin;
    // wants bottom right corner of rainEffect to origin
    
    [UIView transitionWithView:self.rainEffectView
                      duration:2
                       options:0
                    animations:^{
                           self.rainEffectView.frame = CGRectMake(self.cityImageView.frame.origin.x, self.cityImageView.frame.origin.y, self.rainEffectView.image.size.width, self.rainEffectView.image.size.height);
                    }
                    completion:^(BOOL finished){
                        self.rainEffectView.hidden = YES;
                    }];
    
    
}

- (IBAction)arrowButton:(UIButton *)sender {
    
    // Press down on button unhides the arrowGrid
    self.cityArrowGridView.hidden = NO;
    
}

- (IBAction)arrowButtonRelease:(UIButton *)sender {
    
    // Releasing the arrow button hides the arrowGrid
    self.cityArrowGridView.hidden = YES;
    
}

- (void)placeBiofilterAtPoint:(CGPoint)mypoint{
    
    

    
    UIImageView * biofilterView;
    
    if (self.swapBiofilter == 0) { // places leaf at mypoint
        biofilterView = [[UIImageView alloc] initWithImage:self.biofilterImageLeaf];
        self.budgetCount -= RO_BFCOST1;
    } else if (self.swapBiofilter == 1) { // places sprout at mypoint
        biofilterView = [[UIImageView alloc] initWithImage:self.biofilterImageSprout];
        self.budgetCount -= RO_BFCOST2;
    }
    
    [self.container addSubview:biofilterView];
    biofilterView.frame = CGRectMake(mypoint.x, mypoint.y, 20, 20);
    // #define constants at some point
    biofilterView.center = mypoint;

}



- (void)setBudgetCount:(int)budgetCount {
    
    _budgetCount = budgetCount;
    self.budgetLabel.text = [NSString stringWithFormat:@"$%d", self.budgetCount];
    
    
}

/*
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
*/

- (IBAction)mapDoubleTap:(UITapGestureRecognizer *)sender {

    CGPoint touched = [sender locationInView:self.container];
    CGPoint newtouched;
    newtouched.y = (8.0/320.0)*(touched.y);
    newtouched.x = (8.0/320.0)*(touched.x);
    //determines point at which the user double taps the screen
    CGPoint mypoint = [self getBiofilterLocation:newtouched];
    
    mypoint.y = (320.0/8.0)*(mypoint.y);
    mypoint.x = (320.0/8.0)*(mypoint.x);
    
    NSLog(@"x = %f,y = %f", mypoint.x, mypoint.y);
    
    NSLog(@"col = %f, row = %f", mypoint.y, mypoint.x);
        
    int deleted = 0;    // If deleted = 1, don't add
    
    // Loops through all subviews for existing biofilters
    for (UIImageView *view in self.container.subviews) {
            
        if(view != self.cityImageView && view != self.cityArrowGridView) {    // Ignores cityView

            // Deletes biofilter if tap is on exisiting biofilter
            if (CGRectContainsPoint(view.frame, touched)) {

                // Checks which type deleted to refund cost
                // Removes biofilter at touched point
                // Decrements biofilter count
                // Prevents from adding if deleted
                if ([view isKindOfClass:[UIImageView class]]) {
                    if (view.image == self.biofilterImageLeaf) {
                        self.budgetCount += 75;
                    } else if (view.image == self.biofilterImageSprout) {
                        self.budgetCount += 125;
                    }
                }
                [view removeFromSuperview];
//                self.biofilterCount--;
                deleted = 1;
            }
        }
    }
        // If deletion doesn't occur
        if(deleted == 0){
            if ((self.swapBiofilter == 0 && self.budgetCount >= RO_BFCOST1) ||
                (self.swapBiofilter == 1 && self.budgetCount >= RO_BFCOST2)) {
                [self placeBiofilterAtPoint:mypoint];
 //               self.biofilterCount++;
            
            // Checks if enough in budget
            // Add biofilter at mypoint
            // Increment biofilter count
            }
        }

}



@end
