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
    
    self.dataStore = [RestaurantDataStore sharedDataStore];
    
    [self.dataStore getRestaurantsWithCompletion:^(BOOL success) {
        if(success) {
            
            for(Restaurant *restaurant in self.dataStore.restaurants) {
                
                ActivityCardView *newActivity =[[ActivityCardView alloc]init];
                newActivity.restaurant = restaurant;
                
                [self.topCardStackView addArrangedSubview: newActivity];
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
    
    NSLog(@"Contianer view will appear");
    
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

@end
