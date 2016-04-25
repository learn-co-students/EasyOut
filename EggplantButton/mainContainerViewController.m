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

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer * mainViewTapGestureRecognizer;

@end

@implementation mainContainerViewController

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
        
    }];
}

- (IBAction)mainViewTapped:(id)sender {
    
    self.mainViewTapGestureRecognizer.enabled = NO;
    self.viewContainer.subviews[0].userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.sideMenuContainer.alpha = 0;
        self.viewContainer.alpha = 1;
    }];
}

- (void) sideMenuFadeAway: (NSNotification *) notification {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.sideMenuContainer.alpha = 0;

        self.viewContainer.alpha = 1;
    }];
    
    self.mainViewTapGestureRecognizer.enabled = NO;
    self.viewContainer.subviews[0].userInteractionEnabled = YES;
    
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event

{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shakeStarted"
                                                        object:nil];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
}


@end
