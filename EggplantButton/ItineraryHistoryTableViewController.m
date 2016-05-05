//
//  ItineraryHistoryTableViewController.m
//  EasyOut
//
//  Created by Ian Alexander Rahman on 4/12/16.
//  Copyright © 2016 EasyOut. All rights reserved.
//

#import "ItineraryHistoryTableViewController.h"
#import "EasyOut-Swift.h"
#import "Itinerary.h"
#import "User.h"
#import "Firebase.h"
#import "Secrets.h"
#import "HistoryTableViewCell.h"
#import "ItineraryViewController.h"
#import "mainContainerViewController.h"
#import "Constants.h"
#import "ItineraryReviewTableViewCell.h"
#import <AFNetworking/AFImageDownloader.h>


@interface ItineraryHistoryTableViewController () <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *itineraryIDs;
@property (strong, nonatomic) NSMutableArray *itineraries;
@property (strong, nonatomic) UIActivityIndicatorView * spinner;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *mostRecentLocation;
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (strong, nonatomic) NSMutableArray *usernames;

@end


@implementation ItineraryHistoryTableViewController

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
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.itineraries = [[NSMutableArray alloc]init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.userInteractionEnabled = YES;
    
    [self setUpCoreLocation];
}

-(void)addItinerariesToTableView {
    
    [FirebaseAPIClient getMostRecentItinerariesWithCompletion:^(NSArray<Itinerary *> * _Nullable itineraries) {
        self.itineraries = (NSMutableArray *)itineraries;
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.itineraries.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Identify current itinerary
    Itinerary *itinerary = self.itineraries[section];
    
    // Return number of activities as rows
    return itinerary.activities.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSLog(@"Creating header for itinerary #%li", section + 1);
    
    // 0. Define current itinerary
    Itinerary *itinerary = self.itineraries[section];
    
    // 1. The view for the header
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 100)];
    
    // 2. Set a custom background color and a border
    headerView.backgroundColor = [Constants vikingBlueColor];
    headerView.layer.borderColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5].CGColor;
    headerView.layer.borderWidth = 2.0;
    headerView.layer.cornerRadius = 5.0;
    
    // 3. Add a label
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(5, 0, tableView.frame.size.width -5, 50);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:20.0];
    headerLabel.text = itinerary.title;
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
    // 4. Add the label to the header view
    [headerView addSubview:headerLabel];
    
    // 5. Return section header
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Creating cell for activity #%li", indexPath.row + 1);
    
    ItineraryReviewTableViewCell *cell = (ItineraryReviewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"itineraryCell" forIndexPath:indexPath];
    
    Itinerary *itinerary = self.itineraries[indexPath.section];
    
    Activity *activity = ((Activity *)itinerary.activities[indexPath.row]);
    
    cell.nameLabel.text = activity.name;
    cell.addressLabel.text = activity.address[0];
    cell.cityStateLabel.text = activity.address[1];

    // TODO: Fix distance lables so they are set in a timely fashion
    // Consider having distances loaded as the itinerary table is populated in ViewDidLoad
    [self getDistanceFromLocationOfActivity:activity
                                 completion:^(CLLocationDistance distance) {
                                     cell.distanceLabel.text = [NSString stringWithFormat:@"%.02f mi away", roundf(distance * (float)0.000621371 * 100.0) / 100.0];
                                 }];
    
    [self downloadImageWithURL:activity.icon setTo:cell.iconImage];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected cell at indexPath.row %li", indexPath.row);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"Preparing for segue from Itinerary Feed");
    
    if ([segue.identifier isEqualToString:@"segueFromItineraryFeedToItinerary"]) {
        ItineraryViewController *destinationVC = [segue destinationViewController];
        HistoryTableViewCell *cell = sender;
        destinationVC.itinerary = cell.itinerary;
        destinationVC.latitude = self.latitude;
        destinationVC.longitude = self.longitude;
    }
}


#pragma mark - Core Location

-(void)setUpCoreLocation {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    if (self.mostRecentLocation == nil) {
        self.mostRecentLocation = [locations lastObject];
    }
    
    self.latitude = self.locationManager.location.coordinate.latitude;
    self.longitude = self.locationManager.location.coordinate.longitude;
    
    [self.locationManager stopUpdatingLocation];
    
    if (self.latitude != 0) {
        
        NSLog(@"Latitude: %f\nLongitude: %f", self.latitude, self.longitude);
        
        [self addItinerariesToTableView];
    } else {
        NSLog(@"Can't find location");
    }
}


#pragma mark - Map and Location

-(void)getDistanceFromLocationOfActivity:(Activity *)activity completion:(void(^)(CLLocationDistance distance))completion {
    
    NSLog(@"Getting distance from %@", activity.name);
    
    CLLocation *userLocation = [[CLLocation alloc]initWithLatitude:self.latitude longitude:self.longitude];
    NSString *address = [NSString stringWithFormat:@"%@ %@", activity.address[0], activity.address[1]];
    
    [self getLocationFromAddressString:address
                            completion:^(CLLocationCoordinate2D location) {
                                
                                CLLocation *activityLocation = [[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longitude];
                                CLLocationDistance distance = [userLocation distanceFromLocation: activityLocation];
                                
                                NSLog(@"Activity is %@", [NSString stringWithFormat:@"%.02f mi away", roundf(distance * (float)0.000621371 * 100.0) / 100.0]);
                                
                                completion(distance);
                            }];
    
}

-(void) getLocationFromAddressString: (NSString*) addressStr completion:(void(^)(CLLocationCoordinate2D location))completion {
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
    
    completion(center);
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
