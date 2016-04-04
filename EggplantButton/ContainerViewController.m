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

@property (strong, nonatomic) NSMutableArray *topActivityCards;
@property (strong, nonatomic) NSMutableArray *middleActivityCards;
@property (strong, nonatomic) NSMutableArray *bottomActivityCards;

@property (weak, nonatomic) IBOutlet UIStackView *menuStackView;
@property (weak, nonatomic) IBOutlet UIButton *locationFilterButton;
@property (weak, nonatomic) IBOutlet UIButton *timeFilterButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *priceFilterButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"Container view did load");
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    
    
}

-(IBAction)locationFilterButtonTapped:(id)sender {
    
}

-(IBAction)timeFilterButtonTapped:(id)sender {
    
}

-(IBAction)shareButtonTapped:(id)sender {
    // Present share page modally
}

-(IBAction)priceFilterButtonTapped:(id)sender {
    // Present price filter
}

-(IBAction)settingsButtonTapped:(id)sender {
    // Present settings page modally
}


@end
