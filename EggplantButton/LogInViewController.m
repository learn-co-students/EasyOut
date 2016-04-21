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
                                           action:@selector(hideKeyBoard)];
    
    [self.view addGestureRecognizer:tapGesture];
}

- (IBAction)login:(id)sender {
    
    [FirebaseAPIClient logInUserWithEmail:self.emailLabel.text password:self.passwordLabel.text completion:^(BOOL success) {
        if (!success) {
            
            UIAlertController * alert= [UIAlertController alertControllerWithTitle:@"Failed to login"
                                                                           message:@"Email or password incorrect"
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
    
    [FirebaseAPIClient checkIfUserExistsWithEmail:self.emailLabel.text completion:^(BOOL doesExist) {
        if (!doesExist) {
            UIAlertController *emailTakenAlert= [UIAlertController alertControllerWithTitle:@"Uh oh!"
                                                                           message:@"This email address has not been registered!"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 [emailTakenAlert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [emailTakenAlert addAction:okAction];
            
            [self presentViewController:emailTakenAlert animated:YES completion:nil];
            
        }
    }];
    
}


@end
