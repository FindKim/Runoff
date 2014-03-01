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
    [self performSegueWithIdentifier:RO_CITY sender:self];
}


// Unhides navigation bar
- (void)viewWillAppear:(BOOL)animated {

    self.navigationController.navigationBar.hidden = NO;
}

@end
