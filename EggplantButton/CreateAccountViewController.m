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
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
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
                                           action:@selector(hideKeyBoard)];
    
    [self.view addGestureRecognizer:tapGesture];
    self.createAccountButtonTapped.enabled = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hideKeyBoard {
    
    [self.emailLabel resignFirstResponder];
    [self.passWordLabel resignFirstResponder];
    [self.verifyPasswordLabel resignFirstResponder];
    [self.nameLabel resignFirstResponder];
    [self.userNameLabel resignFirstResponder]; 
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
-(void)createNewUserWithCompletion:(void (^)(BOOL finished))completion{
    
    self.email = self.emailLabel.text;
    self.username = self.userNameLabel.text;
    
    User *newUser = [[User alloc]initWithEmail:self.email username:self.username];
    
    FirebaseAPIClient *firebaseAPI = [[FirebaseAPIClient alloc] init];
    
    [firebaseAPI registerNewUserWithUser:newUser password:self.passWordLabel.text completion:^(BOOL success) {
        if (success) {
            NSLog(@"User with email %@ was successfully registered", self.email);
        }
    }];
    
    if (completion) {
        Firebase *ref = [[Firebase alloc] initWithUrl:firebaseRootRef];
        
        [ref observeAuthEventWithBlock:^(FAuthData *authData) {
            if (authData) {
                // user authenticated
                NSLog(@"%@", authData);
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:mainViewControllerStoryBoardID object:nil];
            }
        }];
    }    
}

- (IBAction)emailDidEnd:(id)sender {
    if (![self emailIsValid]) {
        [UIView animateWithDuration:0.50 animations:^{
            self.emailLabel.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:121.0f/255.0f blue:121.0f/255.0f alpha:1.0];
             }];
        }
         else {
            [UIView animateWithDuration:0.50 animations:^{
                self.emailLabel.backgroundColor = [UIColor clearColor];
            }];

        }
}

- (IBAction)passwordDidEnd:(id)sender {
    
    if (![self passwordValid]) {
        [UIView animateWithDuration:0.50 animations:^{
            self.passWordLabel.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:121.0f/255.0f blue:121.0f/255.0f alpha:1.0];
        }];
        
    }else { [UIView animateWithDuration:0.50 animations:^{
        self.passWordLabel.backgroundColor = [UIColor clearColor];
    }];
        
    }
}

- (IBAction)confirmPasswordDidEnd:(id)sender {
    if (![self confirmPassword]) {
        [UIView animateWithDuration:0.50 animations:^{
            self.verifyPasswordLabel.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:121.0f/255.0f blue:121.0f/255.0f alpha:1.0];

        }];
    }else { [UIView animateWithDuration:0.50 animations:^{
        self.verifyPasswordLabel.backgroundColor = [UIColor clearColor];
        
        self.createAccountButtonTapped.enabled = YES;
    }];
        
    }
}




- (IBAction)createAccountButton:(id)sender
{
    
    [self createNewUserWithCompletion:^(BOOL finished) {
       //
    }];
}


             
@end
