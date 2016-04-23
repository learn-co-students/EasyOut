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
        
        NSMutableString *errorMessage = [@"Failed to login: " mutableCopy];
        
        if (error != nil) {
            switch (error.code) {
                case FAuthenticationErrorInvalidEmail:
                    [errorMessage appendString: @"The specified email is not a valid email."];
                    break;
                    
                case FAuthenticationErrorInvalidPassword:
                    [errorMessage appendString: @"The specified user account password is incorrect."];
                    break;
                    
                case FAuthenticationErrorUserDoesNotExist:
                    [errorMessage appendString: @"The specified user account does not exist. Please sign up to continue."];
                    
                    break;
                case FAuthenticationErrorEmailTaken:
                    [errorMessage appendString: @"The new user account cannot be created because the specified email address is already in use."];
                    
                default:
                    [errorMessage appendString:error.description];
                    break;
            }

            
            UIAlertController * alert= [UIAlertController alertControllerWithTitle:@"Uh oh!"
                                                                           message:errorMessage
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
    if(textField == self.emailLabel ) {
        if(!self.invalidEmailWarning.hidden) {
            self.invalidEmailWarning.hidden = YES;
        }
    }
    if(textField == self.passwordLabel) {
        if(!self.invalidPasswordWarning.hidden) {
            self.invalidEmailWarning.hidden = YES;
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if(textField == self.emailLabel) {
    
        if (![self isEmailValid] && self.emailLabel.text > 0) {
                
            [self animateTextField:self.emailLabel warning:self.invalidEmailWarning];
        }

        
    }
    
    if(textField == self.passwordLabel) {
        
        if(self.passwordLabel.text.length > 0) {
            
            if([self isEmailValid] && [self isPasswordValid]) {
                
                self.invalidPasswordWarning.hidden = YES;
                self.invalidEmailWarning.hidden = YES;
                self.loginLabel.enabled = YES;
            }
            
            else {
                
                [self animateTextField:self.passwordLabel warning:self.invalidPasswordWarning];
             }
        }
        
    }
    
}

-(BOOL)isPasswordValid {
    
    return (self.passwordLabel.text.length > 7 && ![self.passwordLabel.text containsString:@" "] );
    
}


- (BOOL)isEmailValid {
    
    return (self.emailLabel.text.length > 5 && [self.emailLabel.text containsString:@"@"] && ![self.passwordLabel.text containsString:@" "]);
    
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

-(void)animateTextField:(UITextField *)textField warning:(UILabel *)warning {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [UIView setAnimationRepeatCount:4.0];
                
        textField.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        warning.hidden = NO;
        
    }];

}

@end
