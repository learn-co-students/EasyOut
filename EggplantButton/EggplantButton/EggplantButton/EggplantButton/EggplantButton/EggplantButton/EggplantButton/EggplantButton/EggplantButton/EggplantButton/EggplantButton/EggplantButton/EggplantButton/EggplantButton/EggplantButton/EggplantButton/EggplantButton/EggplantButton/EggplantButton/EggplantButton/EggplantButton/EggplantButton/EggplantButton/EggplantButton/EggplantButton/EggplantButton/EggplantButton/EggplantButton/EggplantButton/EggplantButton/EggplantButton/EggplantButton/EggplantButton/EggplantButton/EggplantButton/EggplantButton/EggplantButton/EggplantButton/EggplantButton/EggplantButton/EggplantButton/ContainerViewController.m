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
#import "ActivityCardView.h"
#import "ActivitiesDataStore.h"
<<<<<<< HEAD
#import "ActivityCardCollectionViewCell.h"
#import "Activity.h"

=======
>>>>>>> origin
#import "Restaurant.h"
#import "Event.h"

@class Restaurant;


<<<<<<< HEAD
//MFMessageControlViewController


@interface ContainerViewController () <UIScrollViewDelegate, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
=======
@interface ContainerViewController () <UIScrollViewDelegate, CLLocationManagerDelegate >
>>>>>>> origin

@property (strong, nonatomic) ActivitiesDataStore *dataStore;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *mostRecentLocation;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;

<<<<<<< HEAD
@property (weak, nonatomic) IBOutlet UICollectionView *topRowCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *middleRowCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *bottomRowCollection;
=======
@property (strong, strong) NSLayoutDimension *cardHeightAnchor;
@property (strong, strong) NSLayoutDimension *cardWidthAnchor;


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
>>>>>>> origin


@end

@implementation ContainerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
<<<<<<< HEAD
    [self setUpCoreLocation];

    self.dataStore = [ActivitiesDataStore sharedDataStore];
    
    [self getTicketMasterData];
=======
    //LOCATION THINGS
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
>>>>>>> origin
    
    [self getRestaurantData];
    
<<<<<<< HEAD
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
=======
    //DATA THINGS
    // Call in the shared data store
    self.dataStore = [ActivitiesDataStore sharedDataStore];
>>>>>>> origin
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
<<<<<<< HEAD
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


=======
    //    [self getRestaurantData];
    
    // Instantiate new instance of the Firebase API Client
    FirebaseAPIClient *firebaseAPI = [[FirebaseAPIClient alloc] init];
    
    // Create and save test image to Firebase
    UIImage *image = [UIImage imageNamed:@"EasyOutLaunchScreenImage"];
    NSString *imageID = [firebaseAPI createNewImageWithImage:image];
    NSLog(@"Image saved to Firebase with ID: %@", imageID);
    
    // Create and save test user to Firebase
    
    // Create and save test itinerary to Firebase
    
    // Set default card height and width anchors
    self.cardHeightAnchor = self.topCardScrollView.heightAnchor;
    self.cardWidthAnchor = self.topCardScrollView.widthAnchor;
    
    // Create cards for each activity in the shared data store
//    [self.dataStore getRestaurantsWithCompletion:^(BOOL success) {
//        if(success) {
//            
//            for(Restaurant *restaurant in self.dataStore.restaurants) {
//                
//                
//                ActivityCardView *newActivityCard =[[ActivityCardView alloc]init];
//                newActivityCard.activity = restaurant;
//                
//                newActivityCard.translatesAutoresizingMaskIntoConstraints = NO;
//                newActivityCard.translatesAutoresizingMaskIntoConstraints = NO;
//                
//                [self.middleCardStackView addArrangedSubview: newActivityCard];
//                
//                [newActivityCard.heightAnchor constraintEqualToAnchor:self.cardHeightAnchor].active = YES;
//                [newActivityCard.widthAnchor constraintEqualToAnchor:self.cardWidthAnchor].active = YES;
//            }
//        }
//    }];

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


