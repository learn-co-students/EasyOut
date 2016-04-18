 //
//  ContainerViewController.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 3/31/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//


#import "CardViewController.h"
#import "EggplantButton-Swift.h"

#import "ActivitiesDataStore.h"
#import "ActivityCardCollectionViewCell.h"
#import "mainContainerViewController.h"
#import "sideMenuViewController.h"

#import "UIView+Shake.h"



@class Restaurant;

//MFMessageControlViewController

@interface CardViewController () <UIScrollViewDelegate, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) ActivitiesDataStore *dataStore;

@property (strong, nonatomic) Itinerary *itinerary;


//LOCATION
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *mostRecentLocation;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;

//COLLECTIONS
@property (weak, nonatomic) IBOutlet UICollectionView *topRowCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *middleRowCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *bottomRowCollection;

//CARD PROPERTIES
@property (nonatomic) BOOL firstCardLocked;
@property (nonatomic) BOOL secondCardLocked;
@property (nonatomic) BOOL thirdCardLocked;


//BUTTONS


@end

@implementation CardViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"city"]]];
    
    [self setUpCoreLocation];

    self.dataStore = [ActivitiesDataStore sharedDataStore];
    
    [self getTicketMasterData];
    
    [self getRestaurantData];
    
    self.topRowCollection.backgroundColor = [UIColor clearColor];
    self.middleRowCollection.backgroundColor = [UIColor clearColor];
    self.bottomRowCollection.backgroundColor = [UIColor clearColor];
    
    // listening for segue notifications from sideMenu
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(profileButtonTapped:)
                                                 name:@"profileButtonTapped"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pastItinerariesButtonTapped:)
                                                 name:@"pastItinerariesButtonTapped"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logoutButtonTapped:)
                                                 name:@"logoutButtonTapped"
                                               object:nil];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

#pragma mark - Side Menu

- (IBAction)menuButtonTapped:(UIBarButtonItem *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuButtonTapped"
                                                        object:nil];
    NSLog(@"menu button tapped!");
}

- (void) profileButtonTapped: (NSNotification *) notification {
    NSLog(@"cardVC knows that the profile button was tapped!");
    
    
    UIViewController *userProfileVC = [[UIStoryboard storyboardWithName:@"UserProfile" bundle:nil] instantiateViewControllerWithIdentifier:@"userSegue"];
    
    [self.navigationController showViewController:userProfileVC sender:nil];
}

- (void) pastItinerariesButtonTapped: (NSNotification *) notification {
    NSLog(@"cardVC knows that the past itineraries button was tapped!");
    
    
    UIViewController *pastItinerariesVC = [[UIStoryboard storyboardWithName:@"ItineraryHistoryView" bundle:nil] instantiateViewControllerWithIdentifier:@"pastItineraries"];
    
    [self.navigationController showViewController:pastItinerariesVC sender:nil];
}

- (void) logoutButtonTapped: (NSNotification *) notification {
    NSLog(@"cardVC knows that the logout button was tapped!");
    
    UIViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [self.navigationController showViewController:loginVC sender:nil];
}


#pragma mark - Get API data

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

#pragma mark - Collection View

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
        
    }
    else if (collectionView == self.middleRowCollection) {
        
        Activity *eventActivity = self.dataStore.events[indexPath.row];
        cell.cardView.activity = eventActivity;
                
    }

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"detailSegue" sender: (ActivityCardCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath]];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"detailSegue"]) {
    
    DetailViewController *destinationVC = [segue destinationViewController];
    
    destinationVC.activity = ((ActivityCardCollectionViewCell *)sender).cardView.activity;
    }
    else if ([segue.identifier isEqualToString:@"filterSegue"]) {
        
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
    
    self.latitude = [NSString stringWithFormat: @"%f", self.locationManager.location.coordinate.latitude];
    self.longitude = [NSString stringWithFormat: @"%f", self.locationManager.location.coordinate.longitude];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (self.mostRecentLocation == nil) {
        
        self.mostRecentLocation = [locations lastObject];
        
    }
    
    [self.locationManager stopUpdatingLocation];
}



#pragma mark - Shake Gesture

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ( event.subtype == UIEventSubtypeMotionShake )
    {
        NSLog(@"Shake started");
        
        // makes the phone vibrate
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        [self getShuffledTicketMasterData];
        
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

-(void)getShuffledRestaurantData{
    
    [self.dataStore getRestaurantsWithCompletion:^(BOOL success) {
        if(success) {
            
            //shuffle restaurants
            GKARC4RandomSource *randomSource = [GKARC4RandomSource new];
            self.dataStore.restaurants = [[randomSource arrayByShufflingObjectsInArray:self.dataStore.restaurants] mutableCopy];
            
            //reloading top collection
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.topRowCollection reloadData];
            }];
            NSLog(@"topRow reloaded");
            
        }
        
    }];
    
}

-(void)getShuffledTicketMasterData{
    
    [self.dataStore getEventsForLat:self.latitude lng:self.longitude withCompletion:^(BOOL success) {
        if (success) {
            //shuffle events
            GKARC4RandomSource *randomSource = [GKARC4RandomSource new];
            self.dataStore.events = [[randomSource arrayByShufflingObjectsInArray:self.dataStore.events]mutableCopy];

            //reloading middle collection
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.middleRowCollection reloadData];
            }];
            NSLog(@"middleRow reloaded");
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




#pragma mark - Button Things

- (IBAction)saveButtonPressed:(UIButton *)sender {
    
    


}


- (IBAction)randomButtonPressed:(UIButton *)sender {
}



- (IBAction)filterButtonPressed:(UIBarButtonItem *)sender {


}

@end
