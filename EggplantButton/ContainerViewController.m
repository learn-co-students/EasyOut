//
//  ContainerViewController.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 3/31/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "UIView+Shake.h"
#import "ContainerViewController.h"
#import "EggplantButton-Swift.h"
#import "ActivitiesDataStore.h"
#import "ActivityCardCollectionViewCell.h"


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
    
    
#warning FIREBASE THINGS FOR TESTING. REMOVE LATER
    //    // Instantiate new instance of the Firebase API Client
    //    FirebaseAPIClient *firebaseAPI = [[FirebaseAPIClient alloc] init];
    
    //    // Create and save test image to Firebase
    //    UIImage *image = [UIImage imageNamed:@"EasyOutLaunchScreenImage"];
    //    NSString *imageID = [firebaseAPI createNewImageWithImage:image];
    //    NSLog(@"Image saved to Firebase with ID: %@", imageID);
    
    
}

#pragma get API data

-(void)getRestaurantData{
    
    [self.topRowCollection registerClass:[ActivityCardCollectionViewCell class] forCellWithReuseIdentifier:@"cardCell"];
    
    self.topRowCollection.delegate = self;
    self.topRowCollection.dataSource = self;
    
    
    [self.dataStore getRestaurantsWithCompletion:^(BOOL success) {
        if(success) {
            
            [self.topRowCollection reloadData];
        }
        
    }];
    
}

-(void)getTicketMasterData{
    
    
    [self.middleRowCollection registerClass:[ActivityCardCollectionViewCell class] forCellWithReuseIdentifier:@"cardCell"];
    
    self.middleRowCollection.delegate = self;
    self.middleRowCollection.dataSource = self;
    
    
    [self.dataStore getEventsForLat:self.latitude lng:self.longitude withCompletion:^(BOOL success) {
        if (success) {
            
            [self.middleRowCollection reloadData];
        }
    }];
}

#pragma collection view methods

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

    return cell;
}


<<<<<<< HEAD



#pragma mark - Populating Activity Cards

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
            
                
                NSInteger maxLat = [self.latitude integerValue] + 0.36;
                NSInteger minLat = [self.latitude integerValue] - 0.36;
                NSInteger maxLng = [self.longitude integerValue] + 0.36;
                NSInteger minLng = [self.longitude integerValue] - 0.36;
                
                if(restaurant.lat >= minLat && restaurant.lat <= maxLat && restaurant.lng >= minLng && restaurant.lng <= maxLng) {
                    
                    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                        
                        ActivityCardView *newActivityCard =[[ActivityCardView alloc]init];
                        newActivityCard.activity = restaurant;
                        
                        [self.topRowCollection registerClass:[ActivityCardCollectionViewCell class] forCellWithReuseIdentifier:@"cardCell"];
                        
                        self.topRowCollection.delegate = self;
                        self.topRowCollection.dataSource = self;

                        

                    }];
                }
            }
        }
    }];
}

-(void)getTicketMasterData{
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(ActivityCardCollectionViewCell *)sender {
    
    
    NSLog(@"prepating to segue...");
    
    
}

#pragma core location


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
        

    }
    
    [self.locationManager stopUpdatingLocation];
}



#pragma mark - Shake Gesture Methods

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ( event.subtype == UIEventSubtypeMotionShake )
    {
        NSLog(@"Shake started");
        
        //[self getShuffledTicketMasterData];
        
        [self getShuffledRestaurantData];
        
        // Shake top card with the default speed
        [self.topRowCollection shake:15     // 15 times
                           withDelta:20     // 20 points wide
         ];
        // Shake middle card with the default speed
        [self.middleRowCollection shake:15   // 15 times
                              withDelta:20   // 20 points wide
         ];
        // Shake bottom card with the default speed
        [self.bottomRowCollection shake:15   // 15 times
                              withDelta:20   // 20 points wide
         ];
        
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ( event.subtype == UIEventSubtypeMotionShake )
    {
        NSLog(@"Shake ended");
        
    }

    
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
}

- (BOOL)canBecomeFirstResponder
{ return YES; }


-(void)getShuffledTicketMasterData{
    
    [self.dataStore getEventsForLat:self.latitude lng:self.longitude withCompletion:^(BOOL success) {
        if (success) {
            //shuffle restaurants
            GKARC4RandomSource *randomSource = [GKARC4RandomSource new];
            NSArray *shuffledEvents = [randomSource arrayByShufflingObjectsInArray:self.dataStore.events];
            
            //empties top card stack
            [self.topRowCollection.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            //repopulating top card stack
            for (NSUInteger i = 0 ; i < 5; i++) {
                
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    
                    Event *event = [shuffledEvents objectAtIndex:i];
                    
                    ActivityCardView *eventActivitycard = [[ActivityCardView alloc]init];
                    eventActivitycard.activity = event;
                    
                    eventActivitycard.translatesAutoresizingMaskIntoConstraints = NO;
                    
                    [self.middleRowCollection registerClass:[ActivityCardCollectionViewCell class] forCellWithReuseIdentifier:@"cardCell"];
                    
                    self.middleRowCollection.delegate = self;
                    self.middleRowCollection.dataSource = self;
                    
                    NSLog(@"Creating NEW card for %@", event.name);
                }];
                
                
            }
        }
    }];
}

-(void)getShuffledRestaurantData{
    
    [self.dataStore getRestaurantsWithCompletion:^(BOOL success) {
        if(success) {
            
            //shuffle restaurants
            GKARC4RandomSource *randomSource = [GKARC4RandomSource new];
            NSArray *shuffledRestaurants = [randomSource arrayByShufflingObjectsInArray:self.dataStore.restaurants];
            
            //empties middle card stack
            [self.middleRowCollection.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            //repopulating middle card stack
            for (NSUInteger i = 0 ; i < 5; i++) {
                
                Restaurant *restaurant = [shuffledRestaurants objectAtIndex:i];
                
                NSInteger maxLat = [self.latitude integerValue] + 0.36;
                NSInteger minLat = [self.latitude integerValue] - 0.36;
                NSInteger maxLng = [self.longitude integerValue] + 0.36;
                NSInteger minLng = [self.longitude integerValue] - 0.36;
                
                if(restaurant.lat >= minLat && restaurant.lat <= maxLat && restaurant.lng >= minLng && restaurant.lng <= maxLng) {
                
                    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                        
                        ActivityCardView *newActivityCard =[[ActivityCardView alloc]init];
                        newActivityCard.activity = restaurant;
                        
                        newActivityCard.translatesAutoresizingMaskIntoConstraints = NO;
                        
                        [self.topRowCollection registerClass:[ActivityCardCollectionViewCell class] forCellWithReuseIdentifier:@"cardCell"];
                        
                        self.topRowCollection.delegate = self;
                        self.topRowCollection.dataSource = self;

                        
                        NSLog(@"Creating NEW card for %@", restaurant.name);
                        
                    }];
                }
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

=======
>>>>>>> master

@end
