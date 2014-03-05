//
//  RunoffMainMenueViewController.m
//  Runoff
//
//  Created by Kim Ngo on 2/1/14.
//  Copyright (c) 2014 EiE. All rights reserved.
//

#import "RunoffMainMenueViewController.h"
#import "Constants.h"

@interface RunoffMainMenueViewController ()
@property (nonatomic, strong) NSTimer *holdTimer;
@end

@implementation RunoffMainMenueViewController

// Hides navigation bar
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

// 3 finger touch hold to reset
- (IBAction)resetNSUserDefaults:(id)sender
{
    // Removes "beenHere" key--displays messages first visit to City View
    NSLog(@"Defaults reseted");
    NSDictionary *defaultDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    for (NSString *key in [defaultDictionary allKeys])
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:RO_K_BEEN_HERE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end