//
//  setupButton.m
//  EggplantButton
//
//  Created by Lisa Lee on 4/4/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "setupButton.h"
#import "Secrets.h"
#import "Constants.h"
#import <Button/Button.h>

@interface setupButton ()

@property (nonatomic, strong) BTNDropinButton * uberbutton;
@property (nonatomic, strong) BTNDropinButton * rezybutton;

@end

@implementation setupButton

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUberButton];
    
    [self setupRezyButton];
      

}

- (void) setupRezyButton {
    
    // Initializing button
    self.rezybutton = [[BTNDropinButton alloc] initWithButtonId:REZY_BUTTON_ID];
    [self.view addSubview:self.rezybutton];
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.rezybutton.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
    [self.rezybutton.widthAnchor constraintEqualToConstant:190].active = YES;
    [self.rezybutton.heightAnchor constraintEqualToConstant:40].active = YES;
    [self.rezybutton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    
    [self.rezybutton.topAnchor constraintEqualToAnchor: self.uberbutton.bottomAnchor constant:20].active = YES;
    
    [[BTNDropinButton appearance] setContentInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 10.0)];
    [[BTNDropinButton appearance] setIconSize:26.0];
    [[BTNDropinButton appearance] setIconLabelSpacing:13.0];
    [[BTNDropinButton appearance] setFont:[UIFont systemFontOfSize:12.0]];
    [[BTNDropinButton appearance] setBorderWidth:1];
    [[BTNDropinButton appearance] setCornerRadius: 5.0];
    [[BTNDropinButton appearance] setHighlightedBackgroundColor: [UIColor grayColor]];
    [[BTNDropinButton appearance] setHighlightedTextColor:[UIColor whiteColor]];
    
//    // Setup your context.
//    BTNLocation *userLocation = [BTNLocation locationWithLatitude:<#latitude#> longitude:<#longitude#>];
//    BTNContext *context = [BTNContext contextWithUserLocation:userLocation];
    
    BTNLocation *location = [BTNLocation locationWithName:@"Parm"
                                                 latitude:40.7237889
                                                longitude:-73.997];
    BTNContext *context = [BTNContext contextWithSubjectLocation:location];
    
    [self.rezybutton prepareWithContext:context completion:^(BOOL isDisplayable) {
        if (!isDisplayable) {
            // If a button has no action, it completes as not displayable.
        }
    }];
    
}

- (void) setupUberButton {

    // Initializing button
    self.uberbutton = [[BTNDropinButton alloc] initWithButtonId:UBER_BUTTON_ID];
    [self.view addSubview:self.uberbutton];

    //[[BTNDropinButton appearanceWhenContainedInInstancesOfClasses:@[[self.uberbutton class]]] setBackgroundColor:[UIColor blueColor]];

    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.uberbutton.translatesAutoresizingMaskIntoConstraints = NO;

    [self.uberbutton.topAnchor constraintEqualToAnchor: self.view.topAnchor constant:20].active = YES;

    [self.uberbutton.widthAnchor constraintEqualToConstant:190].active = YES;
    [self.uberbutton.heightAnchor constraintEqualToConstant:40].active = YES;
    [self.uberbutton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;


    [[BTNDropinButton appearance] setContentInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 10.0)];
    [[BTNDropinButton appearance] setIconSize:26.0];
    [[BTNDropinButton appearance] setIconLabelSpacing:13.0];
    [[BTNDropinButton appearance] setFont:[UIFont systemFontOfSize:12.0]];
    [[BTNDropinButton appearance] setBorderWidth:1];
    [[BTNDropinButton appearance] setCornerRadius: 5.0];
    [[BTNDropinButton appearance] setHighlightedBackgroundColor:[UIColor lightGrayColor]];
    [[BTNDropinButton appearance] setHighlightedTextColor:[UIColor whiteColor]];


    //    // Setup your context.
    //    BTNLocation *userLocation = [BTNLocation locationWithLatitude:<#latitude#> longitude:<#longitude#>];
    //    BTNContext *context = [BTNContext contextWithUserLocation:userLocation];

    BTNLocation *location = [BTNLocation locationWithName:@"Parm"
                                                 latitude:40.7237889
                                                longitude:-73.997];
    BTNContext *context = [BTNContext contextWithSubjectLocation:location];

    [self.uberbutton prepareWithContext:context completion:^(BOOL isDisplayable) {
        if (!isDisplayable) {
            // If a button has no action, it completes as not displayable.
        }
    }];

}

@end
