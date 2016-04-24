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
    
    [self addTapGesture];
    

    
}

-(void)addTapGesture {
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyboard)];
    
    [self.view addGestureRecognizer:tapGesture];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

-(NSString *)generateErrorMessage:(NSError *)error {
    
    switch (error.code) {
        case FAuthenticationErrorInvalidEmail:
            return @"The specified email is not a valid email.";
        case FAuthenticationErrorInvalidPassword:
            return  @"The specified user account password is incorrect.";
        case FAuthenticationErrorUserDoesNotExist:
            return @"The specified user account does not exist. Please sign up to continue.";
        case FAuthenticationErrorEmailTaken:
            return  @"The new user account cannot be created because the specified email address is already in use.";
        default:
            return error.description;
    }
}

-(void)generateLoginAlertForError:(NSError *)error {
    
    NSString *errorMessage = @"Failed to login: ";
 
    UIAlertController * alert= [UIAlertController alertControllerWithTitle:@"Uh oh!"
                                                                   message: [NSString stringWithFormat:@"%@%@",errorMessage, [self  generateErrorMessage: error]]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];

    
}

- (IBAction)login:(id)sender {
    
    [FirebaseAPIClient logInUserWithEmail:self.emailLabel.text password:self.passwordLabel.text completion:^(FAuthData *authData, NSError *error) {
        
        if (error != nil) {
            
            [self generateErrorMessage:error];
            
        }
        else {

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
    
        if (![self isEmailValid:self.emailLabel.text] && self.emailLabel.text.length > 0) {
                
            [self animateTextField:self.emailLabel warning:self.invalidEmailWarning];
            self.invalidEmailWarning.hidden = NO;
        }

        
    }
    
    if(textField == self.passwordLabel) {
        
        if(self.passwordLabel.text.length > 0) {
            
            if([self isEmailValid:self.emailLabel.text] && [self isPasswordValid:self.passwordLabel.text]) {
                
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

-(BOOL)isPasswordValid:(NSString *)password {
    
    return (password.length > 7 && ![password containsString:@" "] );
    
}


- (BOOL)isEmailValid:(NSString *)email {
    
    return (email.length > 5 && [email containsString:@"@"] && ![email containsString:@" "]);
    
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
