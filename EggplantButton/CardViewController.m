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
#import "Constants.h"
#import "UIView+Shake.h"
#import <AudioToolbox/AudioServices.h>


@interface CardViewController () <UIScrollViewDelegate, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) ActivitiesDataStore *dataStore;
@property (strong, nonatomic) Itinerary *itinerary;

// LOCATION
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *mostRecentLocation;
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

// COLLECTIONS
@property (weak, nonatomic) IBOutlet UICollectionView *topRowCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *middleRowCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *bottomRowCollection;

// CARD PROPERTIES
@property (nonatomic) BOOL firstCardLocked;
@property (nonatomic) BOOL secondCardLocked;
@property (nonatomic) BOOL thirdCardLocked;

// BUTTONS
@property (weak, nonatomic) IBOutlet UIButton *createItineraryButton;
@property (weak, nonatomic) IBOutlet UIButton *randomizeCardsButton;

// SPINNER
@property (strong, nonatomic) UIActivityIndicatorView * spinner;

@end


@implementation CardViewController

- (void) viewWillAppear:(BOOL)animated {
    self.spinner = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.center = CGPointMake((self.view.frame.size.width/2), (self.view.frame.size.height/2));
    self.spinner.hidesWhenStopped = YES;
    [self.spinner startAnimating];
    [self.view addSubview:self.spinner];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.spinner removeFromSuperview];
}

- (void)viewDidLoad {

    [super viewDidLoad];

    // Create weak reference to self so setup can take place within Core Location setup block
    __weak typeof(self) weakSelf = self;

    // Wait for Core Location to be set up before setting up the data store and getting card data
    [self setUpCoreLocationWithCompletion:^(bool success) {
        if (success) {
            
            // Set up data store and cards
            [weakSelf initializeCards];
            
        } else {
            
            // Show an alert letting the user know we don't have location information
            [weakSelf showNoLocationAlert];
        }
    }];

    // Set appearances of this view controller
    [self setAppearances];

    // Add notification center observers
    [self addNCObservers];
}


#pragma mark - Locking/Unlocking Cards
- (void) disableCheckedCard: (NSNotification *) notification {

    UIButton *tappedButton = notification.object;
    ActivityCardView * cardCell = (ActivityCardView *)tappedButton.superview.superview;
    UICollectionViewCell *cardCellSuperview = (UICollectionViewCell *)cardCell.superview.superview;

    if ([self.topRowCollection indexPathForCell:cardCellSuperview]) {
        self.firstCardLocked = self.firstCardLocked ? NO : YES;
        self.firstCardLocked ? [self disableScroll] : [self enableScroll];

    }
    else if ([self.middleRowCollection indexPathForCell:cardCellSuperview]) {
        self.secondCardLocked = self.secondCardLocked ? NO : YES;
        self.secondCardLocked ? [self disableScroll] : [self enableScroll];

    }
    else {
        self.thirdCardLocked = self.thirdCardLocked ? NO : YES;
        self.thirdCardLocked ? [self disableScroll] : [self enableScroll];

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
}

- (void) profileButtonTapped: (NSNotification *) notification {

    UIViewController *userProfileVC = [[UIStoryboard storyboardWithName:@"UserProfile" bundle:nil] instantiateViewControllerWithIdentifier:@"userSegue"];

    [self.navigationController showViewController:userProfileVC sender:nil];
}

- (void) pastItinerariesButtonTapped: (NSNotification *) notification {

    UIViewController *pastItinerariesVC = [[UIStoryboard storyboardWithName:@"ItineraryHistoryView" bundle:nil] instantiateViewControllerWithIdentifier:@"ItineraryHistoryTableViewController"];

    [self.navigationController showViewController:pastItinerariesVC sender:nil];
}

- (void) logoutButtonTapped: (NSNotification *) notification {

    [FirebaseAPIClient logOutUser];
}


#pragma mark - Get API data

-(void)getCardData{

    for(UICollectionView *collectionView in @[self.topRowCollection, self.middleRowCollection, self.bottomRowCollection ]) {

        collectionView.delegate = self;
        collectionView.dataSource = self;

        [collectionView registerClass:[ActivityCardCollectionViewCell class] forCellWithReuseIdentifier:@"cardCell"];
    }

    NSArray *topRowOptions = @[@"arts", @"sights"];

    [self.dataStore getActivityforSection:topRowOptions[arc4random()%topRowOptions.count] Location:[NSString stringWithFormat:@"%f,%f",self.latitude,self.longitude] WithCompletion:^(BOOL success) {

        if (success) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.topRowCollection reloadData];
            }];
        }
    }];

    [self.dataStore getActivityforSection:@"food"Location:[NSString stringWithFormat:@"%f,%f",self.latitude,self.longitude] WithCompletion:^(BOOL success) {

        if (success) {

            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.middleRowCollection reloadData];
            }];
        }
    }];

    [self.dataStore getActivityforSection:@"drinks" Location:[NSString stringWithFormat:@"%f,%f",self.latitude,self.longitude] WithCompletion:^(BOOL success) {


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

    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 240);
    spinner.hidesWhenStopped = YES;
    [cell.cardView addSubview:spinner];
    [spinner startAnimating];

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
        destinationVC.latitude = self.latitude;
        destinationVC.longitude = self.longitude;
    }
    if ([segue.identifier isEqualToString:@"ItinerarySegue"]) {
        ItineraryViewController *destinationVC = [segue destinationViewController];
        destinationVC.itinerary = self.itinerary;
        destinationVC.latitude = self.latitude;
        destinationVC.longitude = self.longitude;
    }
}


