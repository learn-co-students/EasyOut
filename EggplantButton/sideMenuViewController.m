//
//  sideMenuViewController.m
//  EggplantButton
//
//  Created by Lisa Lee on 4/14/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "sideMenuViewController.h"

@interface sideMenuViewController ()

@property (weak, nonatomic) IBOutlet UIView *sideMenuContainer;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *mainViewTapGestureRecognizer;

@end

@implementation sideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuButtonTapped:) name:@"menuButtonTapped" object:nil];
}

- (void) menuButtonTapped: (NSNotification *) notification {
    
    self.mainViewTapGestureRecognizer.enabled = YES;
    self.viewContainer.subviews[0].userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.sideMenuContainer.alpha = 1;
        self.viewContainer.alpha = 0.75;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
