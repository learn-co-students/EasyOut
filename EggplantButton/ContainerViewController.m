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

@interface ContainerViewController ()

@property (strong, nonatomic) MenuView *menuView;
@property (strong, nonatomic) RestaurantDataStore *dataStore;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataStore = [[RestaurantDataStore alloc]init];
    
    [self.dataStore getRestaurantsWithCompletion:^(BOOL success) {
        if(success) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{ [self.view reloadInputViews]; }];
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
