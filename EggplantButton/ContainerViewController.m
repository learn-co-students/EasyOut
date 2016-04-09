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
#import "ActivityCardCollectionViewCell.h"
#import "Activity.h"

#import "Restaurant.h"
#import "Event.h"
#import <CoreLocation/CoreLocation.h>

@class Restaurant;


//MFMessageControlViewController


@interface ContainerViewController () <UIScrollViewDelegate, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) ActivitiesDataStore *dataStore;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *mostRecentLocation;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;

@property (weak, nonatomic) IBOutlet UICollectionView *topRowCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *middleRowCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *bottomRowCollection;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpCoreLocation];
    
    [self.topRowCollection registerClass:[ActivityCardCollectionViewCell class] forCellWithReuseIdentifier:@"cardCell"];
    [self.middleRowCollection registerClass:[ActivityCardCollectionViewCell class] forCellWithReuseIdentifier:@"cardCell"];
    [self.bottomRowCollection registerClass:[ActivityCardCollectionViewCell class] forCellWithReuseIdentifier:@"cardCell"];
    

    self.dataStore = [ActivitiesDataStore sharedDataStore];
    
    [self getTicketMasterData];
    
//    [self getRestaurantData];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if(collectionView == self.topRowCollection) {
        
        NSLog(@"%lu", self.dataStore.events.count);
        
        return self.dataStore.events.count;

    }
    else if (collectionView == self.middleRowCollection) {
        
        NSLog(@"%lu", self.dataStore.restaurants.count);
        
        return self.dataStore.restaurants.count;

    }
    else {
        return 10;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = (ActivityCardCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cardCell" forIndexPath:indexPath];
    if(collectionView == self.topRowCollection) {
        
        Activity *restaurantActivity = self.dataStore.restaurants[indexPath.row];
        ((ActivityCardCollectionViewCell *)cell).cardView.activity = restaurantActivity;
        
    }
    else if (collectionView == self.middleRowCollection) {
        
        Activity *eventActivity = self.dataStore.events[indexPath.row];
        ((ActivityCardCollectionViewCell *)cell).cardView.activity = eventActivity;
        
    }
    else {
        
        NSLog(@"Something else is happening");
    }
    
    return cell;
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
                    
                }];
            }
        }
    }];
}


-(void)setUpCoreLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    self.latitude = [NSString stringWithFormat: @"%f", self.locationManager.location.coordinate.latitude];
    self.longitude = [NSString stringWithFormat: @"%f", self.locationManager.location.coordinate.longitude];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (self.mostRecentLocation == nil) {
        
        self.mostRecentLocation = [locations lastObject];
        
//        if (self.mostRecentLocation != nil) {
////            [self getEvents];
//        }
    }
    
    [self.locationManager stopUpdatingLocation];
}


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
