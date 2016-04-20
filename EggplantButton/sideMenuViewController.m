//
//  sideMenuViewController.m
//  EggplantButton
//
//  Created by Lisa Lee on 4/15/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "sideMenuViewController.h"


@interface sideMenuViewController ()

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;


@end

@implementation sideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameLabel.text = self.user.username;
    
}

- (IBAction)profileButtonTapped:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"profileButtonTapped"
                                                        object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sideMenuFadeAway"
                                                        object:nil];

    
}

- (IBAction)itineraryHistoryButtonTapped:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pastItinerariesButtonTapped"
                                                        object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sideMenuFadeAway"
                                                        object:nil];
    
}

- (IBAction)logoutButtonTapped:(id)sender {
    

    [[NSNotificationCenter defaultCenter] postNotificationName:@"logoutButtonTapped"
                                                        object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sideMenuFadeAway"
                                                        object:nil];
   
   
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
   
          
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
