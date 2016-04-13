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
    // Do any additional setup after loading the view.

}

-(void)testIfAlive {
    NSLog(@"Are you still breathing?");
}

- (IBAction)login:(id)sender {
    
    // Use Firebase to login
    // method should be some type of completion
    // if success, post success notification
    // else post error notification
    
    Firebase *ref = [[Firebase alloc] initWithUrl:firebaseRootRef];

        [ref authUser:self.emailLabel.text password:self.passwordLabel.text
    withCompletionBlock:^(NSError *error, FAuthData *authData) {
    
    if (error) {
        // an error occurred while attempting login
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
        NSLog(@"You are not a user%@", error);
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:mainViewControllerStoryBoardID object:nil];
    }
}];
    
    
    // Send post notification to app view controller to load generic VC
     [[NSNotificationCenter defaultCenter] postNotificationName:mainViewControllerStoryBoardID object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
