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

    self.dataStore = [ActivitiesDataStore sharedDataStore];
    
    [self getTicketMasterData];
    
    [self getRestaurantData];
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    for(UICollectionView *collectionView in @[ self.topRowCollection, self.middleRowCollection, self.bottomRowCollection ]) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
        CGFloat itemWidth = [collectionView superview].bounds.size.width;
        layout.itemSize = CGSizeMake(itemWidth, collectionView.frame.size.height);
    }
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if(collectionView == self.topRowCollection) {
        
        return self.dataStore.restaurants.count;

    }
    else if (collectionView == self.middleRowCollection) {
                
        return self.dataStore.events.count;

    }
    else {
        return 0;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ActivityCardCollectionViewCell *cell = (ActivityCardCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cardCell" forIndexPath:indexPath];
    
    NSLog(@"\n\n\ncell: %@\n\n\n",cell);
    
    if(collectionView == self.topRowCollection) {
        
        Activity *restaurantActivity = self.dataStore.restaurants[indexPath.row];
        cell.cardView.activity = restaurantActivity;
        
        NSLog(@"%@", cell.cardView.activity.name);
        
    }
    else if (collectionView == self.middleRowCollection) {
        
        Activity *eventActivity = self.dataStore.events[indexPath.row];
        cell.cardView.activity = eventActivity;
        
        NSLog(@"%@", cell.cardView.activity.name);
        
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
//
//                NSInteger maxLat = [self.latitude integerValue] + 0.36;
//                NSInteger minLat = [self.latitude integerValue] - 0.36;
//                NSInteger maxLng = [self.longitude integerValue] + 0.36;
//                NSInteger minLng = [self.longitude integerValue] - 0.36;
// 
//                if(restaurant.lat >= minLat && restaurant.lat <= maxLat && restaurant.lng >= minLng && restaurant.lng <= maxLng) {
            
                    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                        
                        ActivityCardView *newActivityCard =[[ActivityCardView alloc]init];
                        newActivityCard.activity = restaurant;
                        
                        [self.topRowCollection registerClass:[ActivityCardCollectionViewCell class] forCellWithReuseIdentifier:@"cardCell"];
                        
                        self.topRowCollection.delegate = self;
                        self.topRowCollection.dataSource = self;

                        
                    }];
//                }
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
                    

                    
                    [self.middleRowCollection registerClass:[ActivityCardCollectionViewCell class] forCellWithReuseIdentifier:@"cardCell"];
                    
                    self.middleRowCollection.delegate = self;
                    self.middleRowCollection.dataSource = self;
                    
//                    [self.bottomRowCollection registerClass:[ActivityCardCollectionViewCell class] forCellWithReuseIdentifier:@"cardCell"];
//                    
//                    self.bottomRowCollection.delegate = self;
//                    self.bottomRowCollection.dataSource = self;
                    
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



@end
