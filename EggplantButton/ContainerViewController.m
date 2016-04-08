//
//  ContainerViewController.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 3/31/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "ContainerViewController.h"
#import "RestaurantDataStore.h"
#import "ActivityCardView.h"
#import "Restaurant.h"
#import <UIView+Shake.h>


#import "TicketMasterDataStore.h"
#import "TicketMasterEvent.h"
#import "TicketMasterAPIClient.h"
#import <CoreLocation/CoreLocation.h>

@class Restaurant;



@interface ContainerViewController () <UIScrollViewDelegate, CLLocationManagerDelegate >

@property (strong, nonatomic) RestaurantDataStore *dataStore;
@property (strong, nonatomic) TicketMasterDataStore *ticketMasterDataStore;

//location Services
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *mostRecentLocation;

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
    
    // Call in the shared data store
    self.dataStore = [RestaurantDataStore sharedDataStore];
    self.ticketMasterDataStore = [TicketMasterDataStore sharedDataStore];
    
    // this method ask's user for permission to use location
    //[self setupLocationManager];

    
    // Create cards for each activity in the shared data store
    [self.dataStore getRestaurantsWithCompletion:^(BOOL success) {
        if(success) {
            
            for(Restaurant *restaurant in self.dataStore.restaurants) {

                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    
                    ActivityCardView *newActivityCard =[[ActivityCardView alloc]init];
                    newActivityCard.restaurant = restaurant;
                    
                    newActivityCard.translatesAutoresizingMaskIntoConstraints = NO;
                    
                    [self.middleCardStackView addArrangedSubview: newActivityCard];
                    
                    [newActivityCard.heightAnchor constraintEqualToAnchor:self.topCardScrollView.heightAnchor].active = YES;
                    [newActivityCard.widthAnchor constraintEqualToAnchor:self.topCardScrollView.widthAnchor].active = YES;
                }];
                
            }
        }
        
        //[self getTicketMasterEvents];

    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
- (void)locationManager:(CLLocationManager *)manager
      didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    NSLog(@"location manager did update locations");
    if (self.mostRecentLocation == nil) {
        
        self.mostRecentLocation = [locations lastObject];
        
        if (self.mostRecentLocation != nil) {
            [self getEvents];
        }
    }
    [self.locationManager stopUpdatingLocation];
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


-(void)getTicketMasterEvents {
    
    [self.ticketMasterDataStore getEventsForLocation:_mostRecentLocation withCompletion:^(BOOL success) {
        if (success) {
            for (TicketMasterEvent *event in self.ticketMasterDataStore.allEvents) {
                NSLog(@"Creating card for %@",event.name);
                
                ActivityCardView *eventActivitycard = [[ActivityCardView alloc]init];
                eventActivitycard.event = event;
                
                eventActivitycard.translatesAutoresizingMaskIntoConstraints = NO;
                
                [self.topCardStackView addArrangedSubview:eventActivitycard];
                
                [eventActivitycard.heightAnchor constraintEqualToAnchor: self.topCardScrollView.heightAnchor].active = YES;
                [eventActivitycard.widthAnchor constraintEqualToAnchor: self.topCardScrollView.widthAnchor].active = YES;
            }
        }
    }];
}
 */




-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"Container view will appear");
    
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



- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ( event.subtype == UIEventSubtypeMotionShake )
    {
        
        NSLog(@"Shake started");
        
        // Shake top card with the default speed
        [self.topCardStackView shake:15   // 15 times
                              withDelta:20   // 20 points wide
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
        for(Restaurant *restaurant in shuffledRestaurants) {
            
            NSLog(@"Creating NEW card for %@", restaurant.name);
            
            ActivityCardView *newActivityCard =[[ActivityCardView alloc]init];
            newActivityCard.restaurant = restaurant;
            
            newActivityCard.translatesAutoresizingMaskIntoConstraints = NO;
            newActivityCard.translatesAutoresizingMaskIntoConstraints = NO;
            
            [self.middleCardStackView addArrangedSubview:newActivityCard];
            
            [newActivityCard.heightAnchor constraintEqualToAnchor:self.cardHeightAnchor].active = YES;
            [newActivityCard.widthAnchor constraintEqualToAnchor:self.cardWidthAnchor].active = YES;
            
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


@end
