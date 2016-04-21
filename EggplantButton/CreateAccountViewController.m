//
//  CreateAccountViewController.m
//  EggplantButton
//
//  Created by Adrian Brown  on 4/8/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "CreateAccountViewController.h"

@interface CreateAccountViewController ()


@property (strong, nonatomic)NSString *email;
@property (strong, nonatomic)NSString *username;


@property (weak, nonatomic) IBOutlet UILabel *createAccountLabel;
@property (weak, nonatomic) IBOutlet UITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *passWordLabel;
@property (weak, nonatomic) IBOutlet UITextField *verifyPasswordLabel;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButtonTapped;

@end

@implementation CreateAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyboard)];
    
    [self.view addGestureRecognizer:tapGesture];
    
    self.createAccountButtonTapped.enabled = NO;
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

-(BOOL)emailIsValid{
    if ([self.emailLabel.text containsString:@"@"] && [self.emailLabel.text containsString:@"."]){
        return YES;
    }
    
    self.createAccountButtonTapped.enabled = NO;
    return NO;
}

-(BOOL)passwordValid {
    if (self.passWordLabel.text.length > 7) {

        return YES;
    }
    
    self.createAccountButtonTapped.enabled = NO;
    return NO;
}

-(BOOL)confirmPassword {
    if ([self.verifyPasswordLabel.text isEqualToString:self.passWordLabel.text]) {
        return YES;
    }
    
    self.createAccountButtonTapped.enabled = NO;
    return NO;
}


// Create a new user in Firebase
-(void)createNewUserWithCompletion:(void (^)(BOOL finished)) completion {
    
}

- (IBAction)usernameDidEnd:(id)sender {
    if (self.userNameLabel.text.length >2) {
        
    }
}

- (IBAction)emailDidEnd:(id)sender {
    if (![self emailIsValid]) {
        [UIView animateWithDuration:0.50 animations:^{
            self.emailLabel.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:121.0f/255.0f blue:121.0f/255.0f alpha:1.0];
             }];
        } else {
            self.emailLabel.backgroundColor = [UIColor whiteColor];
        }
}

- (IBAction)passwordDidEnd:(id)sender {
    
    if (![self passwordValid]) {
        [UIView animateWithDuration:0.50 animations:^{
            self.passWordLabel.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:121.0f/255.0f blue:121.0f/255.0f alpha:1.0];
        }];
        
    } else { [UIView animateWithDuration:0.50 animations:^{
        self.passWordLabel.backgroundColor = [UIColor whiteColor];
    }];
        
    }
}

- (IBAction)confirmPasswordDidEnd:(id)sender {
    if (![self confirmPassword]) {
        [UIView animateWithDuration:0.50 animations:^{
            self.verifyPasswordLabel.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:121.0f/255.0f blue:121.0f/255.0f alpha:1.0];
        }];
    } else {
        [UIView animateWithDuration:0.50 animations:^{
            self.verifyPasswordLabel.backgroundColor = [UIColor whiteColor];
            self.createAccountButtonTapped.enabled = YES;
        }];
        
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


             
@end
