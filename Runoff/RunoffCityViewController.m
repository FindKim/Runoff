//
//  RunoffCityViewController.m
//  Runoff
//
//  Created by Kim Ngo on 2/1/14.
//  Copyright (c) 2014 EiE. All rights reserved.
//

#import "RunoffCityViewController.h"
#import "Constants.h"
#import "RunoffSelectCityViewController.h"

@interface RunoffCityViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewCityGrid;
@property (nonatomic, strong) UIImage *cityImage; //_cityImage instance variable
@property (nonatomic, strong) UIImageView *cityImageView;
@property (nonatomic, strong) UIImage *cityArrowGrid;
@property (nonatomic, strong) UIImageView *cityArrowGridView;
@property (nonatomic, strong) UIImageView *cityViewMask;

@property (nonatomic, strong) UIImage *biofilterImageLeaf;
@property (nonatomic, strong) UIImage *biofilterImageSprout;
@property (nonatomic, strong) UIImage *biofilterButtonImageLeaf;
@property (nonatomic, strong) UIImage *biofilterButtonImageSprout;

@property (nonatomic, strong) UIImage *pollutedWater;
@property (nonatomic, strong) UIImageView *pollutedWaterView;

@property (nonatomic, strong) UIView *container;

@property (weak, nonatomic) IBOutlet UILabel *budgetLabel;
@property (nonatomic) int budgetCount;
@property (nonatomic) int swapBiofilter; // 0 = leaf; 1 = sprout;
@property (nonatomic, strong) UIImageView *rainEffectView;
@property (weak, nonatomic) IBOutlet UIButton *biofilterButtonLabel;
@property (nonatomic, strong) NSMutableArray *locations;

@property (nonatomic, strong) UIImageView *messageView;
@property (nonatomic, strong) NSMutableArray *myArray;
@property (nonatomic, assign) int messageIndex;

@property (nonatomic, strong) UIImageView *gradeMessageView;

- (IBAction)resetButton:(UIButton *)sender;
- (IBAction)biofilterButton:(UIButton *)sender;
- (IBAction)rainButton:(UIButton *)sender;
- (IBAction)arrowButton:(UIButton *)sender;

@end

@implementation RunoffCityViewController

- (UIImage *)cityImage
{
    if (!_cityImage) {
        _cityImage = [[UIImage alloc] init];
    }
    return _cityImage;
}

- (UIImageView *)cityViewMask
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    if (!_cityViewMask) {
 
        if (screenHeight < RO_HEIGHT_IPHONE4) {
            _cityViewMask = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"iPhone 3 mask"]];
        
        } else if (screenHeight >= RO_HEIGHT_IPHONE4) {
            _cityViewMask = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"iPhone 4 mask"]];
        }
    }
    return _cityViewMask;
}

- (UIImage *)biofilterImageLeaf
{
    if (!_biofilterImageLeaf) {
        _biofilterImageLeaf = [UIImage imageNamed:@"Biofilter"];
    }
    return _biofilterImageLeaf;
}

- (UIImage *)biofilterImageSprout
{
    if (!_biofilterImageSprout) {
        _biofilterImageSprout = [UIImage imageNamed:@"Biofilter2"];
    }
    return _biofilterImageSprout;
}

- (UIImage *)biofilterButtonImageLeaf
{
    
    if (!_biofilterButtonImageLeaf) {
        _biofilterButtonImageLeaf = [UIImage imageNamed:@"ButtonImageLeaf"];
    }
    return _biofilterButtonImageLeaf;
}

- (UIImage *)biofilterButtonImageSprout
{
    if (!_biofilterButtonImageSprout) {
        _biofilterButtonImageSprout = [UIImage imageNamed:@"ButtonImageSprout"];
    }
    return _biofilterButtonImageSprout;
}

- (UIImage *)pollutedWater
{
    if(!_pollutedWater) {
        _pollutedWater = [UIImage imageNamed:@"PollutedWater"];
    }
    return _pollutedWater;
}

- (void)setBeenHere:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:RO_K_BEEN_HERE];
}


- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.messageIndex < self.myArray.count) {
        self.messageView.image = self.myArray[self.messageIndex++];
    } else {
    self.messageView.hidden = YES;
    }
}


