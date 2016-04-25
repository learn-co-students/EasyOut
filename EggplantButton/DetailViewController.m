//
//  DetailViewController.m
//  EggplantButton
//
//  Created by Stephanie on 4/11/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "DetailViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <AFNetworking/AFImageDownloader.h>
#import "Constants.h"



@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *distanceView;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *moreDetailLabel;

@property (weak, nonatomic) IBOutlet UIView *mapUIView;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) GMSMapView *mapView;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];

    [self generateGoogleMap];
    
    self.nameLabel.text = self.activity.name;
    self.imageView.image = nil;
    
    AFImageDownloader *downloader = [[AFImageDownloader alloc] init];
    downloader.downloadPrioritizaton = AFImageDownloadPrioritizationLIFO;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.activity.imageURL];
    
    self.imageView.image = nil;
    Activity *activityWhoseImageWeAreDownloading = self.activity;
    
    [downloader downloadImageForURLRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *responseObject) {
        if(self.activity == activityWhoseImageWeAreDownloading) {
            self.imageView.image = responseObject;
        }
    } failure:nil];
    
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@", self.activity.address[0], self.activity.address[1]];
    
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonPressed:(UIBarButtonItem *)sender {
    
    [[self navigationController] popViewControllerAnimated:YES];
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

-(void)generateGoogleMap {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.latitude
                                                            longitude:self.longitude
                                                                 zoom:16];
    
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    [self.mapUIView addSubview:self.mapView];
    
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.mapView.topAnchor constraintEqualToAnchor:self.mapUIView.topAnchor].active = YES;
    [self.mapView.bottomAnchor constraintEqualToAnchor:self.mapUIView.bottomAnchor].active = YES;
    [self.mapView.leadingAnchor constraintEqualToAnchor:self.mapUIView.leadingAnchor].active = YES;
    [self.mapView.trailingAnchor constraintEqualToAnchor:self.mapUIView.trailingAnchor].active = YES;
    
    //MARKER FOR US
    
    GMSMarker *userLoc = [[GMSMarker alloc]init];
    userLoc.position = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    userLoc.map = self.mapView;
    
    //MARKER FOR ACTIVITIES
    UIImage *markerImage = [GMSMarker markerImageWithColor:[Constants vikingBlueColor]];
    
    NSString *address = [NSString stringWithFormat:@"%@ %@", self.activity.address[0], self.activity.address[1]];
    
    CLLocationCoordinate2D location = [self getLocationFromAddressString: address];
    
    // Creates a marker in the center of the map.
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = location;
    marker.title = self.activity.name;
    marker.snippet = address;
    marker.map = self.mapView;
    marker.icon = markerImage;
}

@end
