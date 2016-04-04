//
//  ContainerViewController.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 3/31/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "ContainerViewController.h"
#import "RestaurantDataStore.h"
#import "MainContentView.h"
#import "ActivityCardView.h"

@class Restaurant;


@interface ContainerViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) RestaurantDataStore *dataStore;

@property (strong, nonatomic) UIStackView *topCardStackView;
@property (strong, nonatomic) UIStackView *middleCardStackView;
@property (strong, nonatomic) UIStackView *bottomCardStackView;

@property (strong, nonatomic) NSMutableArray *topActivityCards;
@property (strong, nonatomic) NSMutableArray *middleActivityCards;
@property (strong, nonatomic) NSMutableArray *bottomActivityCards;

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
                
                
            }
            
        }
        else {
            NSLog(@"fail");
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

    NSLog(@"Container view did load");
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