#pragma mark - Core Location

-(void)setUpCoreLocationWithCompletion:(void (^)(bool success))completion {

    NSLog(@"Setting up Core Location");

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }

    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    if (self.latitude != 0) {
        NSLog(@"Latitude: %f\nLongitude: %f", self.latitude, self.longitude);
        completion(YES);
    } else {
        NSLog(@"Can't find location");
        completion(NO);
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    NSLog(@"didUpdateLocation called - %@", locations.lastObject);

    if (self.mostRecentLocation == nil) {
        self.mostRecentLocation = [locations lastObject];
    }
    
    self.latitude = self.locationManager.location.coordinate.latitude;
    self.longitude = self.locationManager.location.coordinate.longitude;
    
    [self.locationManager stopUpdatingLocation];
}


#pragma mark - Randomize Button

- (IBAction)randomizeTapped:(id)sender {

    // makes the phone vibrate
    AudioServicesPlayAlertSound(1352);
    
    [self shuffleCards];

    if(!self.firstCardLocked) {
        [self.topRowCollection shake:10     // 10 times
                           withDelta:10     // 10 points wide
         ];
    }
    if(!self.secondCardLocked) {
        [self.middleRowCollection shake:10   // 10 times
                              withDelta:10   // 10 points wide
         ];
    }
    if(!self.thirdCardLocked) {
        [self.bottomRowCollection shake:10   // 10 times
                              withDelta:10   // 10 points wide
         ];
    }
}


#pragma mark - Save Itinerary Button Tapped

- (IBAction)SaveItineraryButtonTapped:(id)sender {

    NSMutableArray *activitiesArray = [NSMutableArray new];

    self.itinerary = [[Itinerary alloc]initWithActivities:activitiesArray userID:@"" creationDate:[NSDate date]];

    if (self.firstCardLocked) {
        ActivityCardCollectionViewCell *topCell = [[self.topRowCollection visibleCells] firstObject];
        Activity *topCellActivity = topCell.cardView.activity;
        [self.itinerary.activities addObject:topCellActivity];

    }else {
        // do nothing

    } if (self.secondCardLocked) {

        ActivityCardCollectionViewCell *middleCell = [[self.middleRowCollection visibleCells] firstObject];
        Activity *middleCellActivity = middleCell.cardView.activity;
        [self.itinerary.activities addObject:middleCellActivity];

    }
    else {
        // do nothing
    } if (self.thirdCardLocked) {

        ActivityCardCollectionViewCell *bottomCell = [[self.bottomRowCollection visibleCells]firstObject];
        Activity *bottomCellActivity = bottomCell.cardView.activity;
        [self.itinerary.activities addObject:bottomCellActivity];


    } else {
        // do nothing
    }

    if (!self.firstCardLocked && !self.secondCardLocked && !self.thirdCardLocked ) {

        UIAlertController *chooseOneItinerary= [UIAlertController alertControllerWithTitle:@"Oops!"
                                                                                message:@"Please choose one or more activities"
                                                                         preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [chooseOneItinerary dismissViewControllerAnimated:YES completion:nil];
                                                         }];

        [chooseOneItinerary addAction:okAction];

        [self presentViewController:chooseOneItinerary animated:YES completion:nil];
    };

    if (self.firstCardLocked || self.secondCardLocked || self.thirdCardLocked) {
        
        // Save Itinerary to FireBase
        [FirebaseAPIClient saveItineraryWithItinerary:self.itinerary completion:^(NSString * savedItinerary) {
            NSLog(@" Itinerary saved : %@",savedItinerary);
        }];
        
        [self performSegueWithIdentifier:@"ItinerarySegue" sender:nil];
    }
}


