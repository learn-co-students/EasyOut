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

@class Restaurant;


@interface ContainerViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) RestaurantDataStore *dataStore;

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
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.dataStore = [RestaurantDataStore sharedDataStore];
    
    [self.dataStore getRestaurantsWithCompletion:^(BOOL success) {
        if(success) {
            
            for(Restaurant *restaurant in self.dataStore.restaurants) {
                
                ActivityCardView *newActivityCard =[[ActivityCardView alloc]init];
                newActivityCard.restaurant = restaurant;
                
                newActivityCard.translatesAutoresizingMaskIntoConstraints = NO;
                newActivityCard.translatesAutoresizingMaskIntoConstraints = NO;
                
                [self.topCardStackView addArrangedSubview: newActivityCard];
                
                [newActivityCard.heightAnchor constraintEqualToAnchor:self.topCardScrollView.heightAnchor].active = YES;
                [newActivityCard.widthAnchor constraintEqualToAnchor:self.topCardScrollView.widthAnchor].active = YES;
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
    
}

-(IBAction)locationFilterButtonTapped:(id)sender {
    
}

-(IBAction)timeFilterButtonTapped:(id)sender {
    
}

-(IBAction)shareButtonTapped:(id)sender {
    // Present share page modally
}

-(IBAction)priceFilterButtonTapped:(id)sender {
    // Present price filter
}

-(IBAction)settingsButtonTapped:(id)sender {
    // Present settings page modally
}

@end
