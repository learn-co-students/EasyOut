//
//  ItineraryViewController.m
//  EasyOut
//
//  Created by Adrian Brown  on 4/19/16.
//  Copyright © 2016 EasyOut. All rights reserved.
//

#import "ItineraryViewController.h"
#import "Activity.h"
#import "Constants.h"
#import <GoogleMaps/GoogleMaps.h>
#import "EasyOut-Swift.h"
#import "ItineraryReviewTableViewCell.h"
#import "ActivityCardView.h"
#import <AFNetworking/AFImageDownloader.h>


@interface ItineraryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *itineraryTableView;
@property (weak, nonatomic) IBOutlet UIView *mapView;

@property (strong, nonatomic) GMSMapView *gpsMapView;

@property (strong, nonatomic) UIActivityIndicatorView * spinner;

@end

@implementation ItineraryViewController

- (void) viewWillAppear:(BOOL)animated {
    self.spinner = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.center = CGPointMake((self.view.frame.size.width/2), (self.view.frame.size.height/2));
    self.spinner.hidesWhenStopped = YES;
    [self.spinner startAnimating];
    [self.view addSubview:self.spinner];
}

- (void) viewDidAppear:(BOOL)animated {
    [self.spinner removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [self getDate];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.itineraryTableView.delegate = self;
    self.itineraryTableView.dataSource = self;
        
    self.itineraryTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self generateGoogleMap];
    
    NSLog(@"Itinerary View loaded");
}

-(NSString *)getDate {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:units fromDate:now];
    
    NSString *month;
    
    switch ([components month]) {
        case January:
            month = @"January";
            break;
        case February:
            month = @"February";
            break;
        case March:
            month = @"March";
            break;
        case April:
            month = @"April";
            break;
        case May:
            month = @"May";
            break;
        case June:
            month = @"June";
            break;
        case July:
            month = @"July";
            break;
        case August:
            month = @"August";
            break;
        case September:
            month = @"September";
            break;
        case October:
            month = @"October";
            break;
        case November:
            month = @"November";
            break;
        case December:
            month = @"December";
            break;
            
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@ %lu, %lu", month, [components day], [components year]];
}


#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.itinerary.activities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ItineraryReviewTableViewCell *cell = (ItineraryReviewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ActivityCell" forIndexPath:indexPath];
    
    Activity *activity = ((Activity *)self.itinerary.activities[indexPath.row]);
    
    cell.nameLabel.text = activity.name;
    cell.addressLabel.text = activity.address[0];
    cell.cityStateLabel.text = activity.address[1];
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.02f mi away", roundf([self getDistanceFromLocationOfActivity:activity] * (float)0.000621371 * 100.0) / 100.0];
    [self downloadImageWithURL:activity.icon setTo:cell.iconImage];
    
    return cell;
}


#pragma mark - Map and Location

-(void)generateGoogleMap{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.latitude
                                                            longitude:self.longitude
                                                                 zoom:14];
    
    self.gpsMapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    [self.mapView addSubview:self.gpsMapView];
    
    self.gpsMapView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.gpsMapView.topAnchor constraintEqualToAnchor:self.mapView.topAnchor].active = YES;
    [self.gpsMapView.bottomAnchor constraintEqualToAnchor:self.mapView.bottomAnchor].active = YES;
    [self.gpsMapView.leadingAnchor constraintEqualToAnchor:self.mapView.leadingAnchor].active = YES;
    [self.gpsMapView.trailingAnchor constraintEqualToAnchor:self.mapView.trailingAnchor].active = YES;
    
    //MARKER FOR USER
    GMSMarker *userLoc = [[GMSMarker alloc]init];
    userLoc.position = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    userLoc.map = self.gpsMapView;
    
    //MARKER FOR ACTIVITIES
    UIImage *markerImage = [GMSMarker markerImageWithColor:[Constants vikingBlueColor]];
    
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

-(CLLocationDistance)getDistanceFromLocationOfActivity:(Activity *)activity {
    
    NSLog(@"Getting distance from %@", activity.name);
    
    CLLocation *userLocation = [[CLLocation alloc]initWithLatitude:self.latitude longitude:self.longitude];
    NSString *address = [NSString stringWithFormat:@"%@ %@", activity.address[0], activity.address[1]];
    CLLocationCoordinate2D location = [self getLocationFromAddressString: address];
    CLLocation *activityLocation = [[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longitude];
    CLLocationDistance distance = [userLocation distanceFromLocation: activityLocation];
    
    NSLog(@"Distance: %f", distance);
    
    return distance;
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
    center.latitude = latitude;
    center.longitude = longitude;
    
    return center;
}

#pragma mark - segue

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"SELECTED: %lu", indexPath.row);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"historyToDetailSegue"]) {
        DetailViewController *destinationVC = [segue destinationViewController];
//        ItineraryReviewTableViewCell *cell = sender;
        destinationVC.activity = self.itinerary.activities[[self.itineraryTableView indexPathForSelectedRow].row];
    }
    
    
}

#pragma mark - Helper

-(void)downloadImageWithURL:(NSURL *)imageURL setTo:(UIImageView *)imageView {
    
    // imageView = nil;
    AFImageDownloader *downloader = [[AFImageDownloader alloc] init];
    downloader.downloadPrioritizaton = AFImageDownloadPrioritizationLIFO;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:imageURL];
    
    imageView.image = nil;
    
    [downloader downloadImageForURLRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *responseObject) {
            imageView.image = responseObject;
        
    } failure:nil];
}

@end