// Pop up messages for instructions
- (void)messages
{
    self.messageIndex = 0;
    self.messageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.messageView.frame = CGRectMake(self.messageView.frame.origin.x,
                                        self.messageView.frame.origin.y + 64,
                                        self.messageView.frame.size.width,
                                        self.messageView.frame.size.height-64);
    
    self.messageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    
    [self.messageView addGestureRecognizer:doubleTap];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    // Different images for different screen sizes
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    if (screenHeight >= RO_HEIGHT_IPHONE4) {
        for (NSString *name in RO_MESSAGE_IMAGE_NAME_ARRAY_IPHONE4) {
            NSLog(@"within iPhone4 for loop");
            [array addObject:[UIImage imageNamed:name]];
        }
    
    } else if (screenHeight < RO_HEIGHT_IPHONE4) {
        for (NSString *name in RO_MESSAGE_IMAGE_NAME_ARRAY_IPHONE3) {
            [array addObject:[UIImage imageNamed:name]];
        }
    }
    self.myArray = [array copy];
    self.messageView.image = self.myArray[self.messageIndex++];
    NSLog(@"This is after messages");
}


- (void)handleGestureGrade:(UIGestureRecognizer *)gestureRecognizer
{
    self.gradeMessageView.hidden = YES;

}

- (void)messagesGrade
{
    self.gradeMessageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.gradeMessageView.frame = CGRectMake(self.gradeMessageView.frame.origin.x,
                                        self.gradeMessageView.frame.origin.y + 64,
                                        self.gradeMessageView.frame.size.width,
                                        self.gradeMessageView.frame.size.height-64);
    
    self.gradeMessageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureGrade:)];
    doubleTap.numberOfTapsRequired = 2;
    
    [self.gradeMessageView addGestureRecognizer:doubleTap];
    
    [self.view addSubview:self.gradeMessageView];
    
    self.gradeMessageView.hidden = YES;

    NSLog(@"This is after grading");
}


- (void)setBudgetCount:(int)budgetCount
{
    _budgetCount = budgetCount;
    self.budgetLabel.text = [NSString stringWithFormat:@"$%d", self.budgetCount];
}


// Set up: cityView, arrowGridView, containerView, pinch zoom
- (void)scrollViewSetUp
{
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
    
    NSLog(@"The height of cityImage is %f", self.cityImageView.frame.size.height);
    
    self.cityArrowGrid = [UIImage imageNamed:@"ArrowGrid1"];
    self.cityArrowGridView = [[UIImageView alloc] initWithImage:self.cityArrowGrid];
    self.cityArrowGridView.frame = CGRectMake(0, 0, self.scrollViewCityGrid.bounds.size.width, self.scrollViewCityGrid.bounds.size.width);
    
    //polluted water
    self.pollutedWater = [UIImage imageNamed:@"PollutedWater"];
    self.pollutedWaterView = [[UIImageView alloc] initWithImage:self.pollutedWater];
    self.pollutedWaterView.frame = self.cityImageView.frame;
    
    self.rainEffectView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rain Effect"]];
    
    [self.scrollViewCityGrid addSubview:self.container];
    [self.container addSubview:self.cityImageView];
    [self.container addSubview:self.pollutedWaterView];
    [self.container addSubview:self.cityArrowGridView];
    [self.container addSubview:self.rainEffectView];
    [self.container addSubview:self.cityViewMask];
    // This masks the rain animation that is larger than citygrid
    
    // Hides top layer, arrowGrid, polluted water, displays cityImage
    self.cityArrowGridView.hidden = YES;
    self.pollutedWaterView.hidden = YES;
    self.rainEffectView.hidden = YES;
    self.scrollViewCityGrid.contentSize = self.container.bounds.size;
    
    self.scrollViewCityGrid.minimumZoomScale = 1.0;
    self.scrollViewCityGrid.maximumZoomScale = 4.0; // twice its normal size
    self.scrollViewCityGrid.delegate = self;
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (!self.cityImageView) {
        [self scrollViewSetUp];
        _budgetCount = RO_INITBUDGET;   // Initializes budget
    }
    
    if (!self.gradeMessageView) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSLog(@"Have we been here: %d", [[NSUserDefaults standardUserDefaults] boolForKey:RO_K_BEEN_HERE]);
        
        if ([[[prefs dictionaryRepresentation] allKeys] containsObject:RO_K_BEEN_HERE] == 0) {
            [self messages];    // Calls instruction messages only on first visit
            [self.view addSubview:self.messageView];
            NSLog(@"first visit, displaying messages");
            [self setBeenHere:YES];
            NSLog(@"Have we been here: %d", [[NSUserDefaults standardUserDefaults] boolForKey:RO_K_BEEN_HERE]);
        }
        [self messagesGrade];

    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)sender
{
    return self.container;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)sender withView:(UIView *)zoomView atScale:(CGFloat)scale {
}


