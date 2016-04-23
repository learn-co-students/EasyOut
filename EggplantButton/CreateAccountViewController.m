//
//  CreateAccountViewController.m
//  EggplantButton
//
//  Created by Adrian Brown  on 4/8/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "CreateAccountViewController.h"

@interface CreateAccountViewController () <UITextFieldDelegate>


@property (strong, nonatomic)NSString *email;
@property (strong, nonatomic)NSString *username;
@property (weak, nonatomic) IBOutlet UITextField *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *passWordLabel;
@property (weak, nonatomic) IBOutlet UITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *verifyPasswordLabel;

@property (weak, nonatomic) IBOutlet UIButton *createAccountButtonTapped;

@property (weak, nonatomic) IBOutlet UILabel *usernameWarning;
@property (weak, nonatomic) IBOutlet UILabel *emailWarning;
@property (weak, nonatomic) IBOutlet UILabel *passwordWarning;
@property (weak, nonatomic) IBOutlet UILabel *verifyPassWarning;


@end

@implementation CreateAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyboard)];
    
    [self.view addGestureRecognizer:tapGesture];
    
    self.createAccountButtonTapped.enabled = NO;
    
    //Hide all the warnings
    self.usernameWarning.hidden = YES;
    self.emailWarning.hidden = YES;
    self.passwordWarning.hidden = YES;
    self.verifyPassWarning.hidden = YES;
    
    self.verifyPasswordLabel.enabled = NO;

    
    //Populate any fields that were populated at login
    if(self.inputEmail) {
        self.emailLabel.text = self.inputEmail;
    }
    if(self.inputPassword) {
        self.passWordLabel.text = self.inputPassword;
        self.verifyPasswordLabel.enabled = YES;
    }
    
    //Set the delegates
    self.userNameLabel.delegate = self;
    self.emailLabel.delegate = self;
    self.passWordLabel.delegate = self;
    self.verifyPasswordLabel.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hideKeyboard {
    [self.view endEditing:YES];
}

-(void)checkUsernameValidityWithCompletion:(void (^)(BOOL isValid)) completion {
    
    // Check with Firebase if entered username is in use
    [FirebaseAPIClient checkIfUserExistsWithUsername:self.userNameLabel.text completion:^(BOOL doesExist) {
        if (doesExist) {
            completion(NO);
        } else {
            completion(YES);
        }
    }];
}


-(BOOL)isValid:(NSString *)string {
    
    return (string.length > 7 && ![string containsString:@" "]);
}


- (BOOL)isEmailValid {
    
    if (self.emailLabel.text.length < 5 || ![self.emailLabel.text containsString:@"@"]) {
        
        return NO;
    }
    
    else {
        self.emailWarning.hidden = YES;
        
        return YES;
    }
    
}

-(BOOL)isPasswordSame {
    return ([self.verifyPasswordLabel.text isEqualToString:self.passWordLabel.text]);
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField {
    //check what text field it is and do proper validating
    
    if(textField == self.userNameLabel) {
        if(self.userNameLabel.text.length > 0) {
            
            [self checkUsernameValidityWithCompletion:^(BOOL isValid) {
                if(!(isValid)) {
                 
                    [self animateTextField:textField];
                    self.usernameWarning.text = @"* Username already taken";
                    self.usernameWarning.hidden = NO;
                    
                }

            }];
            
        }
        
        if(self.userNameLabel.text.length > 0 && ![self isValid:self.userNameLabel.text]) {
            [self animateTextField: self.userNameLabel];
            self.usernameWarning.hidden = NO;
        }
        
    }
    else if(textField == self.emailLabel) {
        
        if(self.emailLabel.text.length > 0 && ![self isEmailValid]) {
            
            [self animateTextField: self.emailLabel];
            self.emailWarning.hidden = NO;
        }
        
    }
    else if(textField == self.passWordLabel) {
        
        if(self.passWordLabel.text.length > 0 && ![self isValid:self.passWordLabel.text]) {
           
            [self animateTextField: self.passWordLabel];
            self.passwordWarning.hidden = NO;
        }
        else {
            self.verifyPasswordLabel.enabled = YES;
        }
         
    }
    else if (textField == self.verifyPasswordLabel) {
        if(self.verifyPasswordLabel.text.length > 0 && ![self isPasswordSame]) {
            
            [self animateTextField: self.verifyPasswordLabel];
            self.verifyPassWarning.hidden = NO;
        }
    }
    
    if([self allFieldsValid]) {
        self.createAccountButtonTapped.enabled = YES;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{

    textField.backgroundColor = [UIColor whiteColor];
    
    if(textField == self.userNameLabel){
        self.usernameWarning.hidden = YES;
        self.usernameWarning.text = @"* Must be at least 7 characters long & cannot contain spaces";
    }
    if(textField == self.emailLabel){
        self.emailWarning.hidden = YES;
        
    }
    if(textField == self.passWordLabel){
        self.passWordLabel.text = @"";
        self.passwordWarning.hidden = YES;

    }
    if(textField == self.verifyPasswordLabel){
        
        self.verifyPasswordLabel.text = @"";
        self.verifyPassWarning.hidden = YES;

    }
    
}

- (IBAction)createAccountButton:(id)sender {
    
    User *newUser = [[User alloc]initWithEmail:self.emailLabel.text username:self.userNameLabel.text];
    
    [FirebaseAPIClient registerNewUserWithUser:newUser password:self.passWordLabel.text completion:^(BOOL success) {
        
        
        
        if (success) {
            
            NSLog(@"User with email %@ was successfully registered", self.emailLabel.text);
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:mainViewControllerStoryBoardID object:nil];
            
        } else {
            
            NSLog(@"Something went wrong registering the user");
        }
    }];
}

-(void)animateTextField:(UITextField *)textField {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [UIView setAnimationRepeatCount:4.0];
        
        textField.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        
    }];
    
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(BOOL)allFieldsValid {
    
    return([self isEmailValid] && [self isValid:self.passWordLabel.text] && [self isValid:self.userNameLabel.text] && [self isPasswordSame]);
}

@end
