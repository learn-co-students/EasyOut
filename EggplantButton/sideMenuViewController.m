//
//  sideMenuViewController.m
//  EggplantButton
//
//  Created by Lisa Lee on 4/15/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "sideMenuViewController.h"
#import "Secrets.h"
#import "Firebase.h"
#import "EggplantButton-Swift.h"
#import "Constants.h"


@interface sideMenuViewController ()

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;


@end

@implementation sideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pullUserFromFirebaseWithCompletion:^(BOOL success) {
        if(success) {
            
            self.usernameLabel.textColor = [Constants vikingBlueColor];
            self.usernameLabel.text = self.user.username;
            
//            self.userImage.layer.cornerRadius = (self.userImage.frame.size.width)/2;
//            self.userImage.clipsToBounds = YES;
//            self.userImage.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            
        }
    

    // Set appearance of side menu view controller
    self.view.backgroundColor = [Constants vikingBlueColor];
    

        }];
    
}


- (void)pullUserFromFirebaseWithCompletion:(void(^)(BOOL success))completion {
    
    Firebase *ref = [[Firebase alloc] initWithUrl:firebaseRootRef];
    
    [FirebaseAPIClient getUserFromFirebaseWithUserID:ref.authData.uid completion:^(User * user, BOOL success) {
        
        self.user = user;
        
        completion(YES);
    }];

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

@end
