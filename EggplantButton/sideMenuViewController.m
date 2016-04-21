//
//  sideMenuViewController.m
//  EggplantButton
//
//  Created by Lisa Lee on 4/15/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "sideMenuViewController.h"
#import "Constants.h"


@interface sideMenuViewController ()

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;


@end

@implementation sideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameLabel.text = self.user.username;
    
    // Set appearance of side menu view controller
    self.view.backgroundColor = [Constants vikingBlueColor];
    
}

- (IBAction)profileButtonTapped:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"profileButtonTapped"
                                                        object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sideMenuFadeAway"
                                                        object:nil];
    NSLog(@"profile button tapped!");

    
}

- (IBAction)itineraryHistoryButtonTapped:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pastItinerariesButtonTapped"
                                                        object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sideMenuFadeAway"
                                                        object:nil];
    NSLog(@"past itineraries button tapped!");
    
}

- (IBAction)logoutButtonTapped:(id)sender {
    

    [[NSNotificationCenter defaultCenter] postNotificationName:@"logoutButtonTapped"
                                                        object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sideMenuFadeAway"
                                                        object:nil];
    NSLog(@"logout button tapped!");
   
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"Shake started sideMenu");
          
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
