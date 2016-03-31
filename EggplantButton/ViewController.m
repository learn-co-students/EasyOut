//
//  ViewController.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 3/29/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "ViewController.h"
#import "RestaurantDataStore.h"


@interface ViewController ()

@property (strong, nonatomic) RestaurantDataStore *dataStore;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataStore = [RestaurantDataStore sharedDataStore];
    
    [self.dataStore getRestaurantsWithCompletion:^(BOOL success) {
 
        if (success) {
            
            NSLog(@"SUCCESS");
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                
//                
//                 }];
        }
        else {
            NSLog(@"Fail");
        }
    }];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
