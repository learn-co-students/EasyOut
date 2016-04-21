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
    
    Firebase *ref = [[Firebase alloc] initWithUrl:firebaseRootRef];

            [ref authUser:self.emailLabel.text
                 password:self.passwordLabel.text
      withCompletionBlock:^(NSError *error, FAuthData *authData) {
    
            if (error) {
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"Failed to login"
                                              message:@"Email or password incorrect"
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
                 [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];

            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:mainViewControllerStoryBoardID object:nil];
            }
      }];
    
}
-(void)hideKeyBoard {
    
    [self.emailLabel resignFirstResponder];
    [self.passwordLabel resignFirstResponder];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    
}


@end
