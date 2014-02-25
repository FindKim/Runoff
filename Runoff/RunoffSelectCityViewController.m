//
//  RunoffSelectCityViewController.m
//  Runoff
//
//  Created by Kim Ngo on 2/1/14.
//  Copyright (c) 2014 EiE. All rights reserved.
//

#import "RunoffSelectCityViewController.h"
#import "Constants.h"

@interface RunoffSelectCityViewController ()

@property (nonatomic, retain) NSNumber *visit;

@end

@implementation RunoffSelectCityViewController

- (IBAction)City1:(UIButton *)sender {
    
    [self performSegueWithIdentifier:RO_CITY sender:self];

}
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"City"]) {
        if (segue.destinationViewController.visit == 0) {
            [segue.destinationViewController setVisit:1];
        }
    }
}
*/

@end
