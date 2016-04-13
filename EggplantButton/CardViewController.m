//
//  ContainerViewController.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 3/31/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UIView+Shake.h"
#import "CardViewController.h"
#import "EggplantButton-Swift.h"
#import "ActivitiesDataStore.h"
#import "ActivityCardCollectionViewCell.h"


@class Restaurant;

//MFMessageControlViewController


@interface CardViewController () <UIScrollViewDelegate, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) ActivitiesDataStore *dataStore;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *mostRecentLocation;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;

@property (weak, nonatomic) IBOutlet UICollectionView *topRowCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *middleRowCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *bottomRowCollection;



@end

@implementation CardViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nyc"]]];
    
    [self setUpCoreLocation];

    self.dataStore = [ActivitiesDataStore sharedDataStore];
    
    [self getTicketMasterData];
    
    [self getRestaurantData];
    
    self.topRowCollection.backgroundColor = [UIColor clearColor];
    self.middleRowCollection.backgroundColor = [UIColor clearColor];
    self.bottomRowCollection.backgroundColor = [UIColor clearColor];
    
#warning FIREBASE THINGS FOR TESTING. REMOVE LATER
    //    // Instantiate new instance of the Firebase API Client
    //    FirebaseAPIClient *firebaseAPI = [[FirebaseAPIClient alloc] init];
    
    //    // Create and save test image to Firebase
    //    UIImage *image = [UIImage imageNamed:@"EasyOutLaunchScreenImage"];
    //    NSString *imageID = [firebaseAPI createNewImageWithImage:image];
    //    NSLog(@"Image saved to Firebase with ID: %@", imageID);
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

#pragma mark - get API data

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
    
    NSLog(@"PICKED CELL %lu", indexPath.row);
    
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UICollectionViewCell *)sender {
    
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
        
        //makes the phone vibrate
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




#pragma button things

- (IBAction)saveButtonPressed:(UIButton *)sender {
    
    


}


- (IBAction)randomButtonPressed:(UIButton *)sender {
}


@end
