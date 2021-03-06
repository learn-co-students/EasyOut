//
//  CreateAccountViewController.h
//  EasyOut
//
//  Created by Adrian Brown  on 4/8/16.
//  Copyright © 2016 EasyOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasyOut-Swift.h"
#import "LogInViewController.h"
#import "Firebase.h"
#import "Secrets.h"
#import "User.h"

@interface CreateAccountViewController : UIViewController

@property (strong, nonatomic) NSString *inputEmail;
@property (strong, nonatomic) NSString *inputPassword;

@end
