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
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@end

@implementation sideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set appearance of side menu view controller
    self.view.backgroundColor = [Constants vikingBlueColor];
    
    // Set the user info for the side menu
    [self addUserInfoToMenu];
}

- (void)addUserInfoToMenu {
    
//    Firebase *ref = [[Firebase alloc] initWithUrl:firebaseRootRef];
//    Firebase *userRef = [[ref childByAppendingPath:@"users"] childByAppendingPath:[NSString stringWithFormat:@"%@", ref.authData.uid]];
    
    [self pullUserFromFirebaseWithCompletion:^(BOOL success) {
        if(success) {
            
            self.usernameLabel.textColor = [UIColor whiteColor];
            self.usernameLabel.text = self.user.username;
            
            self.userImage.layer.cornerRadius = (self.userImage.frame.size.width)/2;
            self.userImage.clipsToBounds = YES;
            self.userImage.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            
            if(![self.user.profilePhoto isEqualToString:@""]){
                [FirebaseAPIClient getImageForImageID:self.user.profilePhoto completion:^(UIImage * image) {
                    self.userImage.image = image;
                }];
                
            }
        }
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
