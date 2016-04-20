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
#import "Itinerary.h"
#import "ItineraryViewController.h"

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
@property (weak, nonatomic) IBOutlet UIButton *createItineraryButton;
@property (weak, nonatomic) IBOutlet UIButton *randomizeCardsButton;

@end


@implementation CardViewController

- (void)viewDidLoad {
    
    
    
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"city"]]];
    
    [self setUpCoreLocation];

    self.dataStore = [ActivitiesDataStore sharedDataStore];
    
    [self getCardData];
    
    // allocate itinerary
  
    
    self.topRowCollection.backgroundColor = [UIColor clearColor];
    self.middleRowCollection.backgroundColor = [UIColor clearColor];
    self.bottomRowCollection.backgroundColor = [UIColor clearColor];
    

    self.createItineraryButton.backgroundColor = [UIColor colorWithRed:0.36 green:0.80 blue:0.83 alpha:1.00];
    self.randomizeCardsButton.backgroundColor = [UIColor colorWithRed:0.36 green:0.80 blue:0.83 alpha:1.00];

    
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
    
    //listening for check button notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disableCheckedCard:)
                                                 name:@"checkBoxChecked"
                                               object:nil];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}


#pragma mark - Locking/Unlocking Cards
- (void) disableCheckedCard: (NSNotification *) notification {
    
    NSLog(@"cardVC knows check button tapped");
    UIButton *tappedButton = notification.object;
    ActivityCardView * cardCell = (ActivityCardView *)tappedButton.superview.superview;
    UICollectionViewCell *cardCellSuperview = (UICollectionViewCell *)cardCell.superview.superview;
    
    if ([self.topRowCollection indexPathForCell:cardCellSuperview]) {
        self.firstCardLocked = self.firstCardLocked ? NO : YES;
        self.firstCardLocked ? [self disableScroll] : [self enableScroll];
        NSLog(@"this card lives in the topRowCollection");
    }
    else if ([self.middleRowCollection indexPathForCell:cardCellSuperview]) {
        self.secondCardLocked = self.secondCardLocked ? NO : YES;
        self.secondCardLocked ? [self disableScroll] : [self enableScroll];
        NSLog(@"this card lives in the middleRowCollection");
    }
    else {
        self.thirdCardLocked = self.thirdCardLocked ? NO : YES;
        self.thirdCardLocked ? [self disableScroll] : [self enableScroll];
        NSLog(@"this card lives in the bottomRowCollection");
    }
}

// disables scroll when card is locked
- (void) disableScroll {
    if(self.firstCardLocked) {
        self.topRowCollection.scrollEnabled = NO;
    }
    if(self.secondCardLocked) {
        self.middleRowCollection.scrollEnabled = NO;
    }
    if(self.thirdCardLocked) {
        self.bottomRowCollection.scrollEnabled = NO;
    }
    
}

// enables scroll when card is unlocked
- (void) enableScroll {
    if(!self.firstCardLocked) {
        self.topRowCollection.scrollEnabled = YES;
    }
    if(!self.secondCardLocked) {
        self.middleRowCollection.scrollEnabled = YES;
    }
    if(!self.thirdCardLocked) {
        self.bottomRowCollection.scrollEnabled = YES;
    }
    
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

#pragma mark - Save Itinerary Button



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


- (IBAction)SaveItineraryButtonTapped:(id)sender {
  
    NSMutableArray *activitiesArray = [NSMutableArray new];
    
    self.itinerary = [[Itinerary alloc]initWithActivities:activitiesArray userID:@"" creationDate:[NSDate date]];
    
    ActivityCardCollectionViewCell *topCell = [[self.topRowCollection visibleCells] firstObject];
    Activity *topCellActivity = topCell.cardView.activity;
    
    ActivityCardCollectionViewCell *middleCell = [[self.middleRowCollection visibleCells] firstObject];
    Activity *middleCellActivity = middleCell.cardView.activity;
    
    ActivityCardCollectionViewCell *bottomCell = [[self.bottomRowCollection visibleCells]firstObject];
    Activity *bottomCellActivity = bottomCell.cardView.activity;
    
    
    [self.itinerary.activities addObject:topCellActivity];
    [self.itinerary.activities addObject:middleCellActivity];
    [self.itinerary.activities addObject:bottomCellActivity];
    NSLog(@"Activities !! : %@",self.itinerary.activities); 
    
    [self performSegueWithIdentifier:@"ItinerarySegue" sender:nil]; 
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"detailSegue" sender: (ActivityCardCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath]];
    
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"detailSegue"]) {
        
        DetailViewController *destinationVC = [segue destinationViewController];
        
        destinationVC.activity = ((ActivityCardCollectionViewCell *)sender).cardView.activity;
    }
    if ([segue.identifier isEqualToString:@"ItinerarySegue"]) {
         ItineraryViewController *destinationVC = [segue destinationViewController];
        destinationVC.itinerary = self.itinerary;
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
    if(!self.thirdCardLocked) {
        [self.bottomRowCollection shake:15   // 15 times
                              withDelta:20   // 20 points wide
         ];
    }

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
        if(!self.thirdCardLocked) {
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
//
//
// This method will be used to handle the card scroll views' reactions and delay page-turning
//-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
////    CGPoint quoVadis = *targetContentOffset;
////    targetContentOffset->y
//
//    CGPoint newOffset = CGPointZero;
//    *targetContentOffset = newOffset;
//}
//
//
///* ADRIAN"S TicketMaster Event Setup ** vvvv
// 
// 
// - (void)setupLocationManager {
// self.locationManager = [[CLLocationManager alloc] init];
// self.locationManager.delegate = self;
// self.locationManager.distanceFilter = kCLDistanceFilterNone;
// self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
// [self.locationManager requestWhenInUseAuthorization];
// [self getTheUsersCurrentLocation];
// }
// 
// - (void)getTheUsersCurrentLocation {
// after this method fires off, the locationManager didUpdateLocations method below gets called (behind the scenes by the startUpdatingLocation)
// [self.locationManager startUpdatingLocation];
// }
// 
// 
// 
// -(void)getEvents {
// [self.ticketMasterDataStore getEventsForLocation:self.mostRecentLocation withCompletion:^(BOOL success) {
// if (success) {
// [[NSOperationQueue mainQueue]addOperationWithBlock:^{
//  [self.tableView reloadData];
// }];
// }
// }];
// }
// 
//// 
// */




#pragma mark - Button Things

// Segue to itinerary view
- (IBAction)saveButtonPressed:(UIButton *)sender {
    
    


}


- (IBAction)randomButtonPressed:(UIButton *)sender {
}



- (IBAction)filterButtonPressed:(UIBarButtonItem *)sender {


}

@end
