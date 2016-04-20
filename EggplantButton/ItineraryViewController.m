//
//  ItineraryViewController.m
//  EggplantButton
//
//  Created by Adrian Brown  on 4/19/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "ItineraryViewController.h"
#import "Activity.h"
#import <GoogleMaps/GoogleMaps.h>


@interface ItineraryViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *itineraryTableView;
@property (weak, nonatomic) IBOutlet UIView *mapView;

@property (strong, nonatomic) GMSMapView *mapyView;

@end

@implementation ItineraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itineraryTableView.delegate = self;
    self.itineraryTableView.dataSource = self;

    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:1.285
                                                            longitude:103.848
                                                                 zoom:12];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    [self.mapView addSubview:self.mapyView];
    
    self.mapyView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.mapyView.topAnchor constraintEqualToAnchor:self.mapView.topAnchor].active = YES;
    [self.mapyView.bottomAnchor constraintEqualToAnchor:self.mapView.bottomAnchor].active = YES;
    [self.mapyView.leadingAnchor constraintEqualToAnchor:self.mapView.leadingAnchor].active = YES;
    [self.mapyView.trailingAnchor constraintEqualToAnchor:self.mapView.trailingAnchor].active = YES;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    NSLog(@"%lu", self.itinerary.activities.count);
    return self.itinerary.activities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell" forIndexPath:indexPath];
    
    NSLog(@" Activity: %@", self.itinerary.activities);

    
    cell.textLabel.text = ((Activity *)self.itinerary.activities[indexPath.row]).name;
    cell.detailTextLabel.text = ((Activity *)self.itinerary.activities[indexPath.row]).address;
    
    return cell;
}


@end