- (IBAction)resetButton:(UIButton *)sender
{
    // Resets budget = $1000
    self.budgetCount = RO_INITBUDGET;
    
    // Removes all subviews
    for (UIView *subview in self.container.subviews) {
        [subview removeFromSuperview];
    }
    
    // Adds cityImageView back
    [self.container addSubview:self.cityImageView];
    [self.container addSubview:self.pollutedWaterView];
    [self.container addSubview:self.cityArrowGridView];
    [self.container addSubview:self.rainEffectView];
    [self.container addSubview:self.cityViewMask];
    // This masks the rain animation that is larger than citygrid
    
    //Reset Water Color
    self.pollutedWaterView.hidden = YES;
    self.rainEffectView.hidden = YES;
    self.cityArrowGridView.hidden = YES;
  
    
    // Reset all grades and locations
    for(NSMutableDictionary * myDict in self.locations){
            [myDict setObject:RO_K_NOTHING_IS_HERE forKey:RO_K_BIOFILTER_HERE];
    }

    
}


- (IBAction)biofilterButton:(UIButton *)sender
{
    // Switches button image on touch; default: leaf, selected: sprout
    if(sender.selected == NO) {
        
        [sender setImage:self.biofilterButtonImageSprout
                forState:UIControlStateSelected];
        self.swapBiofilter++;
        
    } else if(sender.selected == YES) {
        
        [sender setImage:self.biofilterButtonImageLeaf
                forState:UIControlStateNormal];
        self.swapBiofilter--;
    }
    
    sender.selected = !sender.selected;
}


- (IBAction)arrowButton:(UIButton *)sender
{
    // Press down on button unhides the arrowGrid
    self.cityArrowGridView.hidden = NO;
}

- (IBAction)arrowButtonRelease:(UIButton *)sender
{
    // Releasing the arrow button hides the arrowGrid
    self.cityArrowGridView.hidden = YES;
}


