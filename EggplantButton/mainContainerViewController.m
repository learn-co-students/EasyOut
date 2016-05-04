//
//  mainContainerViewController.m
//  EggplantButton
//
//  Created by Lisa Lee on 4/14/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "mainContainerViewController.h"
#import "CardViewController.h"
#import "sideMenuViewController.h"

@interface mainContainerViewController ()

@property (weak, nonatomic) IBOutlet UIView * sideMenuContainer;
@property (weak, nonatomic) IBOutlet UIView * viewContainer;
@property (strong, nonatomic) UIActivityIndicatorView * spinner;
@property (strong, nonatomic) UIVisualEffectView *blurEffectView;

@end

@implementation mainContainerViewController

- (void) viewWillAppear:(BOOL)animated {
    self.spinner = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.center = CGPointMake((self.view.frame.size.width/2), (self.view.frame.size.height/2));
    self.spinner.hidesWhenStopped = YES;
    [self.spinner startAnimating];
    [self.view addSubview:self.spinner];
}

- (void) viewDidAppear:(BOOL)animated {
    [self.spinner removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuButtonTapped:)
                                                 name:@"menuButtonTapped"
                                               object:nil];
    
    // listening for segue notification from sideMenu
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sideMenuFadeAway:)
                                                 name:@"sideMenuFadeAway"
                                               object:nil];

}

- (void) menuButtonTapped: (NSNotification *) notification {
    
    self.mainViewTapGestureRecognizer.enabled = YES;
    self.viewContainer.subviews[0].userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.sideMenuContainer.alpha = 0.95;
        self.viewContainer.alpha = 0.6;
        [self blurBackgroundView];
    }];
    
    NSLog(@"Menu button tapped");
}

- (IBAction)mainViewTapped:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sideMenuFadeAway"
                                                        object:nil];
    
    NSLog(@"Main View tapped");
}

-(void)blurBackgroundView {
        
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.blurEffectView.frame = self.view.bounds;
    self.blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.viewContainer addSubview:self.blurEffectView];
}

-(void)unblurBackgroundView {
    
    [self.blurEffectView removeFromSuperview];
}

- (void) sideMenuFadeAway: (NSNotification *) notification {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.sideMenuContainer.alpha = 0;
        self.viewContainer.alpha = 1;
        [self unblurBackgroundView];
    }];
    
    self.mainViewTapGestureRecognizer.enabled = NO;
    self.viewContainer.subviews[0].userInteractionEnabled = YES;

    NSLog(@"Side Menu fading away");
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shakeStarted"
                                                        object:nil];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
}


@end
