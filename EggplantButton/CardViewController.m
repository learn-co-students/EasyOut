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
#import "Secrets.h"
#import "Firebase.h"

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
    
    [self getCardData];
    
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
    
    //listening for shake gesture notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shakeStarted:)
                                                 name:@"shakeStarted"
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
    
    Firebase *ref = [[Firebase alloc] initWithUrl:firebaseRootRef];
    
    [ref unauth];
    
    NSLog(@"user is logged out");
    
}


#pragma mark - Get API data

-(void)getCardData{
    
    for(UICollectionView *collectionView in @[self.topRowCollection, self.middleRowCollection, self.bottomRowCollection ]) {
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        [collectionView registerClass:[ActivityCardCollectionViewCell class] forCellWithReuseIdentifier:@"cardCell"];

    }
    
    NSArray *topRowOptions = @[@"arts", @"outdoors", @"sights"];
    
    [self.dataStore getActivityforSection:topRowOptions[arc4random()%topRowOptions.count] Location:[NSString stringWithFormat:@"%@,%@",self.latitude, self.longitude] WithCompletion:^(BOOL success) {
        
        if (success) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.topRowCollection reloadData];
            }];
        }

    }];
    
    [self.dataStore getActivityforSection:@"food"Location:[NSString stringWithFormat:@"%@,%@",self.latitude,self.longitude] WithCompletion:^(BOOL success) {
        
        if (success) {

            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.middleRowCollection reloadData];
            }];
        }

    }];
    
    [self.dataStore getActivityforSection:@"drinks" Location:[NSString stringWithFormat:@"%@,%@",self.latitude,self.longitude] WithCompletion:^(BOOL success) {
        
        
        if (success) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.bottomRowCollection reloadData];
            }];
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
        return self.dataStore.randoms.count;
    }
    else if (collectionView == self.middleRowCollection) {
        return self.dataStore.restaurants.count;
    }
    else {
        return self.dataStore.drinks.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ActivityCardCollectionViewCell *cell = (ActivityCardCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cardCell" forIndexPath:indexPath];
    
    if(collectionView == self.topRowCollection) {
        
        Activity *randomActivity = self.dataStore.randoms[indexPath.row];
        cell.cardView.activity = randomActivity;
        
    }
    else if (collectionView == self.middleRowCollection) {
        
        Activity *restaurantActivity = self.dataStore.restaurants[indexPath.row];
        cell.cardView.activity = restaurantActivity;
                
    }
    else {
        Activity *drinksActivity = self.dataStore.drinks[indexPath.row];
        cell.cardView.activity = drinksActivity;
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


#pragma mark - Randomize Button

- (IBAction)randomizeTapped:(id)sender {
    
    // makes the phone vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    [self shuffleCards];
    
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


#pragma mark - Shake Gesture

- (void) shakeStarted: (NSNotification *) notification {
{
        // makes the phone vibrate
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        [self shuffleCards];
        
        if(!self.firstCardLocked) {
            [self.topRowCollection shake:15     // 15 times
                               withDelta:20     // 20 points wide
             ];
        }
        if(!self.secondCardLocked) {
            [self.middleRowCollection shake:15   // 15 times
                                  withDelta:20   // 20 points wide
             ];
        }
        if(!self.bottomRowCollection) {
            [self.bottomRowCollection shake:15   // 15 times
                                  withDelta:20   // 20 points wide
             ];
        }
        
    }
}



-(void)shuffleCards{
    GKARC4RandomSource *randomSource = [GKARC4RandomSource new];
    
    if(!self.firstCardLocked) {
        self.dataStore.randoms = [[randomSource arrayByShufflingObjectsInArray:self.dataStore.randoms] mutableCopy];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.topRowCollection reloadData];
        }];
    }
    if(!self.secondCardLocked) {
        self.dataStore.restaurants = [[randomSource arrayByShufflingObjectsInArray:self.dataStore.restaurants] mutableCopy];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.middleRowCollection reloadData];
        }];
    }
    if(!self.thirdCardLocked) {
        self.dataStore.drinks = [[randomSource arrayByShufflingObjectsInArray:self.dataStore.drinks] mutableCopy];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.bottomRowCollection reloadData];
        }];
    }
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

// Segue to itinerary view
- (IBAction)saveButtonPressed:(UIButton *)sender {
    
    


}


- (IBAction)randomButtonPressed:(UIButton *)sender {
}



- (IBAction)filterButtonPressed:(UIBarButtonItem *)sender {


}

@end
