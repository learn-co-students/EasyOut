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

@interface LogInViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *invalidEmailWarning;
@property (weak, nonatomic) IBOutlet UILabel *invalidPasswordWarning;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.emailLabel.delegate = self;
    self.passwordLabel.delegate = self;
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyboard)];
    
    [self.view addGestureRecognizer:tapGesture];
    
    self.invalidEmailWarning.hidden = YES;
    self.invalidPasswordWarning.hidden = YES;
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

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.backgroundColor = [UIColor whiteColor];

    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if(textField == self.emailLabel) {
    
        if ([self isEmailValid]) {
            
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
                else {
                    self.invalidEmailWarning.hidden = YES;
                }
            }];
        }
        
        else {
            if(self.emailLabel.text > 0) {
                
                NSLog(@"invalid email");
                
                [self animateTextField:self.emailLabel];
                
                self.invalidEmailWarning.hidden = NO;
            }
        }
    }
    
    if(textField == self.passwordLabel) {
        
        if(self.passwordLabel.text.length > 0 && [self isPasswordValid]) {
            
            if([self isEmailValid]) {
                
                NSLog(@"Valid pass and email");
                self.invalidPasswordWarning.hidden = YES;
                self.invalidEmailWarning.hidden = YES;
                self.loginLabel.enabled = YES;
            }
        }
        else {
            
            [self animateTextField:self.passwordLabel];
            
            self.invalidPasswordWarning.hidden = NO;
        }
    }
    
}

-(BOOL)isPasswordValid {
    
    return (self.passwordLabel.text.length > 7 && ![self.passwordLabel.text containsString:@" "] );
    
}


- (BOOL)isEmailValid {
    
    if (self.emailLabel.text.length < 5 || ![self.emailLabel.text containsString:@"@"]) {
        
        return NO;
    }
    
    else {
        self.invalidEmailWarning.hidden = YES;
        
        return YES;
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"registrationSegue"]) {
        
        CreateAccountViewController *destinationVC = [segue destinationViewController];
        
        if(self.emailLabel.text.length > 0) {
            destinationVC.inputEmail = self.emailLabel.text;
        }
        if(self.passwordLabel.text.length > 0) {
            destinationVC.inputPassword = self.passwordLabel.text;
        }
    
    }

    
}

-(void)animateTextField:(UITextField *)textField {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [UIView setAnimationRepeatCount:4.0];
                
        textField.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        
    }];

}

@end
