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
#import "EggplantButton-Swift.h"
#import "ItineraryReviewTableViewCell.h"
#import <AFNetworking/AFImageDownloader.h>




@interface ItineraryViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *itineraryTableView;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@property (strong, nonatomic) GMSMapView *gpsMapView;



@end

@implementation ItineraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [self getDate];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.itineraryTableView.delegate = self;
    self.itineraryTableView.dataSource = self;
    
    [self.itineraryTableView registerClass:[ItineraryReviewTableViewCell class] forCellReuseIdentifier:@"activityCell"];
    
    self.itineraryTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [self generateGoogleMap];
    
     //save Itinerary to FireBase
    
    [FirebaseAPIClient saveItineraryWithItinerary:self.itinerary completion:^(NSString * savedItinerary) {
        NSLog(@" Itinerary saved : %@",savedItinerary);
    }];
    
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

//TABLE THINGS
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.itinerary.activities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ItineraryReviewTableViewCell *cell = (ItineraryReviewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ActivityCell" forIndexPath:indexPath];
    
    Activity *activity = ((Activity *)self.itinerary.activities[indexPath.row]);
    
    cell.nameLabel.text = activity.name;
    cell.addressLabel.text = activity.address[0];
    cell.cityStateLabel.text = activity.address[1];
    cell.distanceLabel.text = [NSString stringWithFormat:@"%@ mi away", activity.distance];
    [self downloadImageWithURL:activity.icon setTo:cell.iconImage];
    
    return cell;
}



//MAP THINGS
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
    
    
    
    //MARKER FOR US
    
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

#pragma mark - Helper

-(void)downloadImageWithURL:(NSURL *)imageURL setTo:(UIImageView *)imageView {
    
    //    imageView = nil;
    AFImageDownloader *downloader = [[AFImageDownloader alloc] init];
    downloader.downloadPrioritizaton = AFImageDownloadPrioritizationLIFO;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:imageURL];
    
    imageView.image = nil;
    
    [downloader downloadImageForURLRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *responseObject) {
            imageView.image = responseObject;
        
    } failure:nil];
    
}

@end