- (IBAction)rainButton:(UIButton *)sender
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    // Set center of rainEffectView to origin of map
    // Animate from origin of map to bottom of map
    
    self.rainEffectView.frame = CGRectMake(self.cityImageView.frame.origin.x, self.cityImageView.frame.origin.y, self.rainEffectView.image.size.width, self.rainEffectView.image.size.height);
    
    self.rainEffectView.center = self.cityImageView.frame.origin;
    // wants bottom right corner of rainEffect to origin
    
    self.rainEffectView.hidden = NO;
    
    [UIView transitionWithView:self.rainEffectView
                      duration:2
                       options:0
                    animations:^{
                        self.rainEffectView.frame = CGRectMake(self.cityImageView.frame.origin.x, self.cityImageView.frame.origin.y, self.rainEffectView.image.size.width, self.rainEffectView.image.size.height);
                    }
                    completion:^(BOOL finished){
                        self.rainEffectView.hidden = YES;
                        
                        //Calculate grade and display change of water if necessary
                        int grade = self.getBiofilterGrade;
                        //Calculate alpha = grade/(highest score);
                        //find highest score
                        //Linear then flatten out??
                        if (grade <= 30) { //got a low score
                            self.pollutedWaterView.alpha = 0.8; //darkest water
                            if (screenHeight >= RO_HEIGHT_IPHONE4) {
                                self.gradeMessageView.image = [UIImage imageNamed:RO_MESSAGE_GRADE_IPHONE4_C];
                            } else if (screenHeight < RO_HEIGHT_IPHONE4) {
                                self.gradeMessageView.image = [UIImage imageNamed:RO_MESSAGE_GRADE_IPHONE3_C];
                            }
                            self.gradeMessageView.hidden = NO;
                        }
                        else if (grade >= 31 && grade <= 45) { //got a middle score
                            self.pollutedWaterView.alpha = 0.4; //dark water
                            if (screenHeight >= RO_HEIGHT_IPHONE4) {
                                self.gradeMessageView.image = [UIImage imageNamed:RO_MESSAGE_GRADE_IPHONE4_B];
                            } else if (screenHeight < RO_HEIGHT_IPHONE4) {
                                self.gradeMessageView.image = [UIImage imageNamed:RO_MESSAGE_GRADE_IPHONE3_B];
                            }
                            self.gradeMessageView.hidden = NO;
                        }
                        else if (grade >= 46) {
                            self.pollutedWaterView.alpha = 0;
                            if (screenHeight >= RO_HEIGHT_IPHONE4) {
                                self.gradeMessageView.image = [UIImage imageNamed:RO_MESSAGE_GRADE_IPHONE4_A];
                            } else if (screenHeight < RO_HEIGHT_IPHONE4) {
                                self.gradeMessageView.image = [UIImage imageNamed:RO_MESSAGE_GRADE_IPHONE3_A];
                            }
                            self.gradeMessageView.hidden = NO;
                        }
                        self.pollutedWaterView.hidden = NO; //remove hidden polluted water view
                    }];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.messageView addGestureRecognizer:doubleTap];
}


- (NSMutableArray *)locations
{
    //Json Data
    if (!_locations) {
        NSData* locData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.dataFileName ofType:@"json"]];
        
        NSError * error;
        NSArray * tempLoc;
        tempLoc = [NSJSONSerialization JSONObjectWithData:locData options:0 error:&error];
        int i = 0;
        NSMutableArray * mutLocation = [tempLoc mutableCopy];
        for(NSDictionary *dict in tempLoc){
            NSMutableDictionary * mutDict = [dict mutableCopy];
            [mutDict setObject:RO_K_NOTHING_IS_HERE forKey:RO_K_BIOFILTER_HERE];
            mutLocation[i] = mutDict;
            i++;
        }
        _locations = [mutLocation copy];
        if(error)NSLog(@"JSON error: %@", error);
    }
    return _locations;
}


- (float) distanceBetweenPoints:(CGPoint) touched and:(CGPoint) data
{
    return sqrtf(powf((touched.x-data.x),2) + powf((touched.y-data.y),2));
}

