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


@class Restaurant;


@interface ContainerViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) RestaurantDataStore *dataStore;

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


@end

@implementation ContainerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Set default card height and width anchors
    self.cardHeightAnchor = self.topCardScrollView.heightAnchor;
    self.cardWidthAnchor = self.topCardScrollView.widthAnchor;
    
    // Call in the shared data store
    self.dataStore = [RestaurantDataStore sharedDataStore];
    
    // Create cards for each activity in the shared data store
    [self.dataStore getRestaurantsWithCompletion:^(BOOL success) {
        if(success) {
            
            for(Restaurant *restaurant in self.dataStore.restaurants) {
                
                NSLog(@"Creating card for %@", restaurant.name);
                
                ActivityCardView *newActivityCard =[[ActivityCardView alloc]init];
                newActivityCard.restaurant = restaurant;
                
                newActivityCard.translatesAutoresizingMaskIntoConstraints = NO;
                newActivityCard.translatesAutoresizingMaskIntoConstraints = NO;
                
                [self.middleCardStackView addArrangedSubview: newActivityCard];
                
                [newActivityCard.heightAnchor constraintEqualToAnchor:self.cardHeightAnchor].active = YES;
                [newActivityCard.widthAnchor constraintEqualToAnchor:self.cardWidthAnchor].active = YES;
            }
        }
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
        
        // Shake with the default speed
        [self.middleCardStackView shake:20   // 20 times
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
            
            [self.middleCardStackView insertArrangedSubview:newActivityCard atIndex:0];
            
            [newActivityCard.heightAnchor constraintEqualToAnchor:self.cardHeightAnchor].active = YES;
            [newActivityCard.widthAnchor constraintEqualToAnchor:self.cardWidthAnchor].active = YES;
            
       //     [newActivityCard removeFromSuperview];
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
