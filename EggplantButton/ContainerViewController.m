//
//  ContainerViewController.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 3/31/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "ContainerViewController.h"
#import "MenuView.h"
#import "MainContentView.h"
#import "ActivityCardView.h"

@interface ContainerViewController ()

@property (strong, nonatomic) UIScrollView *verticalScrollView;
@property (strong, nonatomic) MainContentView *mainContentView;
@property (strong, nonatomic) UIStackView *cardStackView;
@property (strong, nonatomic) MenuView *menuView;
@property (strong, nonatomic) UIScrollView *topCardScrollView;
@property (strong, nonatomic) UIScrollView *middleCardScrollView;
@property (strong, nonatomic) UIScrollView *bottomCardScrollView;
@property (strong, nonatomic) UIStackView *topCardStackView;
@property (strong, nonatomic) UIStackView *middleCardStackView;
@property (strong, nonatomic) UIStackView *bottomCardStackView;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Add all the views to the view controller
    [self.view addSubview:self.verticalScrollView];
    [self.verticalScrollView addSubview:self.mainContentView];
    [self.mainContentView addSubview:self.cardStackView];
    [self.mainContentView addSubview:self.menuView];
    [self.mainContentView addSubview:self.topCardScrollView];
    [self.mainContentView addSubview:self.middleCardScrollView];
    [self.mainContentView addSubview:self.bottomCardScrollView];
    [self.topCardScrollView addSubview:self.topCardStackView];
    [self.middleCardScrollView addSubview:self.middleCardStackView];
    [self.bottomCardScrollView addSubview:self.bottomCardStackView];

    
}

-(void)viewWillAppear:(BOOL)animated {
    
    
    
}



@end