- (int) getBiofilterGrade{
    //loop through the NSArray locations to find x and y values that are closest to the touched point
    //make a point that is from the dictionary
    //find the distance between the points
    //see if it is the smallest distance
    int grade = 0;
    for(NSDictionary * myDict in self.locations){

            //if sprout is selected
            //if([self.locations[RO_K_BIOFILTER_HERE] isEqualToString:RO_K_SPROUT_IS_HERE]){
            if([myDict[RO_K_BIOFILTER_HERE] isEqualToString:RO_K_SPROUT_IS_HERE]){
                //get grade of biofilter
                grade += [myDict[RO_K_GRADE_SPROUT] intValue];
                NSLog(@"grade Sprout has been placed");
            }
                //if leaf is selected
            //else if([self.locations[RO_K_BIOFILTER_HERE] isEqualToString:RO_K_LEAF_IS_HERE]){
            else if([myDict[RO_K_BIOFILTER_HERE] isEqualToString:RO_K_LEAF_IS_HERE]){
                //get grade of biofilter
                grade += [myDict[RO_K_GRADE_LEAF] intValue];
                //NSLog(@"grade Leaf has been placed");
            }
    }
    NSLog(@"getBiofilerGrade ran, total grade equals = %d", grade);
    return grade;
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


- (BOOL) isBiofilterHere:(CGPoint) touched
{
    //loop through the NSArray locations to find x and y values that are closest to the touched point
    //make a point that is from the dictionary
    //find the distance between the points
    //see if it is the smallest distance
    //if it is then store the point
    BOOL pointIsHere;
    float min = INFINITY;
    float distance;
    for(NSDictionary * myDict in self.locations){
        CGPoint data = CGPointMake([myDict[@"x"] floatValue], [myDict[@"y"] floatValue]);
        distance = [self distanceBetweenPoints:touched and: data];
        if(distance < min){
            min = distance;
            if (![myDict[RO_K_BIOFILTER_HERE] isEqualToString:RO_K_NOTHING_IS_HERE]){
                pointIsHere = YES;
            }
            else{
                pointIsHere = NO;
            }
        }
    }
    return pointIsHere;
}


- (void) setBiofilterHere:(CGPoint) touched to:(NSString *)LeafOrSproutOrNil
{
    //loop through the NSArray locations to find x and y values that are closest to the touched point
    //make a point that is from the dictionary
    //find the distance between the points
    //see if it is the smallest distance
    //if it is then store the point
    float min = INFINITY;
    float distance;
    NSMutableDictionary * shortestPoint;
    for(NSMutableDictionary * myDict in self.locations){
        CGPoint data = CGPointMake([myDict[@"x"] floatValue], [myDict[@"y"] floatValue]);
        distance = [self distanceBetweenPoints:touched and: data];
        if(distance < min){
            min = distance;
            shortestPoint = myDict;
        }
    }
    shortestPoint[RO_K_BIOFILTER_HERE] = LeafOrSproutOrNil;
}


- (void)placeBiofilterAtPoint:(CGPoint)mypoint
{
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


- (IBAction)mapDoubleTap:(UITapGestureRecognizer *)sender
{
    CGPoint touched = [sender locationInView:self.container];
    CGPoint newtouched;
    newtouched.y = (8.0/320.0)*(touched.y);
    newtouched.x = (8.0/320.0)*(touched.x);
    //determines point at which the user double taps the screen
    CGPoint mypoint = [self getBiofilterLocation:newtouched];
    
    BOOL biofilterIsHere = [self isBiofilterHere:newtouched];
    
    mypoint.y = (320.0/8.0)*(mypoint.y);
    mypoint.x = (320.0/8.0)*(mypoint.x);
    
    NSLog(@"x = %f,y = %f", mypoint.x, mypoint.y);
    
    NSLog(@"col = %f, row = %f", mypoint.y, mypoint.x);
    
    int deleted = 0;    // If deleted = 1, don't add
    
    // Loops through all subviews for existing biofilters
    for (UIImageView *view in self.container.subviews) {
        
        if(view != self.cityImageView &&
           view != self.cityArrowGridView &&
           view != self.pollutedWaterView &&
           view != self.rainEffectView &&
           view != self.cityViewMask &&
           view != self.messageView &&
           view != self.gradeMessageView) {    // Ignores cityView
            
            // Deletes biofilter if tap is on exisiting biofilter
            if (CGRectContainsPoint(view.frame, touched)) {
                //set "leaf is not here"
                [self setBiofilterHere:newtouched to:RO_K_NOTHING_IS_HERE];

                // Checks which type deleted to refund cost
                // Removes biofilter at touched point
                // Refunds biofilter cost
                // Prevents from adding if deleted
                if ([view isKindOfClass:[UIImageView class]]) {
                    if (view.image == self.biofilterImageLeaf) {
                        self.budgetCount += 75;
                    } else if (view.image == self.biofilterImageSprout) {
                        self.budgetCount += 125;
                    }
                }
                [view removeFromSuperview];
                deleted = 1;
            }
        }
    }
        // If deletion doesn't occur AND there is no biofilter
        if(deleted == 0 && !biofilterIsHere){
            if (self.swapBiofilter == 1){
                [self setBiofilterHere:newtouched to: RO_K_SPROUT_IS_HERE];
            }
            else{
                [self setBiofilterHere:newtouched to: RO_K_LEAF_IS_HERE];
            }
            if ((self.swapBiofilter == 0 && self.budgetCount >= RO_BFCOST1) ||
                (self.swapBiofilter == 1 && self.budgetCount >= RO_BFCOST2)) {
                [self placeBiofilterAtPoint:mypoint];
            
            // Checks if enough in budget
            // Add biofilter at mypoint
            // Reduces biofilter budget
            }
    }
}



@end
