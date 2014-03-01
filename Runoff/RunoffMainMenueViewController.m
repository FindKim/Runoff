//
//  RunoffMainMenueViewController.m
//  Runoff
//
//  Created by Kim Ngo on 2/1/14.
//  Copyright (c) 2014 EiE. All rights reserved.
//

#import "RunoffMainMenueViewController.h"

@interface RunoffMainMenueViewController ()
@property (nonatomic, strong) NSTimer *holdTimer;
@end

@implementation RunoffMainMenueViewController

// Hides navigation bar
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)resetNSUserDefaults:(id)sender
{
    // Removes "beenHere" key--displays messages firt visit to City View
    NSLog(@"Defaults reseted");
    NSDictionary *defaultDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    for (NSString *key in [defaultDictionary allKeys])
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"beenHere"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)eent
//{
//    if ([touches count] == 3) {
//    NSLog(@"Touch Starts");
//    _holdTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(resetNSUserDefaults:) userInfo:nil repeats:NO];
//    }
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if ([_holdTimer isValid]) {
//        [_holdTimer invalidate];
//        self.holdTimer = nil;
//        NSLog(@"Touch moved");
//    }
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if ([_holdTimer isValid]) {
//        [_holdTimer invalidate];
//        self.holdTimer = nil;
//        NSLog(@"Touch ended early");
//    }
//}
//
//- (void)resetNSUserDefaults:(NSTimer *)theTimer
//{
//    // Removes "beenHere" key--displays messages firt visit to City View
//    NSLog(@"Defaults reseted");
//    NSDictionary *defaultDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
//    for (NSString *key in [defaultDictionary allKeys])
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"beenHere"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//
//    self.holdTimer = nil;
//}

@end
