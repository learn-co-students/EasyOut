//
//  ContainerViewController.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 3/31/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "ContainerViewController.h"
#import "MenuView.h"
#import "RestaurantDataStore.h"

@class Restaurant;

@interface ContainerViewController ()

@property (strong, nonatomic) RestaurantDataStore *dataStore;




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


@end
