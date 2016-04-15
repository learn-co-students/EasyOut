//
//  DetailViewController.m
//  EggplantButton
//
//  Created by Stephanie on 4/11/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "DetailViewController.h"
#import <GoogleMaps/GoogleMaps.h>



@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *imageView;
@property (weak, nonatomic) IBOutlet UIView *distanceView;
@property (weak, nonatomic) IBOutlet UILabel *actDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *moreDetailLabel;

@property (weak, nonatomic) IBOutlet UIView *iconImage;
@property (weak, nonatomic) IBOutlet UIView *mapUIView;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) GMSMapView *mapView;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:((Restaurant *)self.activity).lat
                                                            longitude:((Restaurant *)self.activity).lng
                                                                 zoom:6];
    
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapUIView = self.mapView;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(((Restaurant *)self.activity).lat, ((Restaurant *)self.activity).lng);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = self.mapView;


    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@,NY %@", self.activity.address, self.activity.city, self.activity.postalCode];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonPressed:(UIBarButtonItem *)sender {
    
    [[self navigationController] popViewControllerAnimated:YES];
}



@end