-(void)viewWillAppear:(BOOL)animated {
    
//    NSLog(@"Contianer view will appear");
    
}
>>>>>>> origin

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

-(void)getRestaurantData{
    
    [self.dataStore getRestaurantsWithCompletion:^(BOOL success) {
        if(success) {
            
            for(Restaurant *restaurant in self.dataStore.restaurants) {
<<<<<<< HEAD
//
//                NSInteger maxLat = [self.latitude integerValue] + 0.36;
//                NSInteger minLat = [self.latitude integerValue] - 0.36;
//                NSInteger maxLng = [self.longitude integerValue] + 0.36;
//                NSInteger minLng = [self.longitude integerValue] - 0.36;
// 
//                if(restaurant.lat >= minLat && restaurant.lat <= maxLat && restaurant.lng >= minLng && restaurant.lng <= maxLng) {
            
=======
                
                NSInteger maxLat = [self.latitude integerValue] + 0.36;
                NSInteger minLat = [self.latitude integerValue] - 0.36;
                NSInteger maxLng = [self.longitude integerValue] + 0.36;
                NSInteger minLng = [self.longitude integerValue] - 0.36;
                
                if(restaurant.lat >= minLat && restaurant.lat <= maxLat && restaurant.lng >= minLng && restaurant.lng <= maxLng) {
                    
>>>>>>> origin
                    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                        
                        ActivityCardView *newActivityCard =[[ActivityCardView alloc]init];
                        newActivityCard.activity = restaurant;
                        
                        [self.topRowCollection registerClass:[ActivityCardCollectionViewCell class] forCellWithReuseIdentifier:@"cardCell"];
                        
                        self.topRowCollection.delegate = self;
                        self.topRowCollection.dataSource = self;

                        
<<<<<<< HEAD
=======
                        [newActivityCard.heightAnchor constraintEqualToAnchor:self.middleCardScrollView.heightAnchor].active = YES;
                        [newActivityCard.widthAnchor constraintEqualToAnchor:self.middleCardScrollView.widthAnchor].active = YES;
                        
                        NSLog(@"Creating card for %@", restaurant.name);

>>>>>>> origin
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
<<<<<<< HEAD
=======
                
                
>>>>>>> origin
            }
        }
    }];
}


<<<<<<< HEAD
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
=======
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ( event.subtype == UIEventSubtypeMotionShake )
    {
        
        NSLog(@"Shake started");
        
        // Shake top card with the default speed
        [self.topCardStackView shake:15     // 15 times
                           withDelta:20     // 20 points wide
         ];
        // Shake middle card with the default speed
        [self.middleCardStackView shake:15   // 15 times
                              withDelta:20   // 20 points wide
         ];
        // Shake bottom card with the default speed
        [self.bottomCardStackView shake:15   // 15 times
                              withDelta:20   // 20 points wide
         ];
        
        //shuffle restaurants
        GKARC4RandomSource *randomSource = [GKARC4RandomSource new];
        NSArray *shuffledRestaurants = [randomSource arrayByShufflingObjectsInArray:self.dataStore.restaurants];
        
        //empties middle card stack
        [self.middleCardStackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        //repopulating middle card stack
        for (NSUInteger i = 0 ; i < 3; i++) {
            
            Restaurant *restaurant = [shuffledRestaurants objectAtIndex:i];
            
            NSLog(@"Creating NEW card for %@", restaurant.name);
            
            ActivityCardView *newActivityCard =[[ActivityCardView alloc]init];
            newActivityCard.activity = restaurant;
            
            newActivityCard.translatesAutoresizingMaskIntoConstraints = NO;
            
            [self.middleCardStackView addArrangedSubview:newActivityCard];
            
            
            [newActivityCard.heightAnchor constraintEqualToAnchor:self.middleCardScrollView.heightAnchor].active = YES;
            [newActivityCard.widthAnchor constraintEqualToAnchor:self.middleCardScrollView.widthAnchor].active = YES;
            
            
        }
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
>>>>>>> origin


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

<<<<<<< HEAD



-(void)viewWillAppear:(BOOL)animated {
    
}



=======
>>>>>>> origin
@end
