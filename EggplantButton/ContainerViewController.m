//
//  ContainerViewController.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 3/31/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "ContainerViewController.h"
#import "ActivityCardView.h"
#import "ActivitiesDataStore.h"

#import "Restaurant.h"
#import "Event.h"
#import <CoreLocation/CoreLocation.h>

@class Restaurant;



@interface ContainerViewController () <UIScrollViewDelegate, CLLocationManagerDelegate >

@property (strong, nonatomic) ActivitiesDataStore *dataStore;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *mostRecentLocation;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;

@property (weak, nonatomic) IBOutlet UIScrollView *topCardScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *middleCardScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *bottomCardScrollView;

@property (weak, nonatomic) IBOutlet UIStackView *topCardStackView;
@property (weak, nonatomic) IBOutlet UIStackView *middleCardStackView;
@property (weak, nonatomic) IBOutlet UIStackView *bottomCardStackView;

@property (weak, nonatomic) IBOutlet UIButton *locationFilterButton;
@property (weak, nonatomic) IBOutlet UIButton *timeFilterButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *priceFilterButton;
@property (weak, nonatomic) IBOutlet UIButton *historyButton;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    //LOCATION THINGS
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
    
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    self.latitude = [NSString stringWithFormat: @"%f", self.locationManager.location.coordinate.latitude];
    self.longitude = [NSString stringWithFormat: @"%f", self.locationManager.location.coordinate.longitude];
    
    //DATA THINGS
    
    self.dataStore = [ActivitiesDataStore sharedDataStore];
    
    [self getTicketMasterData];
    
//    [self getRestaurantData];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


-(void)getRestaurantData{
    
    [self.dataStore getRestaurantsWithCompletion:^(BOOL success) {
        if(success) {
            
            for(Restaurant *restaurant in self.dataStore.restaurants) {
                
                NSInteger maxLat = [self.latitude integerValue] + 0.36;
                NSInteger minLat = [self.latitude integerValue] - 0.36;
                NSInteger maxLng = [self.longitude integerValue] + 0.36;
                NSInteger minLng = [self.longitude integerValue] - 0.36;
 
                if(restaurant.lat >= minLat && restaurant.lat <= maxLat && restaurant.lng >= minLng && restaurant.lng <= maxLng) {
                
                    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                        
                        ActivityCardView *newActivityCard =[[ActivityCardView alloc]init];
                        newActivityCard.activity = restaurant;
                        
                        newActivityCard.translatesAutoresizingMaskIntoConstraints = NO;
                        
                        [self.middleCardStackView addArrangedSubview: newActivityCard];
                        
                        [newActivityCard.heightAnchor constraintEqualToAnchor:self.middleCardScrollView.heightAnchor].active = YES;
                        [newActivityCard.widthAnchor constraintEqualToAnchor:self.middleCardScrollView.widthAnchor].active = YES;
                    }];
                }
            }
        }
        
    }];

}

-(void)getTicketMasterData{
    
    [self.dataStore getEventsForLat:self.latitude lng:self.longitude withCompletion:^(BOOL success) {
        if (success) {
            for (Event *event in self.dataStore.events) {
                
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    
                    ActivityCardView *eventActivitycard = [[ActivityCardView alloc]init];
                    eventActivitycard.activity = event;
                    
                    eventActivitycard.translatesAutoresizingMaskIntoConstraints = NO;
                    
                    [self.topCardStackView addArrangedSubview:eventActivitycard];
                    
                    [eventActivitycard.heightAnchor constraintEqualToAnchor: self.topCardScrollView.heightAnchor].active = YES;
                    [eventActivitycard.widthAnchor constraintEqualToAnchor: self.topCardScrollView.widthAnchor].active = YES;
                }];
                

            }
        }
    }];
}


//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
//    NSLog(@"location manager did update locations");
//    if (self.mostRecentLocation == nil) {
//        
//        self.mostRecentLocation = [locations lastObject];
//        
//        if (self.mostRecentLocation != nil) {
////            [self getEvents];
//        }
//    }
//    
//    NSLog(@"location: %@", self.mostRecentLocation);
//    
//    [self.locationManager stopUpdatingLocation];
//}


// This method will be used to handle the card scroll views' reactions and delay page-turning
//-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
////    CGPoint quoVadis = *targetContentOffset;
////    targetContentOffset->y
//    
//    CGPoint newOffset = CGPointZero;
//    *targetContentOffset = newOffset;
//}


/* ADRIAN"S TicketMaster Event Setup ** vvvv 
 
 
- (void)setupLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self getTheUsersCurrentLocation];
}

- (void)getTheUsersCurrentLocation {
    //after this method fires off, the locationManager didUpdateLocations method below gets called (behind the scenes by the startUpdatingLocation)
    [self.locationManager startUpdatingLocation];
}



-(void)getEvents {
    [self.ticketMasterDataStore getEventsForLocation:self.mostRecentLocation withCompletion:^(BOOL success) {
        if (success) {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                // [self.tableView reloadData];
            }];
        }
    }];
}


 */




-(void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"Contianer view will appear");
    
}

-(IBAction)locationFilterButtonTapped:(id)sender {
    NSLog(@"Location filter button tapped");
}

-(IBAction)timeFilterButtonTapped:(id)sender {
    NSLog(@"Time filter button tapped");
}

-(IBAction)shareButtonTapped:(id)sender {
    NSLog(@"Share button tapped");
}

-(IBAction)priceFilterButtonTapped:(id)sender {
    NSLog(@"Price filter button tapped");
}

-(IBAction)historyButtonTapped:(id)sender {
    NSLog(@"History button tapped");
}

@end
