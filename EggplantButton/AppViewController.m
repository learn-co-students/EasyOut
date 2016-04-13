//
//  AppViewController.m
//  EggplantButton
//
//  Created by Adrian Brown  on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "AppViewController.h"
#import "Secrets.h"
#import "Firebase.h"

@interface AppViewController ()

// Container view outlet property
@property (weak, nonatomic) IBOutlet UIView *containerView;

// Current VC property for swapping VCs in the container view
@property (strong, nonatomic) UIViewController *currentViewController;

@end

@implementation AppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Firebase *ref = [[Firebase alloc] initWithUrl:firebaseRootRef];
    
    [ref observeAuthEventWithBlock:^(FAuthData *authData) {
        if (authData) {
            // user authenticated
            self.currentViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:mainViewControllerStoryBoardID];
            [self.containerView addSubview:self.currentViewController.view];
            self.currentViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
            [self constrainSubView:self.currentViewController.view toParentView:self.containerView];

            NSLog(@"User is logged in %@!!!!!!", authData);
        } else {
            // No user is signed in
            // Set up and present initial view controller
            self.currentViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:LoginViewControllerStoryBoardID];
            [self.containerView addSubview:self.currentViewController.view];
            self.currentViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
            [self constrainSubView:self.currentViewController.view toParentView:self.containerView];

            
        }
    }];
    
    
    
    // Add notification oberservers to signal that VCs should be swapped
    [self addNotificationObservers];
    
}

-(void)addNotificationObservers {
    
    // Generic notification observer (for example only)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleGenericViewControllerSelected)
                                                 name:mainViewControllerStoryBoardID
                                               object:nil];
    
    
}
     
-(void)constrainSubView:(UIView *)subView toParentView:(UIView *)parentView {
    
    // constrain VC view to container view
    [subView.topAnchor constraintEqualToAnchor:parentView.topAnchor].active = YES;
    [subView.bottomAnchor constraintEqualToAnchor:parentView.bottomAnchor].active = YES;
    [subView.leadingAnchor constraintEqualToAnchor:parentView.leadingAnchor].active = YES;
    [subView.trailingAnchor constraintEqualToAnchor:parentView.trailingAnchor].active = YES;
    
}

-(void)handleGenericViewControllerSelected {
    
    NSLog(@"generic notification received");
    
    // 1. Instantiate new view controller
    UIViewController *newVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:mainViewControllerStoryBoardID];
    
    /// BREAK OUT INTO SEPARATE METHOD ///
    
    // 2. Set auto resizing mask into constraints to no
    newVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 3. Call willMove... with nil before removeFromParent... per docs
    [self.currentViewController willMoveToParentViewController:nil];
    
    // 4. Add new VC as child VC
    [self addChildViewController:newVC];
    
    // 5. Add new VC view to container view
    [self.containerView addSubview:newVC.view];
    
    // 6. Set constraints of new VC for starting position
    [newVC.view.topAnchor constraintEqualToAnchor:self.containerView.topAnchor].active = YES;
    [newVC.view.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor].active = YES;
    [newVC.view.leadingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor].active = YES;
    [newVC.view.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor].active = YES;

    // 7. Call layoutIfNeeded on container view
    [self.containerView layoutIfNeeded];
    NSLog(@"I switched over to the right place !");

    
    // 8. Add final constaints for new VC
    [self constrainSubView:newVC.view toParentView:self.containerView];
    
    // 9. Set alpha of new VC to zero (if you want)
//    newVC.view.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        
//        newVC.view.alpha = 1;
        [newVC.view layoutIfNeeded];
        
        
    } completion:^(BOOL finished) {
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
        [newVC didMoveToParentViewController:self];
        self.currentViewController = nil;
        self.currentViewController = newVC;
        
        NSLog(@"I switched over to the right place !");

    }];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
