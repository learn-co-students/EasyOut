//
//  ItineraryViewController.m
//  EggplantButton
//
//  Created by Adrian Brown  on 4/19/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "ItineraryViewController.h"
#import "Activity.h"
#import "Constants.h"
#import <GoogleMaps/GoogleMaps.h>


@interface ItineraryViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *itineraryTableView;
@property (weak, nonatomic) IBOutlet UIView *mapView;


@property (strong, nonatomic) GMSMapView *gpsMapView;



@end

@implementation ItineraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itineraryTableView.delegate = self;
    self.itineraryTableView.dataSource = self;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.latitude
                                                            longitude:self.longitude
                                                                 zoom:16];
    
    self.gpsMapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    [self.mapView addSubview:self.gpsMapView];
    
    self.gpsMapView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.gpsMapView.topAnchor constraintEqualToAnchor:self.mapView.topAnchor].active = YES;
    [self.gpsMapView.bottomAnchor constraintEqualToAnchor:self.mapView.bottomAnchor].active = YES;
    [self.gpsMapView.leadingAnchor constraintEqualToAnchor:self.mapView.leadingAnchor].active = YES;
    [self.gpsMapView.trailingAnchor constraintEqualToAnchor:self.mapView.trailingAnchor].active = YES;

    
    UIImage *markerImage = [GMSMarker markerImageWithColor:[Constants vikingBlueColor]];
    
    //MARKER FOR US
    
    GMSMarker *userLoc = [[GMSMarker alloc]init];
    userLoc.position = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    userLoc.map = self.gpsMapView;
    
    
    //MARKER FOR ACTIVITIES
    for(Activity *activity in self.itinerary.activities) {
        
        NSString *address = [NSString stringWithFormat:@"%@%@", activity.address[0], activity.address[1]];
    
        CLLocationCoordinate2D location = [self getLocationFromAddressString: address];
        
        // Creates a marker in the center of the map.
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = location;
        marker.title = activity.name;
        marker.snippet = address;
        marker.map = self.gpsMapView;
        marker.icon = markerImage;
        
        }
    
   }



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.itinerary.activities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell" forIndexPath:indexPath];
    
    cell.textLabel.text = ((Activity *)self.itinerary.activities[indexPath.row]).name;
    cell.detailTextLabel.text = ((Activity *)self.itinerary.activities[indexPath.row]).address[0];
    
    return cell;
}


-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;

    
    return center;
    
}

@end
