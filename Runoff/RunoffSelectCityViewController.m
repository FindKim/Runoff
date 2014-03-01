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

@end

@implementation RunoffSelectCityViewController


- (void)setBeenHere:(int)value
{
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:@"beenHere"];
}


- (IBAction)City1:(UIButton *)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSLog(@"%d", [[NSUserDefaults standardUserDefaults] integerForKey:@"beenHere"]);
    if (![[[prefs dictionaryRepresentation] allKeys] containsObject:@"beenHere"]) {
        [self setBeenHere:0];
        NSLog(@"first visit");
        NSLog(@"%d", [[NSUserDefaults standardUserDefaults] integerForKey:@"beenHere"]);
    }
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

// Unhides navigation bar
- (void)viewWillAppear:(BOOL)animated {

    self.navigationController.navigationBar.hidden = NO;
}

@end
