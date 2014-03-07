//
//  RunoffSelectCityViewController.m
//  Runoff
//
//  Created by Kim Ngo on 2/1/14.
//  Copyright (c) 2014 EiE. All rights reserved.
//

#import "RunoffSelectCityViewController.h"
#import "Constants.h"
#import "RunoffCell.h"
#import "RunoffCityViewController.h"

@interface RunoffSelectCityViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray* MapArray;
@property (nonatomic, strong) NSString* MapLocations;
@end

@implementation RunoffSelectCityViewController

- (void)viewDidLoad{
    NSData* MapJson = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Maps" ofType:@"json"]];
    NSError * error;
    self.MapArray = [NSJSONSerialization JSONObjectWithData:MapJson options:0 error:&error];
    if (error) {
        NSLog(@"You had a error with the Maps.json File.");
    }
    [super viewDidLoad];
}

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
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"RunoffCell";
    RunoffCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.BioCityImageView.image =[UIImage imageNamed:[(NSDictionary *)self.MapArray[indexPath.row]  objectForKey:@"Map_name"]] ;
    cell.BioCityLabel.text =[(NSDictionary *)self.MapArray[indexPath.row]  objectForKey:@"Map_Label"];
    NSLog(@"Name is here");
    return cell;

    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.MapLocations = [(NSDictionary *)self.MapArray[indexPath.row] objectForKey:@"Map_locations"];
    [self performSegueWithIdentifier:RO_CITY sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 108;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.MapArray count];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if([segue.identifier isEqualToString:RO_CITY]){
        RunoffCityViewController * vc = segue.destinationViewController;
        vc.dataFileName = self.MapLocations;
    }
}
@end
