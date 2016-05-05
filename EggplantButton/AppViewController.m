//
//  AppViewController.m
//  EasyOut
//
//  Created by Adrian Brown  on 4/7/16.
//  Copyright © 2016 EasyOut. All rights reserved.
//

#import "AppViewController.h"
#import "Secrets.h"
#import "Firebase.h"
#import "User.h"
#import "EasyOut-Swift.h"

@interface AppViewController ()

// Container view outlet property
@property (weak, nonatomic) IBOutlet UIView *containerView;

// Current VC property for swapping VCs in the container view
@property (strong, nonatomic) UIViewController *currentViewController;

// Current User
@property (strong, nonatomic) User *user;

@end

@implementation AppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    Firebase *ref = [[Firebase alloc] initWithUrl:firebaseRootRef];
    
    // Uncomment the following line to log out of current user account upon app start
//    [ref unauth];
    
    self.user = [[User alloc] init];
    
    if (ref.authData) {
        UIViewController *mainVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:mainViewControllerStoryBoardID];
        
        [FirebaseAPIClient getUserFromFirebaseWithUserID:ref.authData.uid completion:^(User * user, BOOL success) {
            self.user = user;
        }];
        
        [self setEmbeddedViewController:mainVC];
    }
    else {
        UIViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:LoginViewControllerStoryBoardID];
        [self setEmbeddedViewController:loginVC];
    }
    
    [self addNotificationObservers];
}

-(void)addNotificationObservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backToMain)
                                                 name:mainViewControllerStoryBoardID
                                               object:nil];
}

-(void)backToMain {
    UIViewController *mainVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:mainViewControllerStoryBoardID];
    
    [self setEmbeddedViewController:mainVC];
}



-(void)setEmbeddedViewController:(UIViewController *)controller
{
    if ([self.childViewControllers containsObject:controller]) {
        return;
    }
    
    for(UIViewController *vc in self.childViewControllers) {
        [vc willMoveToParentViewController:nil];
        
        if(vc.isViewLoaded) {
            [vc.view removeFromSuperview];
        }
        
        [vc removeFromParentViewController];
    }
    
    if (!controller) {
        return;
    }
    
    [self addChildViewController:controller];
    [self.containerView addSubview:controller.view];
    
    controller.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [controller.view.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor].active = YES;
    [controller.view.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor].active = YES;
    [controller.view.topAnchor constraintEqualToAnchor:self.containerView.topAnchor].active = YES;
    [controller.view.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor].active = YES;

    [controller didMoveToParentViewController:self];
}


@end
