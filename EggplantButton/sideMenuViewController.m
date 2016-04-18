//
//  sideMenuViewController.m
//  EggplantButton
//
//  Created by Lisa Lee on 4/15/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "sideMenuViewController.h"

@interface sideMenuViewController ()



@end

@implementation sideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)profileButtonTapped:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"profileButtonTapped"
                                                        object:nil];
    NSLog(@"profile button tapped!");

    
}

- (IBAction)itineraryHistoryButtonTapped:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pastItinerariesButtonTapped"
                                                        object:nil];
    NSLog(@"past itineraries button tapped!");
    
}

- (IBAction)logoutButtonTapped:(id)sender {
    

    [[NSNotificationCenter defaultCenter] postNotificationName:@"logoutButtonTapped"
                                                        object:nil];
    NSLog(@"logout button tapped!");
   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