#pragma mark - Shake Gesture

- (void) shakeStarted:(NSNotification *) notification {

    AudioServicesPlayAlertSound(1352);

    [self shuffleCards];


    if(!self.firstCardLocked) {
        [self.topRowCollection shake:10     // 10 times
                           withDelta:10     // 10 points wide
         ];
    }
    if(!self.secondCardLocked) {
        [self.middleRowCollection shake:10   // 10 times
                              withDelta:10   // 10 points wide
         ];
    }
    if(!self.thirdCardLocked) {
        [self.bottomRowCollection shake:10   // 10 times
                              withDelta:10   // 10 points wide
         ];
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

- (void)addNCObservers {

    // Listening for segue notifications from sideMenu
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

    // Listening for shake gesture notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shakeStarted:)
                                                 name:@"shakeStarted"
                                               object:nil];

    // Listening for check button notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disableCheckedCard:)
                                                 name:@"checkBoxChecked"
                                               object:nil];
}

- (void)setAppearances {

    self.view.backgroundColor = [UIColor clearColor];

    // Set background of card collections to be clear
    self.topRowCollection.backgroundColor = [UIColor clearColor];
    self.middleRowCollection.backgroundColor = [UIColor clearColor];
    self.bottomRowCollection.backgroundColor = [UIColor clearColor];

    // Set appearance of bottom buttons
    self.createItineraryButton.backgroundColor = [Constants vikingBlueColor];
    self.randomizeCardsButton.backgroundColor = [Constants vikingBlueColor];
    self.createItineraryButton.titleLabel.font = [UIFont fontWithName:@"Lobster Two" size:20.0f];
    self.randomizeCardsButton.titleLabel.font = [UIFont fontWithName:@"Lobster Two" size:20.0f];


    // Set appearance of navigation bar
    self.navigationController.navigationBar.topItem.title = @"EasyOut";
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                       NSFontAttributeName:[UIFont fontWithName:@"Lobster Two" size:30]}];
}

- (void)showNoLocationAlert {
    
    UIAlertController * alert= [UIAlertController alertControllerWithTitle:@"Uh oh! Looks like your location is unavailable."
                                                                   message: [NSString stringWithFormat:@"Please allow EasyOut to use your location from your phone's settings so we can show you neat activities nearby :)"]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {

       // Create weak reference to self so setup can take place within Core Location setup block
       __weak typeof(self) weakSelf = self;
       
       // Wait for Core Location to be set up before setting up the data store and getting card data
       [self setUpCoreLocationWithCompletion:^(bool success) {
           
           if (success) {
               
               // Set up the data store and cards
               [weakSelf initializeCards];
               
           } else {
               
               // Show an alert letting the user know we don't have location information
               [weakSelf showNoLocationAlert];
           }
       }];
       
       [alert dismissViewControllerAnimated:YES completion:nil];
   }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}
    
- (void) initializeCards {
    // Create weak reference to self so setup can take place within Core Location setup block
    __weak typeof(self) weakSelf = self;

    // Setup the data store
    weakSelf.dataStore = [ActivitiesDataStore sharedDataStore];
    
    // Get card data
    [weakSelf getCardData];
}

@end
