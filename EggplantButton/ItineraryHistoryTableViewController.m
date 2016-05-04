//
//  ItineraryHistoryTableViewController.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 4/12/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "ItineraryHistoryTableViewController.h"
#import "EggplantButton-Swift.h"
#import "Itinerary.h"
#import "User.h"
#import "Firebase.h"
#import "Secrets.h"
#import "HistoryTableViewCell.h"
#import "ItineraryViewController.h"
#import "mainContainerViewController.h"


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
    
    [self addItinerariesToTableView];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itineraries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itineraryCell"
                                                                 forIndexPath:indexPath];
    
    cell.itinerary = self.itineraries[indexPath.row];
    cell.itineraryLabel.text = cell.itinerary.title;
    [FirebaseAPIClient getUsernameForUserID:cell.itinerary.userID completion:^(NSString * _Nonnull username) {
        cell.userLabel.text = username;
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    } else {
        NSLog(@"Can't find location");
    }
}

@end
