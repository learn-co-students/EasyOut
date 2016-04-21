//
//  LogInViewController.m
//  EggplantButton
//
//  Created by Adrian Brown  on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "LogInViewController.h"
#import "Secrets.h"
#import "EggplantButton-Swift.h"
#import "Firebase.h"
#import "CreateAccountViewController.h"

@interface LogInViewController ()

@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButtonTapped;
@property (weak, nonatomic) IBOutlet UIButton *registerButtonTapped;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyboard)];
    
    [self.view addGestureRecognizer:tapGesture];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (IBAction)login:(id)sender {
    
    [FirebaseAPIClient logInUserWithEmail:self.emailLabel.text password:self.passwordLabel.text completion:^(FAuthData *authData, NSError *error) {
        
        if (error != nil) {
            UIAlertController * alert= [UIAlertController alertControllerWithTitle:@"Failed to login"
                                                                           message:error.description
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
            
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            

            [[NSNotificationCenter defaultCenter] postNotificationName:mainViewControllerStoryBoardID object:nil];
        }
    }];
}

- (IBAction)emailDidEnd:(id)sender {
    
//    if ([self checkEmailValidity]) {
//        
//    }
//    
//    [FirebaseAPIClient checkIfUserExistsWithEmail:self.emailLabel.text completion:^(BOOL doesExist) {
//        
//        if (!doesExist) {
//            UIAlertController *emailTakenAlert= [UIAlertController alertControllerWithTitle:@"Uh oh!"
//                                                                           message:@"This email address has not been registered!"
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
//                                                               style:UIAlertActionStyleDefault
//                                                             handler:^(UIAlertAction * action) {
//                                                                 [emailTakenAlert dismissViewControllerAnimated:YES completion:nil];
//            }];
//            
//            [emailTakenAlert addAction:okAction];
//            
//            [self presentViewController:emailTakenAlert animated:YES completion:nil];
//            
//        }
//    }];
}

- (BOOL)checkEmailValidity {
    
    if (self.emailLabel.text.length < 5) {
        return NO;
    }
    
    if ([self.emailLabel.text containsString:@"!"] || [self.emailLabel.text containsString:@"@@"]) {
        
    }
    
    return YES;
}

@end
