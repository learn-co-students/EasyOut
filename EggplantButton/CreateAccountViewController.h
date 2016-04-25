//
//  CreateAccountViewController.h
//  EggplantButton
//
//  Created by Adrian Brown  on 4/8/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EggplantButton-Swift.h"
#import "LogInViewController.h"
#import "Firebase.h"
#import "Secrets.h"
#import "User.h"

@interface CreateAccountViewController : UIViewController

@property (strong, nonatomic) NSString *inputEmail;
@property (strong, nonatomic) NSString *inputPassword;

@end
